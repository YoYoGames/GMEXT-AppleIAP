//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import "macOS_InAppPurchaseAppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "macOS_TransactionListener.h"

void attachListener()
{
    NSLog(@"%s", __FUNCTION__);
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[macOS_TransactionListener sharedInstance]];
}

void detachListener()
{
    NSLog(@"%s", __FUNCTION__);
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:[macOS_TransactionListener sharedInstance]];
}
