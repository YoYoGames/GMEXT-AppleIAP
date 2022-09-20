//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import "macOS_InAppPurchase.h"
#import <StoreKit/StoreKit.h>
#import "macOS_TransactionListener.h"
#import "macOS_StoreManager.h"
#include "macOS_IAPEnums.h"
#include "VerifyStoreReceipt.h"

@implementation macOS_InAppPurchase

@synthesize m_products;

- (void) dealloc
{
    [self.m_products release];
    [super dealloc];
}

- (double) AppleIAPs_Init
{
    self.m_products = [[NSMutableArray alloc] initWithCapacity:0];
    [self.m_products retain];
    return no_error;
}

- (double) AppleIAPs_IsAuthorisedForPayment
{
    // Boolean return;
    BOOL authorised = [SKPaymentQueue canMakePayments];
    return authorised ? 1.0 : 0.0;
}

- (double) AppleIAPs_AddProduct:(NSString*)_productName
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

- (double) AppleIAPs_QueryProducts
{
    [[macOS_StoreManager sharedInstance] startProductRequestWithIdentifiers:self.m_products];
    return no_error;
}

- (NSString*) AppleIAPs_QueryPurchases
{
    return [[macOS_TransactionListener sharedInstance] queryPurchases];
}

- (double) AppleIAPs_PurchaseProduct:(NSString*)_productName
{
    if (self.m_products == nil)
    {
        return error_extension_not_initialised;
    }

    if ((self.m_products).count == 0)
    {
        return error_no_skus;
    }

    return [[macOS_StoreManager sharedInstance] startPaymentRequestWithIdentifier:_productName];
}

- (double) AppleIAPs_RestorePurchases
{
    if (self.m_products == nil)
    {
        return error_extension_not_initialised;
    }

    if ((self.m_products).count == 0)
    {
        return error_no_skus;
    }

    [[macOS_StoreManager sharedInstance] restorePurchases];

    return no_error;
}

- (double) AppleIAPs_FinishTransaction:(NSString*)_transactionId
{
    return [[macOS_TransactionListener sharedInstance] finishTransaction:_transactionId];
}

- (NSString*) AppleIAPs_GetReceipt
{
    NSURL* url = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData* receiptData = [NSData dataWithContentsOfURL:url];
    NSString *receiptStr = [receiptData base64EncodedStringWithOptions:0];
    
    // TODO: Some basic validation here. https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateLocally.html#//apple_ref/doc/uid/TP40010573-CH1-SW2
    
    return receiptStr;
}

- (double) AppleIAPs_RefreshReceipt
{
    if (self.m_products == nil)
    {
        return error_extension_not_initialised;
    }

    if ((self.m_products).count == 0)
    {
        return error_no_skus;
    }

    [[macOS_StoreManager sharedInstance] refreshReceipt];

    return no_error;
}

- (double) AppleIAPs_ValidateReceipt
{
    BOOL valid = verifyReceiptWithURL( [[NSBundle mainBundle] appStoreReceiptURL] );
    
    return valid == YES ? 1.0 : 0.0;
}

@end
