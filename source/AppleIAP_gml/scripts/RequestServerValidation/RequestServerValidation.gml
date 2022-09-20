
// Reference link:
// https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateRemotely.html

/// @param {string} receipt
function RequestServerValidation(_receipt) {

	// ############################ IMPORTANT ############################
	// This Apple Server validation should NOT be preformed from the game
	// itself. we recommend that you have a server of your own as an intermediary
	// See sample at the end of this script:

	var _data = {}
	_data[$ "receipt-data"] = _receipt;
	
	// Password: My Apps -> Select My App -> In-App Purchases -> App-Specific Share Secret
	_data[$ "password"] = APP_SHARED_SECRET;
	
	// Optional: Use only for subscriptions
	_data[$ "exclude-old-transactions"] = true;

	var _jsonString = json_stringify(_data)

	var _requestId = http_post_string("https://sandbox.itunes.apple.com/verifyReceipt", _jsonString); // Use this for Sandbox
	// request_id = http_post_string("https://buy.itunes.apple.com/verifyReceipt", jsonString); // Use this for Production

	return _requestId;
}


// ################ CUSTOM SERVER VALIDATION SAMPLE ################

function CustomServerValidation(_receipt) {

	if (_receipt == "") return false;

	// Create a JSON string with your receipt data
	var _data = { apple_receipt: _receipt };
	var _json = json_stringify(_data);

	// Enter your server IP address and port
	var _host = "0.0.0.0:8080";

	// Set the header with the required information
	var _headers = ds_map_create();
	ds_map_add(_headers, "Host", _host)
	ds_map_add(_headers, "Content-Type", "application/json")
	ds_map_add(_headers, "Content-Length", string_length(_json));

	// The URL will be your server end-point
	var url = "http://" + _host + "/apple-receipt-verify";
	
	// Create a request to your server
	requestId = http_request(url, "POST", _headers, _json);

	ds_map_destroy(_headers);

	//
	// On your server, upon receiving the request you MUST create another json with the:
	//
	//		- receipt-data
	//		- password
	//		- exclude-old-transactions
	//
	// fields. This will allow you to ship the game without including the password, since it will
	// be stored in your server and you can also implement some other measure of security if you want.
	// After creating the Json redirect it to the respective URL, either:
	//
	//		- https://sandbox.itunes.apple.com/verifyReceipt (used for Sandbox)
	//		- https://buy.itunes.apple.com/verifyReceipt (used for Production)
	// 
	// Upon receiving the response, your server should then reply to GM that result.
	// (you should use the requestId to catch this result on the HTTP Async Event callback)
	// 

}


