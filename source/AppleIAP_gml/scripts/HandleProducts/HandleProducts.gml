
/// @param {struct} products
function HandleProducts(_products) {
	
	var _invalidArray = _products.invalid;
	for (var _i = 0; _i < array_length(_invalidArray); ++_i)
	{
		var _sku = _invalidArray[_i];
		show_debug_message("[WARNING] Invalid sku: " + string(_sku));
	}

	// Variable used as a lookup for storing product data
	var _dataLookup = {};

	var _validArray = _products.valid;
	for (var _i = 0; _i < array_length(_validArray); ++_i)
	{
		var _product = _validArray[_i];
		var _productId = _product.productId;
	
		show_debug_message("valid prouduct: " + string(_product.productId))
	
		_dataLookup[$ _productId] = {
	
			price: _product.price,
			localizedTitle: _product.localizedTitle,
			localizedDescription: _product.localizedDescription,
			currencyCode: variable_struct_exists(_product, "currencyCode") ? _product.currencyCode : "", // Only available on iOS
			currencySymbol: variable_struct_exists(_product, "currencySymbol") ? _product.currencySymbol : "", // Only available on iOS
	
		}
	}

	// We now apply the stored data to our objects
	with(Obj_AppleIAPs_Purchase) {
		
		var _data = _dataLookup[$ productId];
	
		// If thre is no data skip element
		if (!is_struct(_data)) continue;
	
		price = _data.price;
		localizedTitle = _data.localizedTitle;
		localizedDesc = _data.localizedDescription;
		currencyCode = _data.currencyCode;
		currencySymbol = _data.currencySymbol;
	}

}


