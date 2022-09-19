//
//  macOS_IAPEnums.h
//  MacIapExtension
//
//  Created by David Clarke on 14/08/2019.
//  Copyright © 2019 YoYoGames. All rights reserved.
//

#ifndef macOS_IAPEnums_h
#define macOS_IAPEnums_h

#include <stdio.h>

extern const int error_unknown;
extern const int no_error;
extern const int error_extension_not_initialised;
extern const int error_no_skus;
extern const int error_duplicate_product;

extern const int payment_queue_update;
extern const int purchase_success;
extern const int purchase_failed;
extern const int purchase_restored;
extern const int product_update;
extern const int receipt_refresh;
extern const int receipt_refresh_success;
extern const int receipt_refresh_failure;

extern const int product_period_unit_day;
extern const int product_period_unit_week;
extern const int product_period_unit_month;
extern const int product_period_unit_year;

#endif /* macOS_IAPEnums_h */
