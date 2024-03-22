@title Workflow

# Workflow

This page describes the workflow when using the Apple In-App Purchases extension.

The workflow consists of the following main parts: 

* [Initialising In-App Purchases](#initialising-in-app-purchases)
* [Purchasing Products](#purchasing-products)

### The Asynchronous IAP Event

When using the Apple IAP extension in your projects, you will be calling different functions that will trigger "callbacks" from the Apple API. What this means is that certain functions will be run but won't return a result until sometime in the future - which could be the next step, or it could be a few seconds later. This result, when it comes, is called the "callback" and is Apple's IAP API responding to something you've done. This callback is dealt with in the ${event.iap}. This event will always have a DS map in the GML variable ${var.async_load}, and this map can be parsed to get the required information. Each function will generate different callbacks, but they will all have the `"id"` key in common:

> The `"id"` key holds an ${constant.iap_event_id} constant with the ID of the event that has been triggered. For example, if it's an event for a product query, then the constant will be `iap_product_update`.

The rest of the key/value pairs in the map depends on the function that triggered the Async Event and the ID of the event, and you should check the individual functions listed in the rest of this manual for exact details.

## Initialising In-App Purchases

1. At the start of the game, initialise the extension with a call to ${function.iap_Init}.
2. Next, check if the user is authorised to buy in-app products using ${function.iap_IsAuthorisedForPayment}.
3. If they are not, disable the possibility for purchases in your game's UI and code.
4. If purchases *are* permitted, add the different products to the internal products list using ${function.iap_AddProduct} and - if required - query product details using ${function.iap_QueryProducts}. See [Product Queries](#product-queries).
5. After adding the products but before accepting purchases, query existing purchases using ${function.iap_QueryPurchases}. If there are any unfinished transactions then deal with them, and enable any features based on durable or subscription transactions. For an example on how to do this, see the `HandleProducts` function in the demo project.
6. Permit the game to run as normal and let the user purchase/consume products as required, verifying each purchase, then querying them, and then finalising them. See [Purchasing Products](#purchasing-products).
7. Store non-consumable and subscription purchases on your server so they can be checked when the game starts (or store them securely locally, but a server is recommended).
8. Ensure that the game has a "Restore Purchases" button, in case of a change of device or anything of that nature.

[[Important: With the Apple Purchase API there is no function or method for consuming a consumable IAP, therefore all consumables must be given to the user the moment the purchase receipt is validated.]]

[[Note: Apple wants ALL purchase requests to be "finalised", regardless of whether the purchase was actually a success or not (see the function ${function.iap_FinishTransaction} for more details).]]

## Purchasing Products

1. Call ${function.iap_PurchaseProduct} to purchase a product.
2. In the ${event.iap}, check for the event type `iap_payment_queue_update`.
3. Validate the receipt using ${function.iap_ValidateReceipt}.
  * If the receipt isn't valid, refresh the receipt using ${function.iap_RefreshReceipt}.
    * Listen to the ${event.iap} of type `iap_receipt_refresh`.
    * If the status is `iap_receipt_refresh_success`, validate the receipt using ${function.iap_ValidateReceipt}.
      * If the receipt isn't valid then finish the transaction with ${function.iap_FinishTransaction}.
    * Handle the purchases with a function such as `HandlePurchases`.
4. Do the server validation (as shown for example in the script asset `RequestServerValidation`).
  * If the status value is different from 0, the purchase is invalid.
  * Is the status is okay, handle the products similar to the function `HandleProducts`.

## Initialising Your IAPs

When dealing with IAPs we recommend that you have a dedicated, persistent, controller instance that deals with all the initialisation as well as the callback ${event.iap} that the different functions generate. This keeps it all in one place and you only need to add purchase functions to buttons and things for the player to interact with. This article builds on this premise, however you don't have to do it this way if that's not appropriate to your project.

[[Note: This article will **not** detail all the different returns or async callbacks in detail, but will instead concentrate on the approximate workflow and general code required to set up IAPs on macOS, iOS and tvOS. For more complete information about what each function does, please see the function reference.]]

To start with, you'll need to initialise the IAPs that you want to be available in your game, and this should be done right at the start of the game in the **Create Event** of the controller object. You want to accompany this with a check to see if the device is enabled to permit purchases too, as it is possible that the device has had this disabled (for children or whatever):

```gml
/// Create Event - Controller object
#macro iap_consumable "yyg_iap_100gems"
#macro iap_nonconsumable "yyg_iap_noads"
#macro iap_renewablesub "yyg_iap_monthlysub"
#macro iap_nonrenewablesub "yyg_iap_yearpromosub"
 
iap_Init();

iap_enabled = false;
if (!iap_IsAuthorisedForPayment()) { exit; }

iap_enabled = true;

iap_AddProduct(iap_consumable);
iap_AddProduct(iap_nonconsumable);
iap_AddProduct(iap_renewablesub);
iap_AddProduct(iap_nonrenewablesub);
iap_QueryProducts();
```

You'll notice that we first add macros for the product IDs, then initialise the extension using ${function.iap_Init} and, after that, check for the availability of purchasing using ${function.iap_IsAuthorisedForPayment}. If that returns `true`, we go ahead and add our products to the internal list and then fire off a product query. If it returns `false`, then you can disable IAPs in the game, as the user won't be able to purchase anything (and, indeed, Apple insists that you do this).

[[Note: We have used [macros](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Variables/Constants.htm#macros) here to store product IDs. This is not required and you can store your product IDs as you wish, using [Global Variables](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Variables/Global_Variables.htm) or [Arrays](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Arrays.htm) for example.]]

## Product Queries

Querying your products is not essential, however doing so means that you can then display up-to-date and localised information about them in your game, rather than hard-coding them. When you send off a product query request it will trigger an ${event.iap} where the DS map ${var.async_load} will have an `"id"` key with the constant `iap_product_update` as the value. This would be dealt with in the Async Event something like this:

```gml
/// Async IAP Event
switch(async_load[?"id"])
{
    case ios_product_update:
    
        show_debug_message("[INFO] Query Products Callback");

        var _response_json = async_load[?"response_json"];
        if (_response_json == "") { exit; }
		
		var _response_data = json_parse(_response_json);
		HandleProducts(_response_data);
		break;
}

function HandleProducts(_products) {
	
	var _invalidArray = _products.invalid;
	for (var _i = 0; _i < array_length(_invalidArray); ++_i)
	{
		var _sku = _invalidArray[_i];
		show_debug_message("[WARNING] Invalid SKU: " + string(_sku));
	}

	// Variable used as a lookup for storing product data
	var _dataLookup = {};

	var _validArray = _products.valid;
	for (var _i = 0; _i < array_length(_validArray); ++_i)
	{
		var _product = _validArray[_i];
		var _productId = _product.productId;
	
		show_debug_message("valid prouduct: " + string(_product.productId));
	
		_dataLookup[$ _productId] = {
	
			price: _product.price,
			localizedTitle: _product.localizedTitle,
			localizedDescription: _product.localizedDescription,
			currencyCode: variable_struct_exists(_product, "currencyCode") ? _product.currencyCode : "",
			currencySymbol: variable_struct_exists(_product, "currencySymbol") ? _product.currencySymbol : ""
		}
	}

    // Apply the stored data to instances here
    // ...
}
```

## Purchase Queries

It may be that the game was closed before a purchase could be completed, or something went wrong or even that the user has changed devices while a purchase was in progress. To deal with those - and other - potential issues, you must query ongoing purchases at the start of your game too. This is done with the function ${function.iap_QueryPurchases}, and should be done after initialising the IAPs in the ${event.create}, or after querying product details in the ${event.iap}.

The purchase query function will *not* generate an async event callback, but will instead immediately return the outstanding purchase requests which can be dealt with something like this:

```gml
var _purchases_json = iap_QueryPurchases();
if (_purchases_json != "")
{
	var _purchases_data = json_parse(_purchases_json);
	var _purchases = _purchases_data.purchases;
	
	HandlePurchases(_purchases, true);
}
```

[[Note: Before awarding anything to the user we attempt to **validate** the purchases. This can be done through a server (recommended) or through local validation. If validation fails, you should NOT continue to check further purchases and instead break the loop and re-check the validation by refreshing the receipt. This is discussed in more detail further on.]]

[[Note: ALL purchase queries must be finalised, whether they are awarded or not, or whether the purchase succeeded or not (but NOT when the validation has failed). Again, we discuss finalising purchases in more detail further on.]]

## Restoring Purchases

Apple's rules state that you must have a button in your game to restore purchases, and to do this you would call the function ${function.iap_RestorePurchases}. This will trigger an ${event.iap} where the ${var.async_load} map has the `"id"` constant `iap_payment_queue_update`. See the code example of ${function.iap_RestorePurchases} for an example on how to check this in the ${event.iap}.

## Making a Purchase

To make a purchase of a product, you must call the function ${function.iap_PurchaseProduct}, e.g.:

```gml
iap_PurchaseProduct(product_id);
```

This function will generate an ${event.iap} of ID (or type) `iap_payment_queue_update`. This can then be processed in the exact same way as outlined above in the section on [Restoring Purchases](#restoring-purchases), as the async callback is identical.

## Validating

Before awarding and finalising any purchases, they must first be **validated**. Apple recommends that you do this with a private server but there is also a function to validate locally, but this is slightly less secure and requires you to include a **Root Certificate** with your game (see the section on [Setting Up Your Game](#setting-up-your-game) for more details). The general workflow for validating using the two methods would be:

* **Server**: When a purchase or restore event is triggered, you would get the purchase receipt (using the function ${function.iap_GetReceipt}) and then send that off to your server using one of the [http_*() functions](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asynchronous_Functions/HTTP/HTTP.htm). This would then validate the purchase with Apple and send a response back. This response would then be dealt with in the ${event.http}, where you would then award the user the product they've bought or enable any features it unlocked. You would also store these details on your server so the game can check on restart any purchases or subscriptions. For more information, please see the [Apple Documentation](https://developer.apple.com/documentation/appstorereceipts).
* **Local**: To validate locally, you must first call the function ${function.iap_GetReceipt} to retrieve the receipt file, and then call the function ${function.iap_ValidateReceipt}. If that returns `true` then you can award products and unlock features as required. This would then be securely stored to a file so that on game restart it can be checked and all features or items be unlocked correctly.

If validation fails you can re-check again by requesting a new receipt with the function ${function.iap_RefreshReceipt}. This will trigger an ${event.iap}, and in this event the ${var.async_load} DS map `"id"` key will be the constant `iap_receipt_refresh`. It will also have an additional key `"status"`, which will be one of two constants: `iap_receipt_refresh_success` or `iap_receipt_refresh_failure`. If the refresh is successful, you can then retrieve the new receipt using the ${function.iap_GetReceipt} function and go ahead and validate as before, but if it fails then you may want to try again at least once before deciding that something is wrong.

[[Note: Failing validation is a rare occurrence and is very indicative that there is something unauthorised going on with the request. As such, you may want to consider locking down and preventing any further purchases – or at least not granting the products that were being validated – should validation fail 2 or more times. Any outstanding purchases should still be finalised at this time.]]

### Local Validation

This extension includes a method of validating in-app purchases that does not require the setting up or use of external servers. However, the extension code also includes a warning about the potential for hacking intrinsic to this method of validation. This warning is in place as a means of highlighting the sensitive nature of the Receipt Validation code which is based on an open-source repository (and is credited as such).

The intention of the inclusion of local receipt validation was to give you (the user) a means of allowing your project to get IAP code running quickly and be easily testable.

It should be understood, however, that **there is risk involved with running it in production**. Since the source code is open source and is widely available and readable, using this code will make your receipt validation more vulnerable to potential attackers, and Apple themselves state that "it's important that you employ a solution that is unique to your application":

> https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Introduction.html

In this case, your available options are as follows:

* Leave this code in place and use local validation, having assessed and understood the risks.
* Alter the code in question (`VerifyStoreReceipt.h`/`VerifyStoreReceipt.mm`) to create your own custom solution for validating receipts, in which case you should study the following documentation: [Validating receipts on the device](https://developer.apple.com/documentation/appstorereceipts/validating_receipts_on_the_device#//apple_ref/doc/uid/TP40010573-CH1-SW2). In doing so, you should create your own solution for parsing and validating the iOS IAP receipt.
* Validate the receipt with the Apple App Store using the apple endpoints (not recommended) as described in the documentation: [Validating receipts with the App Store](https://developer.apple.com/documentation/storekit/in-app_purchase/original_api_for_in-app_purchase/validating_receipts_with_the_app_store?language=objc). If you decide to do so please refer to the function `RequestServerValidation` on the demo project, for an implementation example.
* Run a server that validates IAP receipts. This is Apple's preferred and suggested method, as it removes the ability for tampered-with iOS devices to spoof your validation code (since it is not executed on said compromised device).

## Finalising Purchase Requests

After making any purchase, it must be validated and finalised using the function ${function.iap_FinishTransaction}. Finalising a purchase removes it from the purchase queue and tells Apple that the transaction has been completed in one way or another, and this must be done **regardless of whether the purchase was a success or a failure**. When we talk about success or failure, we are referring to the *purchase status* as returned as part of the response data from a purchase query, a restore request, or a purchase request, and not to validation failure or anything else.

[[Note: If you do not finalise a purchase then the user will not be able to buy that product again.]]

## Cancelled Purchases

If at any time during the product/subscription purchase you cancel and give up on buying the product, this will result in an ${event.iap} of type `iap_payment_queue_update`.

More information is provided in the `"response_json"` key. You can get this information from parsing the string using ${function.json_parse}, which returns a ${type.struct}:

* "response_data" – This is just a container DS map/struct, decoded or parsed from the JSON string in `"response_json"`, with the following entries:
  * "cancelled" – This will be represented by a ${type.boolean} and will always contain a `true` value (1, one) stored within.
  * "product" – To help identify which purchase was cancelled the product ID is also returned and presented inside this field.

In your code you should check if the "cancelled" key is present. If it is, you can add code to handle this situation: 

```gml
switch(async_load[?"id"])
{
    case iap_payment_queue_update:

		show_debug_message("[INFO] Purchase Product Callback");

		var _response_json = async_load[?"response_json"];
		if (_response_json == "") { exit; }
	
		var _response_data = json_parse(_response_json);
		
		if(variable_struct_exists(_responseData,"cancelled") && _responseData.cancelled)
		{
      // This event was triggered for a cancelled purchase
      //The user closed the popup
			show_debug_message($"Buy Cancelled: {_responseData.product}");
			return;
		}

    // This event wasn't triggered for a cancelled purchase => continue processing it
}
```
