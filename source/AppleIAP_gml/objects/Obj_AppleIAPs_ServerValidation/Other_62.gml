

if(async_load[? "id"] != requestId) exit;

show_debug_message("Receipt HTTP ASYNC: " + json_encode(async_load))

if(async_load[? "status"] != 0 || async_load[? "http_status"] != 200)
{
	show_debug_message("Server Error: " + string(async_load[? "http_status"]));
	exit;
}

var _resultJson = async_load[? "result"];
var _resultData = json_parse(_resultJson);

// Reference links (result json structure):
// https://developer.apple.com/documentation/appstorereceipts/responsebody
// https://developer.apple.com/documentation/appstorereceipts/responsebody/receipt
// https://developer.apple.com/documentation/appstorereceipts/responsebody/pending_renewal_info
// https://developer.apple.com/documentation/appstorereceipts/responsebody/latest_receipt_info
// https://developer.apple.com/documentation/appstorereceipts/status

show_debug_message(_resultData);

