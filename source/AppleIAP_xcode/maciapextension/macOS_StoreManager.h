//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import <StoreKit/StoreKit.h>

@interface macOS_StoreManager : NSObject
+ (macOS_StoreManager *)sharedInstance;

@property (nonatomic, retain) NSMutableArray* m_validIaps;
@property (nonatomic, retain) NSMutableArray* m_invalidIaps;

- (void) startProductRequestWithIdentifiers:(NSArray *)identifiers;

- (double) startPaymentRequestWithIdentifier:(NSString *)identifier;

- (void) restorePurchases;

- (void) refreshReceipt;

@end
