//
//  Callbacks.m
//  maciapextension
//
//  Created by David Clarke on 31/07/2019.
//  Copyright © 2019 YoYoGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Callbacks.h"

const int EVENT_OTHER_WEB_IAP = 66;

void (*CreateAsynEventWithDSMap)(int,int) = NULL;
int (*CreateDsMap)(int _num, ... ) = NULL;
bool (*DsMapAddDouble)(int _index,char *_pKey,double value)=NULL;
bool (*DsMapAddString)(int _index, char *_pKey, char *pVal)=NULL;

extern "C" void RegisterCallbacks(char *arg1, char *arg2, char *arg3,  char *arg4 );

void RegisterCallbacks(char *arg1, char *arg2, char *arg3,  char *arg4 )
{
    void (*CreateAsynEventWithDSMapPtr)(int,int) = (void (*)(int,int))(arg1);
    int(*CreateDsMapPtr)(int _num,...) = (int(*)(int _num,...)) (arg2);
    CreateAsynEventWithDSMap = CreateAsynEventWithDSMapPtr;
    CreateDsMap = CreateDsMapPtr;
    
    bool (*DsMapAddDoublePtr)(int _index,char *_pKey,double value)= (bool(*)(int,char*,double))(arg3);
    bool (*DsMapAddStringPtr)(int _index, char *_pKey, char *pVal)= (bool(*)(int,char*,char*))(arg4);
    
    DsMapAddDouble = DsMapAddDoublePtr;
    DsMapAddString = DsMapAddStringPtr;
}
