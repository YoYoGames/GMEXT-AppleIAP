//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import "iOS_InAppPurchase.h"
#import <StoreKit/StoreKit.h>
#import "iOS_TransactionListener.h"
#import "iOS_StoreManager.h"
#include "iOS_IAPEnums.h"

#include "VerifyStoreReceipt.h"

NSString * global_bundleVersion = nil;
NSString * global_bundleIdentifier = nil;

@implementation iOS_InAppPurchase

@synthesize m_products;

- (void) dealloc
{
    [self.m_products release];
    [super dealloc];
}

- (double) ios_iap_Init
{
    // it turns out, it's a bad idea, to use these two NSBundle methods in your app:
	//
	// bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	// bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	//
	// http://www.craftymind.com/2011/01/06/mac-app-store-hacked-how-developers-can-better-protect-themselves/
	//
	// so use hard coded values instead (probably even somehow obfuscated)
    global_bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    global_bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    self.m_products = [[NSMutableArray alloc] initWithCapacity:0];
    [self.m_products retain];
    return no_error;
}

- (double) ios_iap_IsAuthorisedForPayment
{
    // Boolean return;
    BOOL authorised = [SKPaymentQueue canMakePayments];
    return authorised ? 1.0 : 0.0;
}

- (double) ios_iap_AddProduct:(NSString*)_productName
{
    if (self.m_products == nil)
    {
        return error_extension_not_initialised;
    }

    for (int i = 0; i < [self.m_products count]; ++i)
    {
        NSString* entry = self.m_products[i];
        if (entry != nil)
        {
            if ([entry isEqualToString:_productName])
            {
                return error_duplicate_product;
            }
        }
    }

    [self.m_products addObject:_productName];
    return no_error;
}

- (double) ios_iap_QueryProducts
{
    [[iOS_StoreManager sharedInstance] startProductRequestWithIdentifiers:self.m_products];
    return no_error;
}

- (NSString*) ios_iap_QueryPurchases
{
    return [[iOS_TransactionListener sharedInstance] queryPurchases];
}

- (double) ios_iap_PurchaseProduct:(NSString*)_productName
{
    if (self.m_products == nil)
    {
        return error_extension_not_initialised;
    }

    if ((self.m_products).count == 0)
    {
        return error_no_skus;
    }

    return [[iOS_StoreManager sharedInstance] startPaymentRequestWithIdentifier:_productName];
}

- (double) ios_iap_RestorePurchases
{
    if (self.m_products == nil)
    {
        return error_extension_not_initialised;
    }

    if ((self.m_products).count == 0)
    {
        return error_no_skus;
    }

    [[iOS_StoreManager sharedInstance] restorePurchases];

    return no_error;
}

- (double) ios_iap_FinishTransaction:(NSString*)_transactionId
{
    return [[iOS_TransactionListener sharedInstance] finishTransaction:_transactionId];
}

- (NSString*) ios_iap_GetReceipt
{
    NSURL* url = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData* receiptData = [NSData dataWithContentsOfURL:url];
    NSString *receiptStr = [receiptData base64EncodedStringWithOptions:0];
    
    // TODO: Some basic validation here. https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateLocally.html#//apple_ref/doc/uid/TP40010573-CH1-SW2
    
    //temp
    
    
    return receiptStr;
}

- (double) ios_iap_RefreshReceipt
{
    if (self.m_products == nil)
    {
        return error_extension_not_initialised;
    }

    if ((self.m_products).count == 0)
    {
        return error_no_skus;
    }

    [[iOS_StoreManager sharedInstance] refreshReceipt];

    return no_error;
}

- (double) ios_iap_ValidateReceipt
{
    BOOL valid = verifyReceiptUsingURL( [[NSBundle mainBundle] appStoreReceiptURL] );
    
    // Boolean return.
    return valid == YES ? 1.0 : 0.0;
}

///////////////////////////////////Callbacks
- (void) Init //-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"IAPs willFinishLaunchingWithOptions without delegate :)");
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[iOS_TransactionListener sharedInstance]];
}
- (void) onStop //-(void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"IAPs applicationWillTerminate without delegate :)");
    // Remove the observer.
    [[SKPaymentQueue defaultQueue] removeTransactionObserver: [iOS_TransactionListener sharedInstance]];
}

@end
