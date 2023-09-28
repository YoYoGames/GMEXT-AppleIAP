//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import <Foundation/Foundation.h>

@interface tvOS_InAppPurchase : NSObject
{
@private
}

@property (nonatomic, retain) NSMutableArray* m_products;

- (double) ios_iap_Init;

- (double) ios_iap_IsAuthorisedForPayment;

- (double) ios_iap_AddProduct:(NSString*)_productName;

- (double) ios_iap_QueryProducts;

- (NSString*) ios_iap_QueryPurchases;

- (double) ios_iap_PurchaseProduct:(NSString*)_productName;

- (double) ios_iap_RestorePurchases;

- (double) ios_iap_FinishTransaction:(NSString*)_transactionId;

- (NSString*) ios_iap_GetReceipt;

- (double) ios_iap_RefreshReceipt;

- (double) ios_iap_ValidateReceipt;

@end
