
//Password: My Apps -> Select My App -> In-App Purchases -> App-Specific Share Secret
function iap_ValidationServer() 
{
	var map = ds_map_create()
	ds_map_add(map,"receipt-data",ios_iap_GetReceipt())//iap_receipt_full_read_base64())
	ds_map_add(map,"password","12b791013dfd40068f22a578c7113dae")//im not sure if this is needed
	//ds_map_add(map,"exclude-old-transactions",true);
	var json = json_encode(map)
	ds_map_destroy(map)

	return http_post_string("https://sandbox.itunes.apple.com/verifyReceipt",json)
}

