/// @description Async IAP responses

show_debug_message("Async Apple IAPs: " + json_encode(async_load));

switch(async_load[?"id"])
{
	/// ############### QUERY PRODUCTS ###############
	case ios_product_update:
	case mac_product_update:

		show_debug_message("[INFO] Query Products Callback");

		var _responseJson = async_load[?"response_json"];
		if (_responseJson == "") exit;
		
		var _responseData = json_parse(_responseJson);
		HandleProducts(_responseData);
		break;
	
	/// ############### PURCHASE PRODUCT ###############
	case ios_payment_queue_update:
	case mac_payment_queue_update:

		show_debug_message("[INFO] Purchase Product Callback");

		var _responseJson = async_load[?"response_json"];
		if (_responseJson == "") exit;
	
		var _responseData = json_parse(_responseJson);
		
		if(variable_struct_exists(_responseData,"cancelled"))
		if(_responseData.cancelled)
		{
			//User closed the popup
			show_debug_message("Buy Cancelled: " + _responseData.product)
			return
		}
	
		// This will only validate the receipt signature
		// If it is not valid we shouldn't event bother doing the server side check.
		if (iap_ValidateReceipt() == true) {
	
			var receipt = iap_GetReceipt();
	
			// Proceed to check validation with the server
			// This is not required but is recommended
			// If you don't want to validate with a server you can set flag to 'false' instead
			if (true) {
				var httpRequest = RequestServerValidation(receipt);
				validationRequests[$ httpRequest] = _responseData.purchases;
			}
			else 
			// Feather ignore GM2047 once
			{
				HandlePurchases(_responseData.purchases);
			}
		}
		// Resfresh the receipt for a later check
		else {
			waitingRefreh = true;
			iap_RefreshReceipt();
		}
		break;
		
	case ios_receipt_refresh:
	case mac_receipt_refresh:

		if (!waitingRefreh) exit;

		show_debug_message("[INFO] Receipt Refresh Callback (from purchase)");

		waitingRefreh = false;

		var _status = async_load[? "status"];
		var _purchasesJson = iap_QueryPurchases();
		if (_purchasesJson != "") exit;
		
		var _purchasesData = json_parse(_purchasesJson);
		var _purchases = _purchasesData.purchases;
		
		// We succeeded to refresh the receipt (and it is valid)
		if (_status == ios_receipt_refresh_success && iap_ValidateReceipt()) {
			
			// We can handle how purchases
			HandlePurchases(_purchases, true);
		}
		// We failed to refresh the receipt
		else if (_status == ios_receipt_refresh_failure) {
		
			// We force finish all the pending transactions
			for(var _n = 0; _n < array_length(_purchases); _n++) {
	
				var _purchase = _purchases[_n];
				var _purchaseToken = _purchase.purchaseToken;
				
				iap_FinishTransaction(_purchaseToken);
			}
		}
		break;
}













