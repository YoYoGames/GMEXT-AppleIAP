show_debug_message("Restore: " + json_encode(async_load))
if (async_load[?"id"] != ios_receipt_refresh && !waitingRefreh) exit;

show_debug_message("[INFO] Receipt Refresh Callback (from button)");

waitingRefreh = false;
		
