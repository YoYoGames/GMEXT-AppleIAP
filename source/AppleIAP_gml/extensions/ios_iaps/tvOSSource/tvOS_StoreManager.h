//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import <StoreKit/StoreKit.h>

@interface tvOS_StoreManager : NSObject
+ (tvOS_StoreManager *)sharedInstance;

@property (nonatomic, retain) NSMutableArray* m_validIaps;
@property (nonatomic, retain) NSMutableArray* m_invalidIaps;

- (void) startProductRequestWithIdentifiers:(NSArray *)identifiers;

- (double) startPaymentRequestWithIdentifier:(NSString *)identifier;

- (void) restorePurchases;

- (void) refreshReceipt;
@end
