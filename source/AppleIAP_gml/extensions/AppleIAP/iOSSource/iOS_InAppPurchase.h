//
//
//  Copyright YoYo Games Ltd.
//  For support please submit a ticket at help.yoyogames.com
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#if TARGET_OS_OSX
#import "Extension_Interface.h"
#include "YYRValue.h"
#include <sstream>
#endif

@interface iOS_InAppPurchase : NSObject
{

}

@property (nonatomic, retain) NSMutableArray* m_products;

+ (NSMutableDictionary*) product2map:(SKProduct*) product;

@end

extern int CreateDsMap_comaptibility_();
extern void DsMapAddString_comaptibility_(int dsMapIndex, const char* _key, const char* _value);
extern void DsMapAddDouble_comaptibility_(int dsMapIndex, const char* _key, double _value);
extern void CreateAsyncEventWithDSMap_comaptibility_(int dsMapIndex);

