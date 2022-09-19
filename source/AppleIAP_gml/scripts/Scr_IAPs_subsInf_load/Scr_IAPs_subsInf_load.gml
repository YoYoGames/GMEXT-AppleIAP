/*

function Scr_IAPs_subsInf_load() {

	 
	KEYS:
		"expiration_intent"
		"cancellation_date"
		"auto_renew_status"
		"expires_date_ms"
		"auto_renew_product_id"
		"productId"


	if(!file_exists("subcriptions.dat"))
		return("{}")

	var map = ds_map_secure_load("subcriptions.dat")

	var json = json_encode(map)

	ds_map_destroy(map)

	return json;

}
