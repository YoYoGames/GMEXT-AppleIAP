//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import "iOS_TransactionListener.h"
#import "iOS_InAppPurchase.h"
#include "iOS_IAPEnums.h"

#if TARGET_OS_OSX
#import "Extension_Interface.h"
#include "YYRValue.h"
#include <sstream>
#endif

#if !TARGET_OS_OSX
extern "C" void dsMapClear(int _dsMap );
extern "C" int dsMapCreate();
extern "C" void dsMapAddInt(int _dsMap, char* _key, int _value);
extern "C" void dsMapAddString(int _dsMap, char* _key, char* _value);

extern "C" int dsListCreate();
extern "C" void dsListAddInt(int _dsList, int _value);
extern "C" void dsListAddString(int _dsList, char* _value);
extern "C" const char* dsListGetValueString(int _dsList, int _listIdx);
extern "C" double dsListGetValueDouble(int _dsList, int _listIdx);
extern "C" int dsListGetSize(int _dsList);

extern "C" void CreateAsyncEventOfTypeWithDSMap(int dsmapindex, int event_index);
#endif

const int EVENT_OTHER_WEB_IAP = 66;

@implementation iOS_TransactionListener

@synthesize m_activeTransactions;

+ (iOS_TransactionListener *)sharedInstance {
    static dispatch_once_t onceToken;
    static iOS_TransactionListener * transactionListenerSharedInstance;
    
    dispatch_once(&onceToken, ^{
        transactionListenerSharedInstance = [[iOS_TransactionListener alloc] init];
    });
    return transactionListenerSharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        m_activeTransactions = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void) dealloc
{
    [self.m_activeTransactions release];
    
    [super dealloc];
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions
{
    NSMutableArray<SKPaymentTransaction*>* mTransactions = [[NSMutableArray alloc] initWithArray:transactions];
    
    NSString* jsonResponse = [self parsePaymentTransactionsIntoJson:mTransactions];

    char jId[3];
    sprintf(jId, "id");
    char jResponse[20];
    sprintf(jResponse, "response_json");

    int dsMapIndex = CreateDsMap_comaptibility_();
    DsMapAddDouble_comaptibility_(dsMapIndex, jId, payment_queue_update);
    DsMapAddString_comaptibility_(dsMapIndex, jResponse, const_cast<char*>([jsonResponse UTF8String]));
    CreateAsyncEventWithDSMap_comaptibility_(dsMapIndex);
}

- (NSString*) parsePaymentTransactionsIntoJson:(nonnull NSArray<SKPaymentTransaction*>*)transactions
{
    NSMutableArray* jsonTransactions = [[NSMutableArray alloc] initWithCapacity:transactions.count];
    for (SKPaymentTransaction* transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
                
            case SKPaymentTransactionStateDeferred:
                //NSLog(@"%@", PCSMessagesDeferred);
                break;
                
            case SKPaymentTransactionStatePurchased:
            {
                NSString* res = [self handlePurchasedTransaction:transaction];
                [jsonTransactions addObject:res];
                break;
            }
                
            case SKPaymentTransactionStateFailed:
            {
                NSString* res = [self handleFailedTransaction:transaction];
                if(res!=nil)
                    [jsonTransactions addObject:res];
                break;
            }
                
            case SKPaymentTransactionStateRestored:
            {
                NSString* res = [self handleRestoredTransaction:transaction];
                [jsonTransactions addObject:res];
                break;
            }
            default: break;
        }
    }
    
    NSMutableString* jsonResponse = [[NSMutableString alloc] initWithString:@"{\"purchases\":["];
    for (int transactionIndex = 0; transactionIndex < jsonTransactions.count; ++transactionIndex)
    {
        [jsonResponse appendString:jsonTransactions[transactionIndex]];
        if ((transactionIndex + 1) < jsonTransactions.count)
        {
            [jsonResponse appendString:@","];
        }
    }
    
    [jsonResponse appendString:@"]}"];
    return jsonResponse;
}

/// Handles successful purchase transactions.
-(NSString*)handlePurchasedTransaction:(SKPaymentTransaction*)transaction
{
    [m_activeTransactions setValue:transaction forKey:transaction.transactionIdentifier];
    
    const char* product = [transaction.payment.productIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
    const char* receipt = [[self getReceiptData:transaction] cStringUsingEncoding:NSUTF8StringEncoding];
    const char* token = [transaction.transactionIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Receipt data could be quite large so don't risk overrunning a fixed sized buffer
    char* json = (char*)alloca(strlen(product) + strlen(receipt) + strlen(token) + 256);
    sprintf(json, "{ \"productId\":\"%s\", \"purchaseState\":%d, \"responseCode\":%d, \"purchaseToken\":\"%s\", \"receipt\":\"%s\" }", product, (int)purchase_success, (int)transaction.transactionState, token, receipt);
    
    return [[[NSString alloc] initWithCString:json encoding:NSASCIIStringEncoding] autorelease];
}

/// Handles failed purchase transactions.
-(NSString*)handleFailedTransaction:(SKPaymentTransaction*)transaction
{
	if(transaction!=nil)
	{
		const char* product = [transaction.payment.productIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
		const char* receipt = [[self getReceiptData:transaction] cStringUsingEncoding:NSUTF8StringEncoding];
		
		if(transaction.transactionIdentifier!=nil)
		{
			const char* token = [transaction.transactionIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
			
			[m_activeTransactions setValue:transaction forKey:transaction.transactionIdentifier];
			
			// Receipt data could be quite large so don't risk overrunning a fixed sized buffer
			char* json = (char*)alloca(strlen(product) + strlen(receipt) + strlen(token) + 256);
			sprintf(json, "{ \"productId\":\"%s\", \"purchaseState\":%d, \"responseCode\":%d, \"purchaseToken\":\"%s\", \"receipt\":\"%s\" }", product, (int)purchase_failed, (int)transaction.transactionState, token, receipt);
			
			return [[[NSString alloc] initWithCString:json encoding:NSASCIIStringEncoding] autorelease];
		}
		else
		{
			// Return so Cancelled transaction can be handled
			char jId[3];
			sprintf(jId, "id");
			char jResponse[20];
			sprintf(jResponse, "response_json");
			int dsMapIndex = CreateDsMap_comaptibility_();
            DsMapAddDouble_comaptibility_(dsMapIndex, jId, payment_queue_update);
			NSLog([[NSString alloc] initWithCString:product encoding:NSUTF8StringEncoding]);
			
			char* json = (char*)alloca(strlen(product) + 256);
			sprintf(json, "{\"cancelled\":\"true\", \"product\":\"%s\"}", product);
			
            DsMapAddString_comaptibility_(dsMapIndex, jResponse, const_cast<char*>(json));
            CreateAsyncEventWithDSMap_comaptibility_(dsMapIndex);
            
			return nil;
		}
	}
	return nil;
}

/// Handles restored purchase transactions.
-(NSString*)handleRestoredTransaction:(SKPaymentTransaction*)transaction
{
    [m_activeTransactions setValue:transaction forKey:transaction.transactionIdentifier];
    
    const char* product = [transaction.payment.productIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
    const char* receipt = [[self getReceiptData:transaction] cStringUsingEncoding:NSUTF8StringEncoding];
    const char* token = [transaction.transactionIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Receipt data could be quite large so don't risk overrunning a fixed sized buffer
    char* json = (char*)alloca(strlen(product) + strlen(receipt) + strlen(token) + 256);
    sprintf(json, "{ \"productId\":\"%s\", \"purchaseState\":%d, \"responseCode\":%d, \"purchaseToken\":\"%s\", \"receipt\":\"%s\" }", product, (int)purchase_restored, (int)transaction.transactionState, token, receipt);
    
    return [[[NSString alloc] initWithCString:json encoding:NSASCIIStringEncoding] autorelease];
}

- (NSString*)queryPurchases
{
    NSMutableArray<SKPaymentTransaction*>* mTransactions = [[NSMutableArray alloc] initWithCapacity:m_activeTransactions.count];

    for (NSString* key in m_activeTransactions)
    {
        [mTransactions addObject: m_activeTransactions[key]];
    }
    return [self parsePaymentTransactionsIntoJson:mTransactions];
}

- (double)finishTransaction:(NSString *)purchaseToken
{
    SKPaymentTransaction* paymentTransaction = [m_activeTransactions objectForKey:purchaseToken];
    if (paymentTransaction != nil)
    {
        [m_activeTransactions removeObjectForKey:purchaseToken];
        [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
        return no_error;
    }
    return error_unknown;
}

// Turn receipt data received in an SKPaymentTransaction into an easier form to communicate
- (NSString*)getReceiptData:(SKPaymentTransaction *)transaction
{
#if !TARGET_OS_OSX
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    int length = transaction.transactionReceipt.length;
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* input = (uint8_t*)transaction.transactionReceipt.bytes;
    uint8_t* output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
#else
    return @"";
#endif
}

- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product
{
    
    int map = CreateDsMap_comaptibility_();
    
    char jId[3];
    sprintf(jId, "id");
    DsMapAddDouble_comaptibility_(map,jId,promotion_purchase);
    
    NSMutableDictionary* productMap = [iOS_InAppPurchase product2map:product];

    NSError* pError = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:productMap options:0 error:&pError];
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    DsMapAddString_comaptibility_(map,"product",[jsonStr UTF8String]);
    CreateAsyncEventWithDSMap_comaptibility_(map);
    
    [productMap release];
    [jsonStr release];
    
    return false;
}

@end
