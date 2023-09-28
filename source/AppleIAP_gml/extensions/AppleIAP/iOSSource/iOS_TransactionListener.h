//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import <StoreKit/StoreKit.h>

@interface iOS_TransactionListener : NSObject<SKPaymentTransactionObserver>
+ (iOS_TransactionListener *)sharedInstance;

@property (atomic, retain) NSMutableDictionary* m_activeTransactions;

- (NSString*)queryPurchases;

- (double)finishTransaction:(NSString*)purchaseToken;

- (NSString*)getReceiptData:(SKPaymentTransaction *)transaction;

@end
