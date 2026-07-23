// -----------------------------------------------------------------------------
// Current entitlement - noads
// Callback shape:
// (_success, _transaction_verification_json, _error)
// -----------------------------------------------------------------------------

apple_iap_transactions_current_entitlement("yyg_iap_noads", function(_success, _transaction_verification_json, _error) {
    show_debug_message("apple_iap_transactions_current_entitlement: yyg_iap_noads");
    show_debug_message("success: " + string(_success));
    
    if (!_success) {
        show_debug_message("error: " + string(_error));
        return;
    }
    
    show_debug_message("transaction_verification_json");
    show_debug_message(_transaction_verification_json);
    
    var _transaction_verification = (_transaction_verification_json);
    debug_entitlement(_transaction_verification);
});

// -----------------------------------------------------------------------------
// Current entitlement - 100 gems
// Callback shape:
// (_success, _transaction_verification_json, _error)
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Current entitlement - no ads
// Callback result:
// AppleIAPTransactionResult
// -----------------------------------------------------------------------------

apple_iap_transactions_current_entitlement("yyg_iap_noads", function(result) {
    show_debug_message("apple_iap_transactions_current_entitlement: yyg_iap_noads");
    show_debug_message("result: " + json_stringify(result));
    
    if (!result.success) {
        if (result.status == AppleIAPTransactionStatus.NoCurrentEntitlement) {
            show_debug_message("No current entitlement for yyg_iap_noads.");
        } else {
            show_debug_message("error:");
            show_debug_message(result.message);
        }
        return;
    }
    
    if (result.status != AppleIAPTransactionStatus.Success) {
        show_debug_message("Unexpected transaction status:");
        show_debug_message(string(result.status));
        show_debug_message(result.message);
        return;
    }
    
    var _transaction_verification = result.transaction;
    debug_entitlement(_transaction_verification);
});


// -----------------------------------------------------------------------------
// Current entitlement - 100 gems
// Callback result:
// AppleIAPTransactionResult
// -----------------------------------------------------------------------------

apple_iap_transactions_current_entitlement("yyg_iap_100gems", function(result) {
    show_debug_message("apple_iap_transactions_current_entitlement: yyg_iap_100gems");
    show_debug_message("result: " + json_stringify(result));
    
    if (!result.success) {
        if (result.status == AppleIAPTransactionStatus.NoCurrentEntitlement) {
            show_debug_message("No current entitlement for yyg_iap_100gems.");
        } else {
            show_debug_message("error:");
            show_debug_message(result.message);
        }
        return;
    }
    
    if (result.status != AppleIAPTransactionStatus.Success) {
        show_debug_message("Unexpected transaction status:");
        show_debug_message(string(result.status));
        show_debug_message(result.message);
        return;
    }
    
    var _transaction_verification = result.transaction;
    debug_entitlement(_transaction_verification);
});

