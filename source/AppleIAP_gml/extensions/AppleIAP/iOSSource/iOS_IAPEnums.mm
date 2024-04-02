//
//  iOS_IAPEnums.c
//
//  Created by David Clarke on 14/08/2019.
//  Copyright © 2019 YoYoGames. All rights reserved.
//

#include "iOS_IAPEnums.h"

const int error_unknown                     = -1;
const int no_error                          = 0;
const int error_extension_not_initialised   = 1;
const int error_no_skus                     = 2;
const int error_duplicate_product           = 3;

const int payment_queue_update          = 23000;
const int purchase_success              = 23001;
const int purchase_failed               = 23002;
const int purchase_restored             = 23003;
const int product_update                = 23004;
const int receipt_refresh               = 23005;
const int restore_success               = 23006;
const int restore_failed                = 23007;

const int receipt_refresh_success       = 22500;
const int receipt_refresh_failure       = 22501;

const int product_period_unit_day       = 22101;
const int product_period_unit_week      = 22102;
const int product_period_unit_month     = 22103;
const int product_period_unit_year      = 22104;

const int promotion_purchase            = 22800;

const int promotion_order_fetch         = 22801;
const int promotion_order_update        = 22802;
const int promotion_visibility_fetch    = 22803;
const int promotion_visibility_update   = 22804;
