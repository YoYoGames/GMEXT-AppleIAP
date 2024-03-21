// Functions

/**
 * @function iap_Init
 * @desc This function initialises the Apple In-App Purchase API.
 * @function_end
 */

/**
 * @function iap_QueryProducts
 * @desc This function can be used to query the status of products from the Apple Store. The function will trigger an ${event.iap} with the data from the products query.
 * 
 * @event iap
 * @member {constant.iap_event_id} id This will be the constant `iap_product_update`.
 * @member {string} response_json This will be a JSON string object which will contain the product details.
 * The `"response_json"` string can be converted into a ${type.struct} using the ${function.json_parse} function. The struct will contain two variables: `valid` and `invalid`. These keys will in turn contain a ${type.array} which can then be parsed to get information about each of the individual products.
 * The `invalid` array will simply be a list of strings, where each string relates to an invalid product ID (note that a product can be invalid if it is not configured or configured incorrectly on the App Store Connect console, or even if there is a connection issue between the device and App Store Connect).
 * The `valid` array will contain a ${struct.ProductInfo} struct for each list entry, where each item corresponds to a single valid product.
 * @event_end
 * 
 * @example
 * This function would normally be called straight after adding the desired products to the internal product list, as shown in the example for the function ${function.iap_AddProduct}. Once called it will trigger an ${event.iap} which would be parsed with something like the following code:
 * 
 * ```gml
 * /// Async IAP Event
 * var _event_id = async_load[? "id"];
 * 
 * switch(_event_id)
 * {
 *     case iap_product_update:
 *         show_debug_message("[INFO] Query Products Callback");
 *         var _response_json = async_load[?"response_json"];
 *         if (_response_json == "") { exit; }
 *         
 *         var _response_data = json_parse(_response_json);
 *         
 *         show_debug_message("Invalid SKUs");
 *         show_debug_message("------------");
 *         array_foreach(_response_data.invalid, show_debug_message);
 *         
 *         var _valid = _response_data.valid;
 *         for(var i = 0; i < array_length(_valid);i++)
 *         {
 *             var _product = _valid[i];
 *             var _product_id = _product.productId;
 *             
 *             show_debug_message($"Valid Product: {_product_id}");
 *         }
 *         
 *         break;
 *     
 *     // Handle other cases here...
 * }
 * ```
 * The code example above checks the event type and executes a bit of code when it's of type `iap_product_update`.
 * It then gets the response JSON from the `"response_json"` member and parses it using ${function.json_parse}.
 * The invalid SKUs are listed in the output window. The valid SKUs' properties are looked up and output as well.
 * @function_end
 */

/**
 * @function iap_IsAuthorisedForPayment
 * @desc This function checks whether the user currently signed in on the device has authorised the payment process or not. The function will return `true` if payment can be completed, or `false` otherwise, in which case you should disable all purchase options in the game. Normally, you'd want to check this return value at Game Start.
 * 
 * @returns {bool}
 * 
 * @example
 * ```gml
 * /// Create Event - Controller object
 * #macro iap_consumable "yyg_iap_100gems"
 * #macro iap_nonconsumable "yyg_iap_noads"
 * #macro iap_renewablesub "yyg_iap_monthlysub"
 * #macro iap_nonrenewablesub "yyg_iap_yearpromosub"
 *  
 * iap_Init();
 * 
 * iap_enabled = false;
 * if (!iap_IsAuthorisedForPayment()) { exit; }
 * 
 * iap_enabled = true;
 * 
 * iap_AddProduct(iap_consumable);
 * iap_AddProduct(iap_nonconsumable);
 * iap_AddProduct(iap_renewablesub);
 * iap_AddProduct(iap_nonrenewablesub);
 * iap_QueryProducts();
 * ```
 * The example code above first defines a few macros that store the product IDs. It then initialises the extension with a call to ${function.iap_Init} and sets a variable `iap_enabled` to `false`. After that, it checks if the user is authorised for payments using ${function.iap_IsAuthorisedForPayment}.
 * If not, the event is exited. If the user is authorised to make payments, the variable `iap_enabled` is set to `true`, the products are added and queried.
 * 
 * @function_end
 */

/**
 * @function iap_AddProduct
 * @desc This function adds a product to the internal IAP product list, preparing it for purchase. The function takes a string, which is the product ID as defined in the App Store Connect console for your game. The function returns an ${constant.iap_error} constant to inform you of the success or failure of the addition, and you should call this at the start of your game *before* querying or permitting purchases.
 *
 * @param {string} product_id The product ID string of the product being added
 * 
 * @returns {constant.iap_error}
 * 
 * @example
 * ```gml
 * /// Create Event - Controller object
 * #macro iap_consumable "yyg_iap_100gems"
 * #macro iap_nonconsumable "yyg_iap_noads"
 * #macro iap_renewablesub "yyg_iap_monthlysub"
 * #macro iap_nonrenewablesub "yyg_iap_yearpromosub"
 * 
 * iap_Init();
 * 
 * iap_enabled = false;
 * if (!iap_IsAuthorisedForPayment()) { exit; }
 * 
 * iap_enabled = true;
 * 
 * iap_AddProduct(iap_consumable);
 * iap_AddProduct(iap_nonconsumable);
 * iap_AddProduct(iap_renewablesub);
 * iap_AddProduct(iap_nonrenewablesub);
 * iap_QueryProducts();
 * ```
 * The example code above first defines a few macros that store the product IDs. It then initialises the extension with a call to ${function.iap_Init} and sets a variable `iap_enabled` to `false`. After that, it checks if the user is authorised for payments using ${function.iap_IsAuthorisedForPayment}.
 * If not, the event is exited. If the user is authorised to make payments, the variable `iap_enabled` is set to `true`, the products are added and queried.
 *
 * @function_end
 */

/**
 * @function iap_PurchaseProduct
 * @desc This function is used to purchase a product within your game. You supply the product ID as a string (which should match the ID of the product on the App Store Connect console), and the function will immediately return one of the ${constant.iap_error} constants to inform you of the initial status of the purchase request, and if that is `iap_no_error` then it will also trigger an ${event.iap}. In this event the ${var.async_load} DS map will have an `"id"` key which will be `iap_payment_queue_update`.
 * 
 * The ${var.async_load} map will also have another key `"json_response"` which will contain a JSON object string with the details of the purchase. This string can be decoded into a ${type.struct} using the ${function.json_parse} function, and the resulting struct will have a single variable `purchases`. This in turn will be an ${type.array} in which each entry is a ${struct.PurchaseInfo} corresponding to a single purchase.
 * 
 * If the purchase state comes back as a success or a restored purchase, then you should go ahead and validate the purchase with either your own server (recommended) or with Apple, and then finalise the purchase. If the purchase has failed, then you should still finalise the purchase, but no other action needs to be taken. For more information on finalising purchases please see the function ${function.iap_FinishTransaction}.
 * 
 * @event iap
 * @member {constant.iap_event_id} id The value `iap_payment_queue_update`.
 * @member {string} response_json This will be a JSON string object which will contain the details of the purchase. This string can be parsed into a ${type.struct} using the ${function.json_parse} function, and the resulting struct will have a single variable `purchases`. This in turn will be an array in which each entry is a ${struct.PurchaseInfo}.
 * @event_end
 * 
 * @returns {constant.iap_error}
 * 
 * @example
 * The following code would be used to create a purchase request for the given product, and would be placed anywhere in the game (like a button object):
 * 
 * ```gml
 * /// Mouse Left Released Event
 * iap_PurchaseProduct(iap_consumable);
 * ```
 * 
 * [[Note: You should have some code in place here that checks if IAPs are enabled.]]
 *
 * The request above will trigger an ${event.iap} which can be dealt with something like this:
 * 
 * ```gml
 * /// Async IAP Event
 * var _event_id = async_load[? "id"];
 * switch (_event_id)
 * {
 *     case iap_payment_queue_update:
 *         
 *         show_debug_message("[INFO] Purchase Product Callback");
 *         
 *		   var _response_json = async_load[?"response_json"];
 *		   if (_response_json == "") { exit; }
 *	       
 *		   var _response_data = json_parse(_response_json);
 *		   
 *		   if(struct_exists(_response_data, "cancelled") && _response_data.cancelled)
 *		   {
 *			   // User closed the popup
 *			   show_debug_message($"Purchase Cancelled: {_response_data.product}");
 *			   return;
 *		   }
 *	       
 *		    // This will only validate the receipt signature
 *		    // If it is not valid we shouldn't event bother doing the server-side check.
 *		    if (iap_ValidateReceipt()) {
 *	            
 *			    var _receipt = iap_GetReceipt();
 *	            
 *			    // Proceed to check validation with the server
 *			    // This is not required but is recommended
 *			    // If you don't want to validate with a server you can set flag to 'false' instead
 *			    if (true) {
 *				    var _http_request = RequestServerValidation(_receipt);
 *				    validationRequests[$ _http_request] = _response_data.purchases;
 *			    }
 *			    else
 *			    {
 *                  // Handle the purchases using your own code
 *				    HandlePurchases(_response_data.purchases);
 *			    }
 *		    }
 *		    // Refresh the receipt for a later check
 *		    else {
 *			    waiting_refresh = true;
 *			    iap_RefreshReceipt();
 *		    }
 *		    break;
 *     // Handle other cases here
 * }
```
The code above shows the code in the ${event.iap} in the specific case of an `iap_payment_queue_update` event.
The `HandlePurchases` function is a custom function that handles the purchases once it's clear that they're valid. See the demo project for a example implementation.

 * @function_end
 */

/**
 * @function iap_RestorePurchases
 * @desc This function can be used to restore any previous purchases.
 * 
 * Apple requires you to have a button in your game that calls this function so that users that have changed or refreshed their device can still access previously made purchases.
 * 
 * Calling this function will immediately return a ${constant.iap_purchase_state} constant to inform you whether the restore request has been made or not, and then a successful request *may* trigger an ${event.iap} with the restored purchase details. We say "may", as under the following circumstances no Async Event will be triggered:
 *
 * * All transactions are unfinished.
 * * The user did not purchase anything that is restorable.
 * * You tried to restore items that are not restorable, such as a non-renewing subscription or a consumable product.
 * * Your app's build version does not meet the guidelines for the [CFBundleVersion key](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleversion).
 * 
 * @returns {constant.iap_purchase_state}
 * 
 * @event iap
 * @member {constant.iap_event_id} id The constant `iap_payment_queue_update`.
 * @member {string} json_response This is a JSON object string with the details of the purchase. It can be parsed into a struct using the ${function.json_parse} function, and the resulting struct will have a single key `"purchases"`. This key contains an ${type.array} of ${struct.PurchaseInfo} structs.
 * @event_end
 * 
 * @example
 * ```gml
 * /// Async IAP Event
 * var _event_id = async_load[? "id"];
 * switch(_event_id)
 * {
 *     case ios_payment_queue_update:
 *         // Decode the returned JSON
 *         var _json = async_load[? "response_json"];
 *         if (_json == "") { exit; }
 *         
 *         var _purchase_data = json_parse(_json);
 *         var _purchases = _purchase_data.purchases;
 *         
 *         // Loop through purchases
 *         for(var i = 0;i < array_length(_purchases);i++)
 *         {
 *             var _purchase = _purchases[i];
 *             if (_purchase.responseCode == 3)
 *             {
 *                 // This is a restored purchased, handle it here
 *                 show_debug_message($"Purchase Restored for Product: {_purchase.productId}");
 *             }
 *         }
 *         break;
 * }
 * ```
 * @function_end
 */

/**
 * @function iap_FinishTransaction
 * @desc Once a purchase request, restore request or purchase query has been sent, any products returned in the ${event.iap} for these calls should be validated and then finalised before awarding any products to the player. Finalising a product means that you are telling Apple that the transaction has been completed and the product awarded, and this function should be called on **all** transactions, even those that have failed (for example, cancelled by the user). Any transaction that has not been finalised will appear in the above-mentioned purchase/restore/query data and should be finalised before any further purchases of the same product are processed.
 * 
 * When calling this function, you need to supply the product token string (as returned in the ${event.iap} for the associated function call), and the function will return an ${constant.iap_error} constant that can be `iap_no_error` or `iap_error_unknown`.
 * 
 * @param {string} purchase_token The purchase token returned by the purchase request.
 * 
 * @example
 * For examples of using this function, please see: 
 * 
 * * ${function.iap_QueryPurchases}
 * * ${function.iap_PurchaseProduct}
 * * ${function.iap_RestorePurchases}
 * 
 * @function_end
 */

/**
 * @function iap_QueryPurchases
 * @desc This function queries the status of all unfinalised purchases.
 * 
 * It can be called anytime and in any place in your game code, as the purchase status details are retrieved when the API is initialised and after any change has been made (i.e., something has been purchased). However, we recommend that you initially call it after adding product IDs to the internal product list and generally it’s better to call it after having queried product details too.
 * 
 * Generally, you would want to call this function once at the start of the game, and then again after any purchase receipt validation so that you know which items have been purchased and need to be finalised and awarded to the user.
 * 
 * [[Important: This function will only return items that have not been finalised. So, any products that are returned by this function will need to be finalised using the function ${function.iap_FinishTransaction}.]]
 * 
 * The function returns the purchases as a JSON-encoded string that you can parse using ${function.json_parse}. The struct can be accessed as a ${struct.PurchaseInfo} struct.
 * 
 * @returns {string}
 * 
 * @example
 * ```gml
 * /// Create Event
 * var _purchases_json = iap_QueryPurchases();
 * if (_purchases_json != "") {
 *     var _purchases_data = json_parse(_purchases_json);
 *     var _purchases = _purchases_data.purchases;
 *     
 *     HandlePurchases(_purchases, true);
 * }
 * ```
 * The code above queries the purchases with a call to ${function.iap_QueryPurchases}. The result is checked immediately on the next line of code: the JSON string is parsed into a struct using ${function.json_parse}, its `purchases` variable looked up and the purchases handled using a custom `HandlePurchases` function.
 * 
 * @function_end
 */

/**
 * @function iap_GetReceipt
 * @desc This function can be used to retrieve the receipt string for all purchases currently in progress. This string can then be sent as part of the payload to your server (or to Apple) to verify the purchases in the receipt.
 * 
 * [[Important: The receipt string can contain **multiple transaction receipts at once** as Apple sends back all pending receipts in one string. For more information, including how to check the information provided in the receipt, please see the [Apple Developer Documentation](https://developer.apple.com/documentation/storekit/in-app_purchase/original_api_for_in-app_purchase/choosing_a_receipt_validation_technique).]]
 * 
 * @returns {string}
 * 
 * @example
 * The following code is a very simple example of how to use the function and send a verification request off to a server you have set up. Note, however, that the actual usage will very much depend on how you've set up the server and this is not a one-size-fits-all example to be copied and used directly:
 * 
 * ```gml
 * var _receipt = iap_GetReceipt();
 * if (_receipt != "")
 * {
 *     var _map = ds_map_create();
 *     _map[? "apple_receipt"] = _receipt;
 *     var _body = json_encode(_map);
 *     ds_map_clear(_map);
 *     _map[? "Host"] = "10.36.11.105:9999";
 *     _map[? "Content-Type"] = "application/json";
 *     _map[? "Content-Length"] = string_length(_body);
 *     var _url = "http://" + _map[? "Host"] + "/apple-receipt-verify";
 *     http_request(_url, "POST", _map, _body);
 *     ds_map_destroy(_map);
 * }
 * ```
 * @function_end
 */

/**
 * @function iap_RefreshReceipt
 * @desc With this function you can request a new receipt for all purchases pertaining to a user and app. This function should only be called if a previous receipt could not be validated correctly. The function will return one of the ${constant.iap_receipt_refresh_result} constants immediately to inform you whether the refresh request has been successful, and if it is successful then an ${event.iap} will be triggered. In this event the ${var.async_load} DS map will have an `"id"` key, which will be the constant `iap_receipt_refresh`, and an additional key `"status"`. The status will be a member of the ${constant.iap_receipt_refresh_result} constants. If the refresh is successful, you can then retrieve the new receipt using the function ${function.iap_GetReceipt}, but if it fails then you may want to try again at least once before deciding that something is wrong.
 *
 * [[Note: Failing validation is a rare occurrence and is very indicative that there is something funny going on with the request. As such, you may want to consider locking down and preventing any further purchases – or at least not granting the products that were being validated – should validation fail 2 or more times. Any outstanding purchases should still be finalised at this time.]]
 * 
 * @returns {constant.iap_error}
 * 
 * @example
 * The following example assumes you have received a failed validation attempt from your server or from local validation and have called this function to request a refresh of the IAP receipt. This would then be dealt with in the ${event.iap} in the following way:
 * 
 * ```gml
 * /// Async IAP Event
 * var _event_id = async_load[? "id"];
 * var _status = async_load[? "status"];
 * switch(_event_id)
 * {
 *     case iap_receipt_refresh:
 *         if (_status == iap_receipt_refresh_success)
 *         {
 *             var _receipt = iap_GetReceipt();
 *             if (_receipt != "")
 *             {
 *                 // Send off another validation request to your server (or locally) and try again
 *                 _receipt = iap_GetReceipt();
 *                 if (iap_ValidateReceipt())
 *                 {
 *                     switch(_product_id)
 *                     {
 *                         case iap_consumable:
 *                             global.gold += 100;
 *                             break;
 *                         case iap_nonconsumable:
 *                             global.no_ads = true;
 *                             break;
 *                         case iap_renewablesub:
 *                             global.subs = true;
 *                             break;
 *                     }
 *                     iap_FinishTransaction();
 *                 }
 *                 else
 *                 {
 *                     //  Validation failed, so deal with it here
 *                 }
 *             }
 *         }
 *         else if (_status == iap_receipt_refresh_failure)
 *         {
 *             iap_enabled = false;
 *             // Finalise the purchase here
 *         }
 *         break;
 *     
 *     // Handle other cases here...
 * }
 * ```
 * 
 * @function_end
 */

/**
 * @function iap_ValidateReceipt
 * @desc This function can be used for local receipt validation with Apple. In general, you'd want to use a private server for validation of all purchases (especially subscriptions), but if that is not possible then you can use this function, after calling the ${function.iap_GetReceipt} function to validate purchases. The function will return `true` if validation has been successful, or `false` otherwise, in which case you should attempt to refresh and revalidate the receipt using ${function.iap_RefreshReceipt}.
 * @returns {boolean}
 * 
 * @example
 * See ${function.iap_PurchaseProduct} for an example on how to use this function.
 * @function_end
 */

// Constants

/**
 * @const iap_error
 * @desc This group of constants represent the possible errors.
 * @member iap_error_unknown An unknown error occurred.
 * @member iap_no_error No error occurred.
 * @member iap_error_extension_not_initialised The extension has not been initialised.
 * @member iap_error_no_skus No SKUs were found.
 * @member iap_error_duplicate_product A duplicate product was encountered.
 * @const_end
 */

/**
 * @const iap_event_id
 * @desc This group of constants represents the possible event IDs (or types) in the ${event.iap}.
 * @member iap_payment_queue_update A response to a product purchase.
 * @member iap_product_update A response to a product query.
 * @member iap_receipt_refresh A response to a refresh of a receipt.
 * @const_end
 */

/**
 * @const iap_product_period_unit
 * @desc 
 * @member iap_product_period_unit_day Each unit represents a day.
 * @member iap_product_period_unit_week Each unit represents a week.
 * @member iap_product_period_unit_month Each unit represents a month.
 * @member iap_product_period_unit_year Each unit represents a year.
 * @const_end
 */

/**
 * @const iap_receipt_refresh_result
 * @desc This constant holds the possible outcomes of the refresh of a receipt.
 * @member iap_receipt_refresh_success The refresh of the receipt was successful.
 * @member iap_receipt_refresh_failure The refresh of the receipt wasn't successful.
 * @const_end
 */

/**
 * @const iap_purchase_state
 * @desc This group of constants represent the state of a purchase.
 * @member iap_purchase_success This value indicates that the product has been successfully purchased.
 * @member iap_purchase_failed This value indicates that the product purchase has failed in some way, for example, it was cancelled by the user.
 * @member iap_purchase_restored This indicates that the purchase has been restored.
 * @const_end
 */

// Structs

/**
 * @struct ProductSubscriptionPeriod
 * @desc This struct stores a subscription period and the unit in which it is expressed.
 * @member {real} numberOfUnits The number of "units" that the subscription is for.
 * @member {constant.iap_product_period_unit} units The unit used to calculate the duration of the subscription.
 * @struct_end
 */

/**
 * @struct ProductInfo
 * @desc This struct stores info about a product.
 * @member {string} productId The unique ID for the product as a string, for example `"mac_consumable"`.
 * @member {string} price The localised price of the product as a string, for example `"£0.99"`.
 * @member {string} localizedDescription This holds the description of the product as a string, and localised.
 * @member {string} localizedTitle  This holds the title of the product as a string, and localised.
 * @member {string} locale A string representing the user's region settings (see [Language and Locale IDs](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html) for more information).
 * @member {boolean} isDownloadable This will be a boolean `true` or `false`, depending on whether the App Store has downloadable content for this product.
 * @member {array} discounts This will hold an array where each list entry corresponds to a discount value.
 * @member {string} ISOCountryCode This is the [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) country code, as a string (for example: `"USA"`, `"EUR"`, `"JPY"`)
 * @member {string} ISOLanguageCode This is the [ISO 639-2](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) language code, as a string (for example: `"en"`, `"es"`, `"zh"`)
 * @member {string} ISOCurrencyCode This is the [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) currency code as a string (for example: `"$"`, `"€"`, `"¥"`)
 * @member {struct.ProductSubscriptionPeriod} subscriptionPeriod This is a struct with information on the subscription period.
 * @struct_end
 */

/**
 * @struct PurchaseInfo
 * @desc This struct stores info about a purchase.
 * @member {string} productId The ID string of the purchased product.
 * @member {real} responseCode This is the Apple response code, an integer value, where:
 * * purchasing = 0
 * * purchased = 1
 * * failed = 2
 * * restored = 3
 * * deferred = 4
 * @member {string} purchaseToken The purchase token string.
 * @member {constant.iap_purchase_state} purchaseState The state of the purchase.
 * @member {string} receipt The receipt string. This is deprecated and should not be used for anything. It is only included in this documentation as it is still part of the return payload from Apple. To get the correct receipt string, please use the function ${function.iap_GetReceipt}.
 * @struct_end
 */

/**
 * @module home
 * @title Home
 * 
 * @section Introduction
 * @desc This is the wiki for the Apple In-App Purchase extension.
 * 
 * This extension is supported on the macOS, iOS and tvOS platforms.
 * 
 * This wiki contains both the function and constant reference of the extension and the guides to get started and set up a proper workflow.
 * 
 * We recommend that before you do anything with this extension, you take a moment to look over the official Apple In-App Purchase API documentation, as it will familiarise you with many of the terms and concepts required to use the extension correctly, as many of the functions in the extension are practically 1:1 mappings of the methods described there:
 * 
 * [Apple Developer: In-App Purchase](https://developer.apple.com/documentation/storekit/in-app_purchase?language=objc)
 * 
 * @section_end
 * 
 * @section Guides
 * @desc The following guides are available for the Apple IAP extension:
 * @ref page.setup
 * @ref page.workflow
 * @section_end
 * 
 * @section Modules
 * @desc These are the modules of the Apple IAP extension: 
 * @ref module.general
 * @ref module.promotions
 * @section_end
 * 
 * @module_end
 */

/**
 * @module general
 * @title General
 * @desc This is the reference guide to the general functions used by the Apple IAP Extension, along with any constants that they may use or return and examples of code that use them.
 * 
 * Some of the examples are extended examples that also show code from callbacks in the ${event.iap}.
 *
 * It is worth noting that in some cases the function description will mention the use of a private server to verify purchases. This is not strictly required, as the extension supplies a verification method that verifies purchases locally with Apple, and purchases can be made and finalised even without server verification. However, YoYo Games and Apple both highly recommend private server verification for all IAPs. Setting up the server to deal with purchase verification is outside of the scope of this documentation and, instead, we refer you to the Apple docs here:
 * 
 * [Apple Developer Docs: Validating receipts on the device](https://developer.apple.com/documentation/appstorereceipts/validating_receipts_on_the_device#//apple_ref/doc/uid/TP40010573-CH1-SW2)
 * [Apple Developer Docs: Validating receipts with the App Store](https://developer.apple.com/documentation/storekit/in-app_purchase/original_api_for_in-app_purchase/validating_receipts_with_the_app_store#//apple_ref/doc/uid/TP40010573-CH104-SW1)
 * 
 * [[IMPORTANT: In order for the function ${function.iap_ValidateReceipt} to return a `true` response, users must download the Apple Inc. Root Certificate and include it with their project in the [Included Files](https://manual.gamemaker.io/monthly/en/Settings/Included_Files.htm) (using included files covers iOS/tvOS and macOS). See:
 * 
 * * https://www.apple.com/certificateauthority/
 * * https://www.apple.com/appleca/AppleIncRootCertificate.cer
 * 
 * Please see [Validation](workflow#validation) for more information.]]
 * 
 * @section_func Functions
 * @desc These are the general functions of the extension.
 * 
 * @ref iap_Init
 * @ref iap_QueryProducts
 * @ref iap_IsAuthorisedForPayment
 * @ref iap_AddProduct
 * @ref iap_PurchaseProduct
 * @ref iap_RestorePurchases
 * @ref iap_FinishTransaction
 * @ref iap_QueryPurchases
 * @ref iap_GetReceipt
 * @ref iap_RefreshReceipt
 * @ref iap_ValidateReceipt
 * @section_end
 * 
 * @section_const Constants
 * @desc This section lists the constants of this extension.
 * @ref iap_error
 * @ref iap_event_id
 * @ref iap_product_period_unit
 * @ref iap_receipt_refresh_result
 * @ref iap_purchase_state
 * @section_end
 * 
 * @section_struct
 * @desc This section lists the structs of this extension.
 * @ref ProductInfo
 * @ref PurchaseInfo
 * @ref ProductSubscriptionPeriod
 * @section_end
 * 
 * @module_end
 */
