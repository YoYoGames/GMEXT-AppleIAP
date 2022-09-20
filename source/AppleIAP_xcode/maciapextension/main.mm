//
//  main.c
//  maciapextension
//
//  Created by David Clarke on 30/07/2019.
//  Copyright © 2019 YoYoGames. All rights reserved.
//

#include "main.h"

#import <Foundation/Foundation.h>

#include "macOS_InAppPurchaseAppDelegate.h"
#include "macOS_InAppPurchase.h"
#include "macOS_IAPEnums.h"

extern "C" double mac_iap_Init();
extern "C" double mac_iap_Final();
extern "C" double mac_iap_IsAuthorisedForPayment();
extern "C" double mac_iap_AddProduct(char* _productId);
extern "C" double mac_iap_QueryProducts();
extern "C" const char* mac_iap_QueryPurchases();
extern "C" double mac_iap_PurchaseProduct(char* _productId);
extern "C" double mac_iap_RestorePurchases();
extern "C" double mac_iap_FinishTransaction(char* _transactionId);
extern "C" const char* mac_iap_GetReceipt();
extern "C" double mac_iap_exit(double _exitCode);
extern "C" double mac_iap_RefreshReceipt();
extern "C" double mac_iap_ValidateReceipt();

static bool isInitialised = false;

static const double mac_no_error = 0.0;

static macOS_InAppPurchase* s_iap = nil;

double mac_iap_Init()
{
    attachListener();
    
    if (s_iap == nil)
    {
        s_iap = [[macOS_InAppPurchase alloc] init];
    }

    [s_iap AppleIAPs_Init];
    
    isInitialised = true;
    return mac_no_error;
}

double mac_iap_Final()
{
    detachListener();
    
    if (s_iap != nil)
    {
        [s_iap release];
    }
    
    isInitialised = false;
    return mac_no_error;
}

double mac_iap_IsAuthorisedForPayment()
{
    if (!isInitialised)
    {
        return 0; // false
    }
    
    return [s_iap AppleIAPs_IsAuthorisedForPayment];
}

double mac_iap_AddProduct(char* _productId)
{
    if (!isInitialised)
    {
        return error_extension_not_initialised;
    }
    
    NSString* str = [[NSString alloc] initWithUTF8String:_productId];
    double res = [s_iap AppleIAPs_AddProduct:str];
    [str release];
    return res;
}

double mac_iap_QueryProducts()
{
    if (!isInitialised)
    {
        return error_extension_not_initialised;
    }
    
    double res = [s_iap AppleIAPs_QueryProducts];
    return res;
}

const char* mac_iap_QueryPurchases()
{
    if (!isInitialised)
    {
        return 0;
    }
    
    NSString* res = [s_iap AppleIAPs_QueryPurchases];
    return const_cast<char*>([res UTF8String]);
}

double mac_iap_PurchaseProduct(char* _productId)
{
    if (!isInitialised)
    {
        return error_extension_not_initialised;
    }
    
    NSString* str = [[NSString alloc] initWithUTF8String:_productId];
    double res = [s_iap AppleIAPs_PurchaseProduct:str];
    [str release];
    return res;
}

double mac_iap_RestorePurchases()
{
    if (!isInitialised)
    {
        return error_extension_not_initialised;
    }
    
    double res = [s_iap AppleIAPs_RestorePurchases];
    return res;
}

double mac_iap_FinishTransaction(char* _transactionId)
{
    if (!isInitialised)
    {
        return error_extension_not_initialised;
    }
    
    NSString* str = [[NSString alloc] initWithUTF8String:_transactionId];
    double res = [s_iap AppleIAPs_FinishTransaction:str];
    [str release];
    return res;
}

const char* mac_iap_GetReceipt()
{
    if (!isInitialised)
    {
        return 0;
    }
    
    NSString* res = [s_iap AppleIAPs_GetReceipt];
    return const_cast<char*>([res UTF8String]);
}

double mac_iap_exit(double _exitCode)
{
    exit(_exitCode);
}

double mac_iap_RefreshReceipt()
{
    if (!isInitialised)
    {
        return error_extension_not_initialised;
    }
    
    double res = [s_iap AppleIAPs_RefreshReceipt];
    return res;
}

double mac_iap_ValidateReceipt()
{
    if (!isInitialised)
    {
        return error_extension_not_initialised;
    }
    
    double res = [s_iap AppleIAPs_ValidateReceipt];
    return res;
}
