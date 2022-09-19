//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import "iOS_StoreManager.h"
#include "iOS_InAppPurchase.h"
#include "iOS_IAPEnums.h"

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
const int EVENT_OTHER_WEB_IAP = 66;

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
    
    NSNumberFormatter* number = [[NSNumberFormatter alloc] init];
    [number setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    for (SKProduct* product in self.m_validIaps)
    {
        NSMutableDictionary* productMap = [[NSMutableDictionary alloc] init];
        
        [number setLocale:[product priceLocale]];
        NSString* price = [number stringFromNumber:[product price]];
        productMap[@"price"] = price;
        productMap[@"locale"] = [[product priceLocale] languageCode];
        productMap[@"locale_localeIdentifier"] = [[product priceLocale] localeIdentifier];
        productMap[@"locale_languageCode"] = [[product priceLocale] languageCode];
        productMap[@"locale_countryCode"] = [[product priceLocale] countryCode];
        productMap[@"localizedTitle"] = [product localizedTitle];
        productMap[@"localizedDescription"] = [product localizedDescription];
        productMap[@"productId"] = [product productIdentifier];
		
		productMap[@"currencyCode"] = [[product priceLocale] currencyCode];
		productMap[@"currencySymbol"] = [[product priceLocale] currencySymbol];
        
        if (@available(iOS 13.0, tvOS 13.0, *))
        {
            //productMap[@"contentVersion"] = [product contentVersion];
        }
        
        if (@available(iOS 11.2, tvOS 11.2, *))
        {
            if ([product introductoryPrice] != nil)
            {
                NSMutableDictionary* introPriceMap = [[NSMutableDictionary alloc] init];
                NSString* introPrice = [number stringFromNumber:[[product introductoryPrice] price]];
                introPriceMap[@"price"] = introPrice;
                introPriceMap[@"priceLocale"] = [[[product introductoryPrice] priceLocale] languageCode];
                
                productMap[@"introductoryPrice"] = introPriceMap;
            }
        }
        
        if (@available(iOS 12.2, tvOS 12.2, *))
        {
            NSMutableArray* discounts = [[NSMutableArray alloc] init];
            for (SKProductDiscount* discountProd in [product discounts])
            {
                NSMutableDictionary* discountProdMap = [[NSMutableDictionary alloc] init];
                NSString* introPrice = [number stringFromNumber:[discountProd price]];
                discountProdMap[@"price"] = introPrice;
                discountProdMap[@"priceLocale"] = [[discountProd priceLocale] languageCode];
                [discounts addObject:discountProdMap];
            }
            productMap[@"discounts"] = discounts;
        }
        
        // Subscriptions
        {
            if (@available(iOS 11.2, tvOS 11.2, *))
            {
                if ([product subscriptionPeriod] != nil)
                {
                    NSMutableDictionary* subPeriodMap = [[NSMutableDictionary alloc] init];
                    NSUInteger numUnits = [[product subscriptionPeriod] numberOfUnits];
                    subPeriodMap[@"numberOfUnits"] = [NSNumber numberWithUnsignedInteger:numUnits];

                    SKProductPeriodUnit unitType = [[product subscriptionPeriod] unit];
                    int yyUnitEnum = 0;
                    switch (unitType)
                    {
                        case SKProductPeriodUnitDay:
                            yyUnitEnum = product_period_unit_day;
                            break;
                        case SKProductPeriodUnitWeek:
                            yyUnitEnum = product_period_unit_week;
                            break;
                        case SKProductPeriodUnitMonth:
                            yyUnitEnum = product_period_unit_month;
                            break;
                        case SKProductPeriodUnitYear:
                            yyUnitEnum = product_period_unit_year;
                            break;
                    }
                    subPeriodMap[@"unit"] = [NSNumber numberWithInteger:yyUnitEnum];
                    productMap[@"subscriptionPeriod"] = subPeriodMap;
                }
            }
            
            if (@available(iOS 12.0, tvOS 12.0, *))
            {
                if ([product subscriptionGroupIdentifier] != nil)
                {
                    productMap[@"subscriptionGroupIdentifier"] = [product subscriptionGroupIdentifier];
                }
            }
            
            productMap[@"downloadContentVersion"] = [product downloadContentVersion];
            productMap[@"downloadContentLengths"] = [product downloadContentLengths];
            productMap[@"isDownloadable"] = [NSNumber numberWithBool:[product isDownloadable]];
        }
        
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
    
    int dsMapIndex = dsMapCreate();
    dsMapAddInt(dsMapIndex, jId, product_update);
    dsMapAddString(dsMapIndex, jResponse, const_cast<char*>([jsonStr UTF8String]));
    CreateAsyncEventOfTypeWithDSMap(dsMapIndex, EVENT_OTHER_WEB_IAP);
    
    [number release];
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
        int dsMapIndex = dsMapCreate();
        char jId[3];
        sprintf(jId, "id");
        char jResponse[20];
        sprintf(jResponse, "status");
        dsMapAddInt(dsMapIndex, jId, receipt_refresh);
        
        dsMapAddInt(dsMapIndex, jResponse, receipt_refresh_success);
        
        CreateAsyncEventOfTypeWithDSMap(dsMapIndex, EVENT_OTHER_WEB_IAP);
    }
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]])
    {
        int dsMapIndex = dsMapCreate();
        char jId[3];
        sprintf(jId, "id");
        char jResponse[20];
        sprintf(jResponse, "status");
        dsMapAddInt(dsMapIndex, jId, receipt_refresh);
        
        dsMapAddInt(dsMapIndex, jResponse, receipt_refresh_failure);
        
        CreateAsyncEventOfTypeWithDSMap(dsMapIndex, EVENT_OTHER_WEB_IAP);
    }
}

@end
