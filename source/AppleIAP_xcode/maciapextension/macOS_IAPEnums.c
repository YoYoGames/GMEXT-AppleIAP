//
//  macOS_IAPEnums.c
//  MacIapExtension
//
//  Created by David Clarke on 14/08/2019.
//  Copyright © 2019 YoYoGames. All rights reserved.
//

#include "macOS_IAPEnums.h"

const int error_unknown                     = -1;
const int no_error                          = 0;
const int error_extension_not_initialised   = 1;
const int error_no_skus                     = 2;
const int error_duplicate_product           = 3;

const int payment_queue_update              = 33100;
const int purchase_success                  = 33101;
const int purchase_failed                   = 33102;
const int purchase_restored                 = 33103;
const int product_update                    = 33104;
const int receipt_refresh                   = 33105;

const int receipt_refresh_success           = 32502;
const int receipt_refresh_failure           = 32503;

const int product_period_unit_day           = 32105;
const int product_period_unit_week          = 32106;
const int product_period_unit_month         = 32107;
const int product_period_unit_year          = 32108;
