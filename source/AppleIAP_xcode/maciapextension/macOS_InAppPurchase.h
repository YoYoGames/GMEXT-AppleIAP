//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import <Foundation/Foundation.h>

@interface macOS_InAppPurchase : NSObject
{
@private
}

@property (nonatomic, retain) NSMutableArray* m_products;

- (double) AppleIAPs_Init;

- (double) AppleIAPs_IsAuthorisedForPayment;

- (double) AppleIAPs_AddProduct:(NSString*)_productName;

- (double) AppleIAPs_QueryProducts;

- (NSString*) AppleIAPs_QueryPurchases;

- (double) AppleIAPs_PurchaseProduct:(NSString*)_productName;

- (double) AppleIAPs_RestorePurchases;

- (double) AppleIAPs_FinishTransaction:(NSString*)_transactionId;

- (NSString*) AppleIAPs_GetReceipt;

- (double) AppleIAPs_RefreshReceipt;

- (double) AppleIAPs_ValidateReceipt;

@end
