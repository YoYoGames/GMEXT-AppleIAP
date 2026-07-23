// -----------------------------------------------------------------------------
// Synchronize / restore purchases
// Callback result:
// AppleIAPSyncResult
// -----------------------------------------------------------------------------

apple_iap_synchronize(function(result) {
    show_debug_message("apple_iap_synchronize");
    show_debug_message("result: " + json_stringify(result));
    
    if (!result.success) {
        show_debug_message("error:");
        show_debug_message(result.message);
        return;
    }
    
    if (result.status == AppleIAPSyncStatus.Success) {
        show_debug_message("synchronized");
    } else {
        show_debug_message("Unexpected sync status: " + string(result.status));
        show_debug_message(result.message);
    }
});