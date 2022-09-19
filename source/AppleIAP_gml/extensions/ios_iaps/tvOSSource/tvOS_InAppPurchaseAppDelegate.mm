//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import "tvOS_InAppPurchaseAppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "tvOS_TransactionListener.h"

@implementation tvOS_InAppPurchaseAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Check if any superclasses implement this method and call it
    if([${YYExtAppDelegateBaseClass} instancesRespondToSelector:@selector(application:willFinishLaunchingWithOptions:)])
    {
        [super application:application willFinishLaunchingWithOptions:launchOptions];
    }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[tvOS_TransactionListener sharedInstance]];

    return TRUE;
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
    // Remove the observer.
    [[SKPaymentQueue defaultQueue] removeTransactionObserver: [tvOS_TransactionListener sharedInstance]];
}

@end
