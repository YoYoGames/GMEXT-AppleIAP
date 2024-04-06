//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import "iOS_InAppPurchase.h"
#import "iOS_TransactionListener.h"
#import "iOS_StoreManager.h"
#include "iOS_IAPEnums.h"

#include "VerifyStoreReceipt.h"

NSString * global_bundleVersion = nil;
NSString * global_bundleIdentifier = nil;

#if TARGET_OS_OSX
YYRunnerInterface gs_runnerInterface;
YYRunnerInterface* g_pYYRunnerInterface;
#else
extern "C" void dsMapClear(int _dsMap );
extern "C" int dsMapCreate();
extern "C" void dsMapAddInt(int _dsMap, char* _key, int _value);
//extern "C" void dsMapAddDouble(int _dsMap, char* _key, double _value);
//extern "C" void DsMapAddString(int _dsMap, char* _key, char* _value);

extern "C" int dsListCreate();
extern "C" void dsListAddInt(int _dsList, int _value);
extern "C" void dsListAddString(int _dsList, char* _value);
extern "C" const char* dsListGetValueString(int _dsList, int _listIdx);
extern "C" double dsListGetValueDouble(int _dsList, int _listIdx);
extern "C" int dsListGetSize(int _dsList);

extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);
extern "C" void dsMapAddDouble(int _dsMap, const char* _key, double _value);
extern "C" void dsMapAddString(int _dsMap, const char* _key, const char* _value);
#endif

const int EVENT_OTHER_WEB_IAP = 66;

#if TARGET_OS_OSX
extern "C" void PreGraphicsInitialisation(char* arg1)//Mac
{

}

YYEXPORT void YYExtensionInitialise(const struct YYRunnerInterface* _pFunctions, size_t _functions_size)
{
    //copy out all the functions
    memcpy(&gs_runnerInterface, _pFunctions, sizeof(YYRunnerInterface));
    g_pYYRunnerInterface = &gs_runnerInterface;

    if (_functions_size < sizeof(YYRunnerInterface)) {
        DebugConsoleOutput("ERROR : runner interface mismatch in extension DLL\n ");
    } // end if

    DebugConsoleOutput("YYExtensionInitialise CONFIGURED \n ");
}
#endif

@implementation iOS_InAppPurchase

@synthesize m_products;


int CreateDsMap_comaptibility_()
{
    #if TARGET_OS_OSX
    return CreateDsMap(0,0);
    #else
    return CreateDsMap(0,0);
    #endif
}

void DsMapAddString_comaptibility_(int dsMapIndex, const char* _key, const char* _value)
{
    #if TARGET_OS_OSX
    DsMapAddString(dsMapIndex, _key, _value);
    #else
    dsMapAddString(dsMapIndex, _key, _value);
    #endif
}

void DsMapAddDouble_comaptibility_(int dsMapIndex, const char* _key, double _value)
{
    #if TARGET_OS_OSX
    DsMapAddDouble(dsMapIndex, _key, _value);
    #else
    dsMapAddDouble(dsMapIndex, _key, _value);
    #endif
}

void CreateAsyncEventWithDSMap_comaptibility_(int dsMapIndex)
{
    #if TARGET_OS_OSX
    CreateAsyncEventWithDSMap(dsMapIndex,EVENT_OTHER_WEB_IAP);
    #else
    CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_WEB_IAP);
    #endif
}

- (void) dealloc
{
    [self.m_products release];
    [super dealloc];
}

- (double) iap_Init
{
    // it turns out, it's a bad idea, to use these two NSBundle methods in your app:
	//
	// bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	// bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	//
	// http://www.craftymind.com/2011/01/06/mac-app-store-hacked-how-developers-can-better-protect-themselves/
	//
	// so use hard coded values instead (probably even somehow obfuscated)
    
    [self Init];//initializate delegate
    
    global_bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    global_bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    self.m_products = [[NSMutableArray alloc] initWithCapacity:0];
    [self.m_products retain];
    return no_error;
}

- (double) iap_IsAuthorisedForPayment
{
    // Boolean return;
    BOOL authorised = [SKPaymentQueue canMakePayments];
    return authorised ? 1.0 : 0.0;
}

- (double) iap_AddProduct:(NSString*)_productName
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

- (double) iap_QueryProducts
{
    [[iOS_StoreManager sharedInstance] startProductRequestWithIdentifiers:self.m_products];
    return no_error;
}

- (NSString*) iap_QueryPurchases
{
    return [[iOS_TransactionListener sharedInstance] queryPurchases];
}

- (double) iap_PurchaseProduct:(NSString*)_productName
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

- (double) iap_RestorePurchases
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

- (double) iap_FinishTransaction:(NSString*)_transactionId
{
    return [[iOS_TransactionListener sharedInstance] finishTransaction:_transactionId];
}

- (NSString*) iap_GetReceipt
{
    NSURL* url = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData* receiptData = [NSData dataWithContentsOfURL:url];
    NSString *receiptStr = [receiptData base64EncodedStringWithOptions:0];
    
    // TODO: Some basic validation here. https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateLocally.html#//apple_ref/doc/uid/TP40010573-CH1-SW2
    
    //temp
    
    
    return receiptStr;
}

- (double) iap_RefreshReceipt
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

- (double) iap_ValidateReceipt
{
#if !TARGET_OS_OSX
    BOOL valid = verifyReceiptUsingURL( [[NSBundle mainBundle] appStoreReceiptURL] );
#else
    BOOL valid = verifyReceiptWithURL( [[NSBundle mainBundle] appStoreReceiptURL] );
#endif
    // Boolean return.
    return valid == YES ? 1.0 : 0.0;
}



+ (NSMutableDictionary*) product2map:(SKProduct*) product
{
    NSNumberFormatter* number = [[NSNumberFormatter alloc] init];
    [number setNumberStyle:NSNumberFormatterCurrencyStyle];
    
#if TARGET_OS_OSX
    NSMutableDictionary* productMap = [[NSMutableDictionary alloc] init];
    
    [number setLocale:[product priceLocale]];
    NSString* price = [number stringFromNumber:[product price]];
    productMap[@"price"] = price;
    productMap[@"locale_localeIdentifier"] = [[product priceLocale] localeIdentifier];
    productMap[@"localizedTitle"] = [product localizedTitle];
    productMap[@"localizedDescription"] = [product localizedDescription];
    productMap[@"productId"] = [product productIdentifier];
    productMap[@"currencyCode"] = [[product priceLocale] currencyCode];
    productMap[@"currencySymbol"] = [[product priceLocale] currencySymbol];
    
    if (@available(macOS 10.12, *)) {
        productMap[@"locale"] = [[product priceLocale] languageCode];
        productMap[@"locale_languageCode"] = [[product priceLocale] languageCode];
        productMap[@"locale_countryCode"] = [[product priceLocale] countryCode];
    }
    
    if (@available(macOS 10.13.2, *))
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
    
    if (@available(macOS 10.14.4, *))
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
        if (@available(macOS 10.13.2, *))
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
        
        if (@available(macOS 10.14.0, *))
        {
            if ([product subscriptionGroupIdentifier] != nil)
            {
                productMap[@"subscriptionGroupIdentifier"] = [product subscriptionGroupIdentifier];
                productMap[@"downloadContentVersion"] = [product downloadContentVersion];
                productMap[@"downloadContentLengths"] = [product downloadContentLengths];
            }
        }
        
        if (@available(macOS 10.15.0, *))
        {
//                productMap[@"isDownloadable"] = [NSNumber numberWithBool:[product isDownloadable]];
        }
    }
#else
    
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
#endif
    [number release];
    
    return productMap;
}

//https://developer.apple.com/documentation/storekit/skproductstorepromotioncontroller?language=objc

- (void) iap_Promotion_Order_Fetch
{
	// - (void)fetchStorePromotionOrderWithCompletionHandler:(void (^)(NSArray<SKProduct *> *promotionOrder, NSError *error))completionHandler;
    if (@available(iOS 11.0, tvOS 11.0, macOS 11.0, macCatalyst 14.0, *))
    [[SKProductStorePromotionController defaultController] fetchStorePromotionOrderWithCompletionHandler:^(NSArray<SKProduct *> * _Nonnull promotionOrder, NSError * _Nullable error)
     {
        
        int dsMapIndex = CreateDsMap_comaptibility_();
        DsMapAddDouble_comaptibility_(dsMapIndex, "id", promotion_order_fetch);
        
        
        
        if(error)
        {
            DsMapAddDouble_comaptibility_(dsMapIndex, "success", 0.0);
        }
        else
        {
            DsMapAddDouble_comaptibility_(dsMapIndex, "success", 1.0);
            
            NSMutableArray *mutarray = [NSMutableArray new];
            for(SKProduct *pro in promotionOrder)
            {
                [mutarray addObject:[iOS_InAppPurchase product2map:pro]];
            }
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutarray options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            DsMapAddString_comaptibility_(dsMapIndex, "products", [jsonString UTF8String]);
        }
        
        CreateAsyncEventWithDSMap_comaptibility_(dsMapIndex);
        }
    ];

}

- (double) iap_Promotion_Order_Update: products
{
	return [[iOS_StoreManager sharedInstance] iapPromotionOrderUpdate:products];
}

- (double) iap_Promotion_Visibility_Fetch:(NSString*) product
{
	return [[iOS_StoreManager sharedInstance] iapPromotionVisibilityFetch:product];
}

- (double) iap_Promotion_Visibility_Update:(NSString*) product visibility:(double) visibility
{
	return [[iOS_StoreManager sharedInstance] iapPromotionVisibilityUpdate:product visibility: visibility];
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

#if TARGET_OS_OSX

iOS_InAppPurchase *mac;

YYEXPORT void /*(double)*/ iap_Init(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)
{
    mac = [iOS_InAppPurchase new];
    
    Result.kind = VALUE_REAL;
    Result.val = [mac iap_Init];
}

YYEXPORT void /*- (double)*/ iap_IsAuthorisedForPayment(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//
{
    Result.kind = VALUE_REAL;
    Result.val = [mac iap_IsAuthorisedForPayment];
}

YYEXPORT void /*- (double)*/ iap_AddProduct(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//:(NSString*)_productName
{
    const char* _productName = YYGetString(arg, 0);
    
    Result.kind = VALUE_REAL;
    Result.val = [mac iap_AddProduct:@(_productName)];
}

YYEXPORT void /*- (double)*/ iap_QueryProducts(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//
{
    Result.kind = VALUE_REAL;
    Result.val = [mac iap_QueryProducts];
}

YYEXPORT void /*- (NSString*)*/ iap_QueryPurchases(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//
{
    YYCreateString(&Result, (const char*)[[mac iap_QueryPurchases] UTF8String]);
}

YYEXPORT void /*- (double)*/ iap_PurchaseProduct(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//(NSString*)_productName;
{
    const char* _productName = YYGetString(arg, 0);

    Result.kind = VALUE_REAL;
    Result.val = [mac iap_PurchaseProduct:@(_productName)];
}

YYEXPORT void /*- (double)*/ iap_RestorePurchases(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//
{
    Result.kind = VALUE_REAL;
    Result.val = [mac iap_RestorePurchases];
}

YYEXPORT void /*- (double)*/ iap_FinishTransaction(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//(NSString*)_transactionId
{
    const char* _transactionId = YYGetString(arg, 0);

    
    Result.kind = VALUE_REAL;
    Result.val = [mac iap_FinishTransaction:@(_transactionId)];
}

YYEXPORT void /*- (NSString*)*/ iap_GetReceipt(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//
{
    YYCreateString(&Result, (const char*)[[mac iap_GetReceipt] UTF8String]);
}

YYEXPORT void /*- (double)*/ iap_RefreshReceipt(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//
{
    Result.kind = VALUE_REAL;
    Result.val = [mac iap_RefreshReceipt];
}

YYEXPORT void /*- (double)*/ iap_ValidateReceipt(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//
{
    Result.kind = VALUE_REAL;
    Result.val = [mac iap_ValidateReceipt];
}

YYEXPORT void /*- (void)*/ iap_Promotion_Order_Fetch(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//
{
    // Result.kind = VALUE_REAL;
    // Result.val = 
	[mac iap_Promotion_Order_Fetch];
}

YYEXPORT void /*- (double)*/ iap_Promotion_Order_Update(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//: products
{
	const char* products = YYGetString(arg, 0);

    Result.kind = VALUE_REAL;
    Result.val = [mac iapPromotionOrderUpdate:[products UTF]];
}

YYEXPORT void /*- (double)*/ iap_Promotion_Visibility_Fetch(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//:(NSString*) product
{
	const char* product = YYGetString(arg, 0);

    Result.kind = VALUE_REAL;
    Result.val = [mac iapPromotionVisibilityFetch:@(product)];
}

YYEXPORT void /*- (double)*/ iap_Promotion_Visibility_Update(RValue& Result, CInstance* selfinst, CInstance* otherinst, int argc, RValue* arg)//:(NSString*) product visibility:(double) visibility
{
	const char* product = YYGetString(arg, 0);
	double visibility = YYGetReal(arg, 1);

    Result.kind = VALUE_REAL;
    Result.val = [mac iapPromotionVisibilityUpdate:@(product) visibility: visibility];
}

#endif

@end
