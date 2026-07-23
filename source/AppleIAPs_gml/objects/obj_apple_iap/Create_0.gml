event_inherited();


// Next 2 functions should be called to start using Apple IAPs correctly.
apple_iap_init();

var _product_ids = [
    "yyg_iap_100gems",
    "yyg_iap_noads",
    "yyg_iap_monthlysub",
    "yyg_iap_yearpromosub"
];

apple_iap_products(_product_ids, function(result) {
    
    show_debug_message("Callback apple_iap_products");
    show_debug_message("result: " + json_stringify(result));
    
    if (!result.success) {
        show_debug_message("apple_iap_products error:");
        show_debug_message(result.message);
        return;
    }
    
    if (result.status != AppleIAPProductsStatus.Success) {
        show_debug_message("apple_iap_products unexpected status:");
        show_debug_message(string(result.status));
        show_debug_message(result.message);
        return;
    }
    
    show_debug_message("----- Products from Apple IAPs! -----");
    
    var _products = result.products;
    
    for (var a = 0; a < array_length(_products); a++) {
        
        var _product = _products[a];
        
        instance_create_depth(
            200 + 300 * a,
            room_height / 2,
            0,
            Obj_AppleIAP_Product,
            {
                data: _product
            }
        );
        
        show_debug_message("Product:");
        show_debug_message(_product);
        show_debug_message("id: " + _product.id);
        show_debug_message("display_name: " + _product.display_name);
        show_debug_message("display_price: " + _product.display_price);
        show_debug_message("price: " + string(_product.price));
        show_debug_message("type: " + string(_product.type));
    }
});


apple_iap_transactions_current_entitlements(function(result) {
    
    show_debug_message("Callback apple_iap_transactions_current_entitlements");
    show_debug_message("result: " + json_stringify(result));
    
    if (!result.success) {
        show_debug_message("apple_iap_transactions_current_entitlements error:");
        show_debug_message(result.message);
        return;
    }
    
    if (result.status != AppleIAPTransactionStatus.Success) {
        show_debug_message("apple_iap_transactions_current_entitlements unexpected status:");
        show_debug_message(string(result.status));
        show_debug_message(result.message);
        return;
    }
    
    var _transaction_verifications = result.transactions;
    debug_entitlements(_transaction_verifications);
});


// Catch external App Store transaction updates.
// This callback can trigger many times.
// Each trigger receives one transaction verification.
apple_iap_transactions_updates(function(result) {
    
    show_debug_message("apple_iap_transactions_updates TRIGGERED");
    show_debug_message("result: " + json_stringify(result));
    
    if (!result.success) {
        show_debug_message("apple_iap_transactions_updates error:");
        show_debug_message(result.message);
        return;
    }
    
    if (result.status != AppleIAPTransactionStatus.Success) {
        show_debug_message("apple_iap_transactions_updates unexpected status:");
        show_debug_message(string(result.status));
        show_debug_message(result.message);
        return;
    }
    
    var _transaction_verification = result.transaction;
    
    show_debug_message("transaction_verification:");
    show_debug_message(_transaction_verification);
    
    debug_entitlement(_transaction_verification);
    
    // Optional: finish verified unfinished/purchased transactions here.
    // Be careful with subscriptions/non-consumables depending on your flow.
    //
    // if (_transaction_verification.verified) {
    //     var _transaction = _transaction_verification.transaction;
    //     var _transaction_id = _transaction.id;
    //
    //     if (_transaction_id != "") {
    //         apple_iap_transaction_finish(_transaction_id, function(finish_result) {
    //             show_debug_message("apple_iap_transaction_finish from updates");
    //             show_debug_message("result: " + json_stringify(finish_result));
    //
    //             if (!finish_result.success) {
    //                 show_debug_message("finish error:");
    //                 show_debug_message(finish_result.message);
    //                 return;
    //             }
    //
    //             if (finish_result.status == AppleIAPTransactionStatus.Success) {
    //                 show_debug_message("Transaction finished.");
    //             }
    //         });
    //     }
    // }
});