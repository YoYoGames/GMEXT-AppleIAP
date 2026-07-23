// -----------------------------------------------------------------------------
// All transactions
// Callback shape:
// (_success, _transaction_verifications_json, _error)
// -----------------------------------------------------------------------------

apple_iap_transactions_all(function(result) {
    show_debug_message("apple_iap_transactions_all");
    show_debug_message("result: " + json_stringify(result));
    
    if (!result.success) {
        show_debug_message("error:");
        show_debug_message(result.message);
        return;
    }
    
    if (result.status != AppleIAPTransactionStatus.Success) {
        show_debug_message("Unexpected transaction status:");
        show_debug_message(string(result.status));
        show_debug_message(result.message);
        return;
    }
    
    var _transaction_verifications = result.transactions;
    debug_entitlements(_transaction_verifications);
});