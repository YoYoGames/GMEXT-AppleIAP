//
//  Callbacks.h
//  maciapextension
//
//  Created by David Clarke on 31/07/2019.
//  Copyright © 2019 YoYoGames. All rights reserved.
//

#ifndef Callbacks_h
#define Callbacks_h

extern const int EVENT_OTHER_WEB_IAP;

extern void (*CreateAsynEventWithDSMap)(int,int);
extern int (*CreateDsMap)(int _num, ... );
extern bool (*DsMapAddDouble)(int _index,char *_pKey,double value);
extern bool (*DsMapAddString)(int _index, char *_pKey, char *pVal);

#endif /* Callbacks_h */
