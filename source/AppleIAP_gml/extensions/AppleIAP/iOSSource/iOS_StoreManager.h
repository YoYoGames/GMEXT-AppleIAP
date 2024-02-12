//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import <StoreKit/StoreKit.h>

@interface iOS_StoreManager : NSObject
+ (iOS_StoreManager *)sharedInstance;

@property (nonatomic, retain) NSMutableArray* m_validIaps;
@property (nonatomic, retain) NSMutableArray* m_invalidIaps;

- (void) startProductRequestWithIdentifiers:(NSArray *)identifiers;

- (double) startPaymentRequestWithIdentifier:(NSString *)identifier;

- (void) restorePurchases;

- (void) refreshReceipt;

- (double) iapPromotionOrderUpdate:(NSString *)products;

- (double) iapPromotionVisibilityFetch:(NSString *)identifier;

- (double) iapPromotionVisibilityUpdate:(NSString *)identifier visibility:(double) visibility;

@end
