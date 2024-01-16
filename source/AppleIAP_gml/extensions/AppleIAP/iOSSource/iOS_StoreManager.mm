//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import "iOS_StoreManager.h"
#include "iOS_InAppPurchase.h"
#include "iOS_IAPEnums.h"


@interface iOS_StoreManager()<SKRequestDelegate, SKProductsRequestDelegate>

@property (retain) SKProductsRequest *productRequest;

@end

@implementation iOS_StoreManager


@synthesize m_validIaps;
@synthesize m_invalidIaps;


+ (iOS_StoreManager *)sharedInstance
{
	static dispatch_once_t onceToken;
	static iOS_StoreManager * storeManagerSharedInstance;

	dispatch_once(&onceToken, ^
    {
		storeManagerSharedInstance = [[iOS_StoreManager alloc] init];
	});
	return storeManagerSharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        m_validIaps = [[NSMutableArray alloc] initWithCapacity:0];
        m_invalidIaps = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void) dealloc
{
    [self.m_validIaps release];
    [self.m_invalidIaps release];
    
    [super dealloc];
}

- (void) startProductRequestWithIdentifiers:(NSArray *)identifiers
{
    // Create a set for the product identifiers.
	NSSet *productIdentifiers = [NSSet setWithArray:identifiers];

	// Initialize the product request with the above identifiers.
	self.productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
	self.productRequest.delegate = self;

	// Send the request to the App Store.
	[self.productRequest start];   
}


- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response
{
    NSLog(@"productsRequest called");
    
    if (self.m_validIaps.count > 0)
    {
        [self.m_validIaps removeAllObjects];
    }
    if (self.m_invalidIaps.count > 0)
    {
        [self.m_invalidIaps removeAllObjects];
    }
    
    if ((response.products).count > 0)
    {
        self.m_validIaps = [NSMutableArray arrayWithArray:response.products];
    }
    
    if ((response.invalidProductIdentifiers).count > 0)
    {
        self.m_invalidIaps = [NSMutableArray arrayWithArray:response.invalidProductIdentifiers];
    }
    
    NSMutableDictionary* results = [[NSMutableDictionary alloc] init];
    NSMutableArray* valid = [[NSMutableArray alloc] init];
    NSMutableArray* invalid = [[NSMutableArray alloc] init];
    
    for (SKProduct* product in self.m_validIaps)
    {
        NSMutableDictionary* productMap = [iOS_InAppPurchase product2map:product];
        
        [valid addObject:productMap];
    }
    results[@"valid"] = valid;
    
    for (NSString* product in self.m_invalidIaps)
    {
        [invalid addObject:product];
    }
    results[@"invalid"] = invalid;
    
    NSError* pError = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:results options:0 error:&pError];
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Async
    char jId[3];
    sprintf(jId, "id");
    char jResponse[20];
    sprintf(jResponse, "response_json");
    
    int dsMapIndex = CreateDsMap_comaptibility_();
    DsMapAddDouble_comaptibility_(dsMapIndex, jId, product_update);
    DsMapAddString_comaptibility_(dsMapIndex, jResponse, const_cast<char*>([jsonStr UTF8String]));
    CreateAsyncEventWithDSMap_comaptibility_(dsMapIndex);
    
    [results release];
    [jsonStr release];
}

- (double) startPaymentRequestWithIdentifier:(NSString *)identifier
{
    if ((self.m_validIaps).count == 0)
    {
        return (int)error_no_skus;
    }
    
    SKProduct* foundProduct = nil;
    for (int i = 0; i < ((self.m_validIaps).count); ++i)
    {
        SKProduct* product = self.m_validIaps[i];
        if ([product.productIdentifier isEqualToString:identifier])
        {
            foundProduct = product;
            break;
        }
    }
    
    if (foundProduct != nil)
    {
        SKMutablePayment* payment = [SKMutablePayment paymentWithProduct:foundProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
    return (int)no_error;
}

- (void) restorePurchases
{
//    if (self.productsRestored.count > 0) {
//        [self.productsRestored removeAllObjects];
//    }
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) refreshReceipt
{
    SKReceiptRefreshRequest* refreshReceiptRequest = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
    [refreshReceiptRequest setDelegate:self];
    [refreshReceiptRequest start];
}

- (void)requestDidFinish:(SKRequest *)request
{
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]])
    {
        int dsMapIndex = CreateDsMap_comaptibility_();
        char jId[3];
        sprintf(jId, "id");
        char jResponse[20];
        sprintf(jResponse, "status");
        DsMapAddDouble_comaptibility_(dsMapIndex, jId, receipt_refresh);
        
        DsMapAddDouble_comaptibility_(dsMapIndex, jResponse, receipt_refresh_success);
        
        CreateAsyncEventWithDSMap_comaptibility_(dsMapIndex);
    }
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]])
    {
        int dsMapIndex = CreateDsMap_comaptibility_();
        char jId[3];
        sprintf(jId, "id");
        char jResponse[20];
        sprintf(jResponse, "status");
        DsMapAddDouble_comaptibility_(dsMapIndex, jId, receipt_refresh);
        
        DsMapAddDouble_comaptibility_(dsMapIndex, jResponse, receipt_refresh_failure);
        
        CreateAsyncEventWithDSMap_comaptibility_(dsMapIndex);
    }
}

- (double) iapPromotionOrderUpdate:(NSString *)products
{
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[products dataUsingEncoding:NSUTF8StringEncoding]options:0 error:NULL];
    
    NSMutableArray *products_nstive = [NSMutableArray new];
    
    if ((self.m_validIaps).count == 0)
    {
        return (int)error_no_skus;
    }
    
    for(NSString *str in jsonObject)
    for (int i = 0; i < ((self.m_validIaps).count); ++i)
    {
        SKProduct* product = self.m_validIaps[i];
        if ([product.productIdentifier isEqualToString:str])
        {
            [products_nstive addObject:product];
            break;
        }
    }
    
    if (@available(iOS 11.0, tvOS 11.0, macOS 11.0, macCatalyst 14.0, *))
    [[SKProductStorePromotionController defaultController] updateStorePromotionOrder:products_nstive completionHandler:^(NSError * _Nullable error)
     {
        int dsMapIndex = CreateDsMap_comaptibility_();
        DsMapAddDouble_comaptibility_(dsMapIndex, "id", promotion_order_update);
        
        if(error)
        {
            DsMapAddDouble_comaptibility_(dsMapIndex, "success", 0.0);
        }
        else
        {
            DsMapAddDouble_comaptibility_(dsMapIndex, "success", 1.0);

        }
        
        CreateAsyncEventWithDSMap_comaptibility_(dsMapIndex);
    }];
    
    return no_error;
}

- (double) iapPromotionVisibilityFetch:(NSString *)identifier
{
    if ((self.m_validIaps).count == 0)
    {
        return (int)error_no_skus;
    }
    
    SKProduct* foundProduct = nil;
    for (int i = 0; i < ((self.m_validIaps).count); ++i)
    {
        SKProduct* product = self.m_validIaps[i];
        if ([product.productIdentifier isEqualToString:identifier])
        {
            foundProduct = product;
            break;
        }
    }
    
    if (@available(iOS 11.0, tvOS 11.0, macOS 11.0, macCatalyst 14.0, *))
    if (foundProduct != nil)
    {
        [[SKProductStorePromotionController defaultController] fetchStorePromotionVisibilityForProduct:foundProduct completionHandler:^(SKProductStorePromotionVisibility storePromotionVisibility, NSError * _Nullable error) 
         {
            int dsMapIndex = CreateDsMap_comaptibility_();
            DsMapAddDouble_comaptibility_(dsMapIndex, "id", promotion_visibility_fetch);
            DsMapAddString_comaptibility_(dsMapIndex, "product", [identifier UTF8String]);

            if(error)
            {
                DsMapAddDouble_comaptibility_(dsMapIndex, "success", 0.0);
            }
            else
            {
                DsMapAddDouble_comaptibility_(dsMapIndex, "success", 1.0);
                DsMapAddDouble_comaptibility_(dsMapIndex, "visibility", (double) storePromotionVisibility);
            }
            
            CreateAsyncEventWithDSMap_comaptibility_(dsMapIndex);
        }];
    }
    
    return (int)no_error;
}

- (double) iapPromotionVisibilityUpdate:(NSString *)identifier visibility:(double) visibility
{
    if ((self.m_validIaps).count == 0)
    {
        return (int)error_no_skus;
    }
    
    SKProduct* foundProduct = nil;
    for (int i = 0; i < ((self.m_validIaps).count); ++i)
    {
        SKProduct* product = self.m_validIaps[i];
        if ([product.productIdentifier isEqualToString:identifier])
        {
            foundProduct = product;
            break;
        }
    }
    
    if (foundProduct != nil)
    {
        [[SKProductStorePromotionController defaultController] updateStorePromotionVisibility:(SKProductStorePromotionVisibility) visibility forProduct:foundProduct completionHandler:^(NSError * _Nullable error) {
            
            int dsMapIndex = CreateDsMap_comaptibility_();
            DsMapAddDouble_comaptibility_(dsMapIndex, "id", promotion_visibility_update);
            
            if(error)
            {
                DsMapAddDouble_comaptibility_(dsMapIndex, "success", 0.0);
            }
            else
            {
                DsMapAddDouble_comaptibility_(dsMapIndex, "success", 1.0);
            }
            
            CreateAsyncEventWithDSMap_comaptibility_(dsMapIndex);
            
        }];
    }
    
    return (int)no_error;
}
@end
