
var _requestId = async_load[? "id"];

if (!variable_struct_exists(validationRequests, _requestId)) exit;

var _resultJson = async_load[? "result"];
try
{
	var _resultData = json_parse(_resultJson);
}
catch(e)
{
	show_debug_message("HTTP Error: " + _resultJson)
	exit
}

// There was not error (the receipt is valid)
if (_resultData.status == 0) {

	var _purchases = validationRequests[$ _requestId];
	
	HandlePurchases(_purchases);

}
// There was an error of the receipt is not valid
else {
	show_debug_message("[WARNING] Possible invalid receipt, status code: " + string(_resultData.status));
	
	// For a list of available response codes, check the following link:
	// https://developer.apple.com/documentation/appstorereceipts/status?language=objc
}


variable_struct_remove(validationRequests, _requestId);

