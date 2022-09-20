
/*
function Scr_IAPs_getRenewalActive() {

	var return_ = ""

	var json = Scr_IAPs_subsInf_load()

	show_debug_message("Last: " + json)

	var map = json_decode(json)

	if(!ds_map_size(map))
	{
		ds_map_destroy(map)
		return ""// same than return_
	}


	map[?"expiration_intent"]
	map[?"cancellation_date"]
	map[?"auto_renew_status"]
	map[?"auto_renew_product_id"]
	map[?"productId"]

	
	date_set_timezone(timezone_utc)

	var date_expire = date_create_datetime(1970,1,1,0,0,0)
	date_expire += map[?"expires_date_ms"] / 1000 / 86400

	show_debug_message("Current: " + date_datetime_string(date_expire) + " " + date_date_string(date_expire))

	if(date_expire > date_current_datetime())
	{
		return_ = map[?"auto_renew_product_id"]
		show_debug_message("Subcription Active: " + return_)
	
	}
	else
	{
		show_debug_message("Subcription Expired")
		//iap_consume_all_()
	}

	ds_map_destroy(map)

	return return_
}
