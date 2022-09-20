
/// @param {array} purchases
/// @param {bool} shouldValidate
function HandlePurchases(_purchases, _shouldValidate = false) {

	if (_shouldValidate) {
		
		var _receipt = iap_GetReceipt();
		var _httpRequest = RequestServerValidation(_receipt);
		
		Obj_AppleIAPs.validationRequests[$ _httpRequest] = _purchases;
		
		exit;
	}
	
	// Lookup struct to check if a button should lock
	var _shouldLock = {};
	
	for(var _n = 0; _n < array_length(_purchases); _n++) {
	
		var _purchase = _purchases[_n];
		
		var _productId = _purchase.productId;
		var _purchaseState = _purchase.purchaseState; // Check the manual for state codes
		var _purchaseToken = _purchase.purchaseToken;
		
		var _responseCode = _purchase.responseCode; // Check the manual for response codes
			
		if (!iap_PurchaseFailed(_purchaseState)) {
		
			switch (_productId) {
					
				case iap_consumable:
					// 
					// Add reward to player here
					//
					_shouldLock[$ _productId] = false; // Keep button unlocked (it's a consumable)
					break;
				case iap_nonconsumable:
					// 
					// Add reward to player here
					// 
					_shouldLock[$ _productId] = true; // Lock button
					break;
					
					// .... ADD MORE ...
					
				default:
					_shouldLock[$ _productId] = true;
					break;
					
			}			
		}
	
		// IMPORTANT: Always finish the transaction!
		iap_FinishTransaction(_purchaseToken);	
	}

	// Go through all the purchase buttons
	with (Obj_AppleIAPs_Purchase) {
	
		// If ths productId for this purchase item is in the lookup, lock the button.
		if (variable_struct_exists(_shouldLock, productId))
			locked = _shouldLock[$ productId];
	}

}

