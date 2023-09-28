//
//  validatereceipt.m
//
//  Based on validatereceipt.m
//  Created by Ruotger Skupin on 23.10.10.
//  Copyright 2010-2011 Matthew Stevens, Ruotger Skupin, Apple, Dave Carlton, Fraser Hess, anlumo, David Keegan, Alessandro Segala. All rights reserved.
//
//  Modified for iOS, converted to ARC, and added additional fields by Rick Maddy 2013-08-20
//  Copyright 2013 Rick Maddy. All rights reserved.
//

/*
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in
 the documentation and/or other materials provided with the distribution.
 
 Neither the name of the copyright holders nor the names of its contributors may be used to endorse or promote products derived
 from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "VerifyStoreReceipt.h"

// link with Foundation.framework, Security.framework, libssl and libCrypto (via -lssl -lcrypto in Other Linker Flags)

#import <Security/Security.h>
#import <UIKit/UIKit.h>

#include "pkcs7.h"
#include "objects.h"
#include "sha.h"
#include "x509.h"
#include "err.h"


//#ifndef YES_I_HAVE_READ_THE_WARNING_AND_I_ACCEPT_THE_RISK

//#warning --- DON'T USE THIS CODE AS IS! IF EVERYONE USES THE SAME CODE
//#warning --- IT IS PRETTY EASY TO BUILD AN AUTOMATIC CRACKING TOOL
//#warning --- FOR APPS USING THIS CODE!
//#warning --- BY USING THIS CODE YOU ACCEPT TAKING THE RESPONSIBILITY FOR
//#warning --- ANY DAMAGE!
//#warning ---
//#warning --- YOU HAVE BEEN WARNED!

// if you want to take that risk, add "-DYES_I_HAVE_READ_THE_WARNING_AND_I_ACCEPT_THE_RISK" in the build settings at "Other C Flags"

//#endif // YES_I_HAVE_READ_THE_WARNING_AND_I_ACCEPT_THE_RISK

#define VRCFRelease(object) if(object) CFRelease(object)

NSString *kReceiptBundleIdentifier				= @"BundleIdentifier";
NSString *kReceiptBundleIdentifierData			= @"BundleIdentifierData";
NSString *kReceiptVersion						= @"Version";
NSString *kReceiptOpaqueValue					= @"OpaqueValue";
NSString *kReceiptHash							= @"Hash";
NSString *kReceiptInApp							= @"InApp";
NSString *kReceiptOriginalVersion               = @"OrigVer";
NSString *kReceiptExpirationDate                = @"ExpDate";

NSString *kReceiptInAppQuantity					= @"Quantity";
NSString *kReceiptInAppProductIdentifier		= @"ProductIdentifier";
NSString *kReceiptInAppTransactionIdentifier	= @"TransactionIdentifier";
NSString *kReceiptInAppPurchaseDate				= @"PurchaseDate";
NSString *kReceiptInAppOriginalTransactionIdentifier	= @"OriginalTransactionIdentifier";
NSString *kReceiptInAppOriginalPurchaseDate		= @"OriginalPurchaseDate";
NSString *kReceiptInAppSubscriptionExpirationDate = @"SubExpDate";
NSString *kReceiptInAppCancellationDate         = @"CancelDate";
NSString *kReceiptInAppWebOrderLineItemID       = @"WebItemId";


NSData *appleRootCert(void) {
    // Obtain the Apple Inc. root certificate from http://www.apple.com/certificateauthority/
    // Download the Apple Inc. Root Certificate ( http://www.apple.com/appleca/AppleIncRootCertificate.cer )
    // Add the AppleIncRootCertificate.cer to your app's resource bundle.

    NSData *cert = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"appleincrootcertificate" withExtension:@"cer" subdirectory:@"games"]];
    
	return cert;
}

// ASN.1 values for In-App Purchase values
#define INAPP_ATTR_START	1700
#define INAPP_QUANTITY		1701
#define INAPP_PRODID		1702
#define INAPP_TRANSID		1703
#define INAPP_PURCHDATE		1704
#define INAPP_ORIGTRANSID	1705
#define INAPP_ORIGPURCHDATE	1706
#define INAPP_ATTR_END		1707
#define INAPP_SUBEXP_DATE   1708
#define INAPP_WEBORDER      1711
#define INAPP_CANCEL_DATE   1712

NSArray *parseInAppPurchasesData(NSData *inappData) {
	int type = 0;
	int xclass = 0;
	long length = 0;
    
	NSUInteger dataLenght = [inappData length];
	const uint8_t *p = (const uint8_t*)[inappData bytes];
    
	const uint8_t *end = p + dataLenght;
    
	NSMutableArray *resultArray = [NSMutableArray array];
    
	while (p < end) {
		ASN1_get_object(&p, &length, &type, &xclass, end - p);
        
		const uint8_t *set_end = p + length;
        
		if(type != V_ASN1_SET) {
			break;
		}
        
		NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithCapacity:6];
        
		while (p < set_end) {
			ASN1_get_object(&p, &length, &type, &xclass, set_end - p);
			if (type != V_ASN1_SEQUENCE) {
				break;
            }
            
			const uint8_t *seq_end = p + length;
            
			int attr_type = 0;
			int attr_version = 0;
            
			// Attribute type
			ASN1_get_object(&p, &length, &type, &xclass, seq_end - p);
			if (type == V_ASN1_INTEGER) {
				if(length == 1) {
					attr_type = p[0];
				}
				else if(length == 2) {
					attr_type = p[0] * 0x100 + p[1]
					;
				}
			}
			p += length;
            
			// Attribute version
			ASN1_get_object(&p, &length, &type, &xclass, seq_end - p);
			if (type == V_ASN1_INTEGER && length == 1) {
                // clang analyser hit (wontfix at the moment, since the code might come in handy later)
                // But if someone has a convincing case throwing that out, I might do so, Roddi
				attr_version = p[0];
			}
			p += length;
            
			// Only parse attributes we're interested in
			if ((attr_type > INAPP_ATTR_START && attr_type < INAPP_ATTR_END) || attr_type == INAPP_SUBEXP_DATE || attr_type == INAPP_WEBORDER || attr_type == INAPP_CANCEL_DATE) {
				NSString *key = nil;
                
				ASN1_get_object(&p, &length, &type, &xclass, seq_end - p);
				if (type == V_ASN1_OCTET_STRING) {
					//NSData *data = [NSData dataWithBytes:p length:(NSUInteger)length];
                    
					// Integers
					if (attr_type == INAPP_QUANTITY || attr_type == INAPP_WEBORDER) {
						int num_type = 0;
						long num_length = 0;
						const uint8_t *num_p = p;
						ASN1_get_object(&num_p, &num_length, &num_type, &xclass, seq_end - num_p);
						if (num_type == V_ASN1_INTEGER) {
							NSUInteger quantity = 0;
							if (num_length) {
								quantity += num_p[0];
								if (num_length > 1) {
									quantity += num_p[1] * 0x100;
									if (num_length > 2) {
										quantity += num_p[2] * 0x10000;
										if (num_length > 3) {
											quantity += num_p[3] * 0x1000000;
										}
									}
								}
							}
                            
							NSNumber *num = [[NSNumber alloc] initWithUnsignedInteger:quantity];
                            if (attr_type == INAPP_QUANTITY) {
                                [item setObject:num forKey:kReceiptInAppQuantity];
                            } else if (attr_type == INAPP_WEBORDER) {
                                [item setObject:num forKey:kReceiptInAppWebOrderLineItemID];
                            }
						}
					}
                    
					// Strings
					if (attr_type == INAPP_PRODID ||
                        attr_type == INAPP_TRANSID ||
                        attr_type == INAPP_ORIGTRANSID ||
                        attr_type == INAPP_PURCHDATE ||
                        attr_type == INAPP_ORIGPURCHDATE ||
                        attr_type == INAPP_SUBEXP_DATE ||
                        attr_type == INAPP_CANCEL_DATE) {
                        
						int str_type = 0;
						long str_length = 0;
						const uint8_t *str_p = p;
						ASN1_get_object(&str_p, &str_length, &str_type, &xclass, seq_end - str_p);
						if (str_type == V_ASN1_UTF8STRING) {
							switch (attr_type) {
								case INAPP_PRODID:
									key = kReceiptInAppProductIdentifier;
									break;
								case INAPP_TRANSID:
									key = kReceiptInAppTransactionIdentifier;
									break;
								case INAPP_ORIGTRANSID:
									key = kReceiptInAppOriginalTransactionIdentifier;
									break;
							}
                            
							if (key) {
								NSString *string = [[NSString alloc] initWithBytes:str_p
																			length:(NSUInteger)str_length
																		  encoding:NSUTF8StringEncoding];
								[item setObject:string forKey:key];
							}
						}
						if (str_type == V_ASN1_IA5STRING) {
							switch (attr_type) {
								case INAPP_PURCHDATE:
									key = kReceiptInAppPurchaseDate;
									break;
								case INAPP_ORIGPURCHDATE:
									key = kReceiptInAppOriginalPurchaseDate;
									break;
								case INAPP_SUBEXP_DATE:
									key = kReceiptInAppSubscriptionExpirationDate;
									break;
								case INAPP_CANCEL_DATE:
									key = kReceiptInAppCancellationDate;
									break;
							}
                            
							if (key) {
								NSString *string = [[NSString alloc] initWithBytes:str_p
																			length:(NSUInteger)str_length
																		  encoding:NSASCIIStringEncoding];
								[item setObject:string forKey:key];
							}
						}
					}
				}
                
				p += length;
			}
            
			// Skip any remaining fields in this SEQUENCE
			while (p < seq_end) {
				ASN1_get_object(&p, &length, &type, &xclass, seq_end - p);
				p += length;
			}
		}
        
		// Skip any remaining fields in this SET
		while (p < set_end) {
			ASN1_get_object(&p, &length, &type, &xclass, set_end - p);
			p += length;
		}
        
		[resultArray addObject:item];
	}
    
	return resultArray;
}

// ASN.1 values for the App Store receipt
#define ATTR_START 1
#define BUNDLE_ID 2
#define VERSION 3
#define OPAQUE_VALUE 4
#define HASH 5
#define ATTR_END 6
#define INAPP_PURCHASE 17
#define ORIG_VERSION 19
#define EXPIRE_DATE 21

NSDictionary *dictionaryWithAppStoreReceipt(NSURL *receiptURL) {
	
	ERR_load_PKCS7_strings();
	ERR_load_X509_strings();
    
	// Expected input is a PKCS7 container with signed data containing
	// an ASN.1 SET of SEQUENCE structures. Each SEQUENCE contains
	// two INTEGERS and an OCTET STRING.
    NSData* receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    // Create a memory buffer to extract the PKCS #7 container
    BIO *receiptBIO = BIO_new(BIO_s_mem());
    BIO_write(receiptBIO, [receiptData bytes], (int) [receiptData length]);
    PKCS7 *receiptPKCS7 = d2i_PKCS7_bio(receiptBIO, NULL);
    if (!receiptPKCS7) {
        return nil;
    }

    // Check that the container has a signature
    if (!PKCS7_type_is_signed(receiptPKCS7)) {
        return nil;
    }

    // Check that the signed container has actual data
    if (!PKCS7_type_is_data(receiptPKCS7->d.sign->contents)) {
        return nil;
    }
    
    // Load the Apple Root CA (downloaded from https://www.apple.com/certificateauthority/)
    NSData *appleRootData = appleRootCert();
    BIO *appleRootBIO = BIO_new(BIO_s_mem());
    BIO_write(appleRootBIO, (const void *) [appleRootData bytes], (int) [appleRootData length]);
    X509 *appleRootX509 = d2i_X509_bio(appleRootBIO, NULL);

    // Create a certificate store
    X509_STORE *store = X509_STORE_new();
    X509_STORE_add_cert(store, appleRootX509);

    // Be sure to load the digests before the verification
    OpenSSL_add_all_digests();
    
    // Check the signature
    int result = PKCS7_verify(receiptPKCS7, NULL, store, NULL, NULL, 0);
            
    X509_free(appleRootX509);
    X509_STORE_free(store);
    
    if (result != 1) {
        unsigned long error = ERR_get_error();
        const char* error_str = ERR_error_string(error, NULL);
        printf("OpenSSL Error --> %s\n", error_str);
        
        PKCS7_free(receiptPKCS7);
        return nil;
    }
    
	ASN1_OCTET_STRING *octets = receiptPKCS7->d.sign->contents->d.data;
	const uint8_t *p = octets->data;
	const uint8_t *end = p + octets->length;
    
	int type = 0;
	int xclass = 0;
	long length = 0;
    
	ASN1_get_object(&p, &length, &type, &xclass, end - p);
	if (type != V_ASN1_SET) {
		PKCS7_free(receiptPKCS7);
		return nil;
	}
    
	NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
	while (p < end) {
		ASN1_get_object(&p, &length, &type, &xclass, end - p);
		if (type != V_ASN1_SEQUENCE) {
			break;
        }
        
		const uint8_t *seq_end = p + length;
        
		int attr_type = 0;
		int attr_version = 0;
        
		// Attribute type
		ASN1_get_object(&p, &length, &type, &xclass, seq_end - p);
		if (type == V_ASN1_INTEGER && length == 1) {
			attr_type = p[0];
		}
		p += length;
        
		// Attribute version
		ASN1_get_object(&p, &length, &type, &xclass, seq_end - p);
		if (type == V_ASN1_INTEGER && length == 1) {
			attr_version = p[0];
			attr_version = attr_version;
		}
		p += length;
        
		// Only parse attributes we're interested in
		if ((attr_type > ATTR_START && attr_type < ATTR_END) || attr_type == INAPP_PURCHASE || attr_type == ORIG_VERSION || attr_type == EXPIRE_DATE) {
			NSString *key = nil;
            
			ASN1_get_object(&p, &length, &type, &xclass, seq_end - p);
			if (type == V_ASN1_OCTET_STRING) {
                NSData *data = [NSData dataWithBytes:p length:(NSUInteger)length];
                
				// Bytes
				if (attr_type == BUNDLE_ID || attr_type == OPAQUE_VALUE || attr_type == HASH) {
					switch (attr_type) {
						case BUNDLE_ID:
							// This is included for hash generation
							key = kReceiptBundleIdentifierData;
							break;
						case OPAQUE_VALUE:
							key = kReceiptOpaqueValue;
							break;
						case HASH:
							key = kReceiptHash;
							break;
					}
					if (key) {
                        [info setObject:data forKey:key];
                    }
				}
                
				// Strings
				if (attr_type == BUNDLE_ID || attr_type == VERSION || attr_type == ORIG_VERSION) {
					int str_type = 0;
					long str_length = 0;
					const uint8_t *str_p = p;
					ASN1_get_object(&str_p, &str_length, &str_type, &xclass, seq_end - str_p);
					if (str_type == V_ASN1_UTF8STRING) {
						switch (attr_type) {
							case BUNDLE_ID:
								key = kReceiptBundleIdentifier;
								break;
							case VERSION:
								key = kReceiptVersion;
								break;
                            case ORIG_VERSION:
                                key = kReceiptOriginalVersion;
                                break;
						}
                        
						if (key) {
                            NSString *string = [[NSString alloc] initWithBytes:str_p
																		length:(NSUInteger)str_length
                                                                      encoding:NSUTF8StringEncoding];
                            [info setObject:string forKey:key];
						}
					}
				}
                
				// In-App purchases
				if (attr_type == INAPP_PURCHASE) {
					NSArray *inApp = parseInAppPurchasesData(data);
                    NSArray *current = info[kReceiptInApp];
                    if (current) {
                        info[kReceiptInApp] = [current arrayByAddingObjectsFromArray:inApp];
                    } else {
                        [info setObject:inApp forKey:kReceiptInApp];
                    }
				}
			}
			p += length;
		}
        
		// Skip any remaining fields in this SEQUENCE
		while (p < seq_end) {
			ASN1_get_object(&p, &length, &type, &xclass, seq_end - p);
			p += length;
		}
	}
    
	PKCS7_free(receiptPKCS7);
    
	return info;
}


NSArray *obtainInAppPurchases(NSString *receiptPath) {
	// According to the documentation, we need to validate the receipt first.
	// If the receipt is not valid, no In-App purchase is valid.
	// This performs a "quick" validation. Please use validateReceiptAtPath to perform a full validation.
    
	NSDictionary *receipt = dictionaryWithAppStoreReceipt(receiptPath);
	if (!receipt) {
		return nil;
    }
    
	NSArray *purchases = [receipt objectForKey:kReceiptInApp];
	if(!purchases || ![purchases isKindOfClass:[NSArray class]]) {
		return nil;
    }
    
	return purchases;
}

extern NSString * global_bundleVersion;
extern NSString * global_bundleIdentifier;

// in your project define those two somewhere as such:
// const NSString * global_bundleVersion = @"1.0.2";
// const NSString * global_bundleIdentifier = @"com.example.SampleApp";

BOOL verifyReceiptWithURL(NSURL *receiptURL) {
	// it turns out, it's a bad idea, to use these two NSBundle methods in your app:
	//
	// bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	// bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	//
	// http://www.craftymind.com/2011/01/06/mac-app-store-hacked-how-developers-can-better-protect-themselves/
	//
	// so use hard coded values instead (probably even somehow obfuscated)
    
	NSString *bundleVersion = (NSString*)global_bundleVersion;
	NSString *bundleIdentifier = (NSString*)global_bundleIdentifier;

	// avoid making stupid mistakes --> check again
	NSCAssert([bundleVersion isEqualToString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]],
              @"whoops! check the hard-coded CFBundleVersion!");
	NSCAssert([bundleIdentifier isEqualToString:[[NSBundle mainBundle] bundleIdentifier]],
              @"whoops! check the hard-coded bundle identifier!");
	NSDictionary *receipt = dictionaryWithAppStoreReceipt(receiptURL);
    
	if (!receipt) {
		return NO;
    }
    
    unsigned char uuidBytes[16];
    NSUUID *vendorUUID = [[UIDevice currentDevice] identifierForVendor];
    [vendorUUID getUUIDBytes:uuidBytes];
    
	NSMutableData *input = [NSMutableData data];
	[input appendBytes:uuidBytes length:sizeof(uuidBytes)];
	[input appendData:[receipt objectForKey:kReceiptOpaqueValue]];
	[input appendData:[receipt objectForKey:kReceiptBundleIdentifierData]];
    
	NSMutableData *hash = [NSMutableData dataWithLength:SHA_DIGEST_LENGTH];
	SHA1((const unsigned char*)[input bytes], [input length], (unsigned char*)[hash mutableBytes]);
    
	if ([bundleIdentifier isEqualToString:[receipt objectForKey:kReceiptBundleIdentifier]] &&
        [bundleVersion isEqualToString:[receipt objectForKey:kReceiptVersion]] &&
        [hash isEqualToData:[receipt objectForKey:kReceiptHash]]) {
		return YES;
	}
    
	return NO;
}
