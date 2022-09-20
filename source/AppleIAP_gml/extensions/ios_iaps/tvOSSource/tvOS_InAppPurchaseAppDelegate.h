//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

${YYExtAppDelegateIncludes}
#import <Foundation/Foundation.h>

@interface tvOS_InAppPurchaseAppDelegate : ${YYExtAppDelegateBaseClass}
{
@private
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)applicationWillTerminate:(UIApplication *)application;

@end
