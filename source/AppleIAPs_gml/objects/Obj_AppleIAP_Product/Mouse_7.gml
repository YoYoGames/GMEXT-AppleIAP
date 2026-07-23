apple_iap_product_purchase(data.id, function(result) {
    
    show_debug_message("apple_iap_product_purchase");
    show_debug_message("result: " + json_stringify(result));
    
    if (!result.success) {
        show_debug_message("Purchase request failed:");
        show_debug_message(result.message);
        return;
    }
    
    switch (result.status) {
        case AppleIAPPurchaseStatus.Success:
            show_debug_message("Purchase success.");
            
            var _transaction_verification = result.transaction;
            
            debug_entitlement(_transaction_verification);
            
            if (!_transaction_verification.verified) {
                show_debug_message("Purchase transaction is not verified.");
                show_debug_message(_transaction_verification.verification_error);
                return;
            }
            
            var _transaction = _transaction_verification.transaction;
            
            if (_transaction.id == "") {
                show_debug_message("Purchase transaction has no transaction id.");
                return;
            }
            
            // -----------------------------------------------------------------
            // Grant the purchase BEFORE finishing the StoreKit transaction.
            // In a real game, replace this with your unlock/currency logic.
            // -----------------------------------------------------------------
            
            switch (_transaction.product_id) {
                case "yyg_iap_100gems":
                    show_debug_message("Granting 100 gems.");
                    // global.gems += 100;
                    // save_game();
                    break;
                
                case "yyg_iap_noads":
                    show_debug_message("Unlocking no ads.");
                    // global.no_ads = true;
                    // save_game();
                    break;
                
                case "yyg_iap_monthlysub":
                    show_debug_message("Monthly subscription entitlement active.");
                    break;
                
                case "yyg_iap_yearpromosub":
                    show_debug_message("Year promo subscription entitlement active.");
                    break;
                
                default:
                    show_debug_message("Purchased unknown product:");
                    show_debug_message(_transaction.product_id);
                    break;
            }
            
            // -----------------------------------------------------------------
            // Finish the transaction after granting/persisting the purchase.
            // StoreKit transaction id must stay as a string.
            // -----------------------------------------------------------------
            
            apple_iap_transaction_finish(_transaction.id, function(finish_result) {
                show_debug_message("apple_iap_transaction_finish");
                show_debug_message("result: " + json_stringify(finish_result));
                
                if (!finish_result.success) {
                    show_debug_message("Finish transaction failed:");
                    show_debug_message(finish_result.message);
                    return;
                }
                
                if (finish_result.status == AppleIAPTransactionStatus.Success) {
                    show_debug_message("Transaction finished.");
                } else {
                    show_debug_message("Unexpected finish status:");
                    show_debug_message(string(finish_result.status));
                    show_debug_message(finish_result.message);
                }
            });
            
            break;
        
        case AppleIAPPurchaseStatus.UserCancelled:
            show_debug_message("User cancelled purchase.");
            break;
        
        case AppleIAPPurchaseStatus.Pending:
            show_debug_message("Purchase pending. Do not grant yet.");
            break;
        
        case AppleIAPPurchaseStatus.ProductNotFound:
            show_debug_message("Product not found. Did you call apple_iap_products first?");
            show_debug_message(result.message);
            break;
        
        case AppleIAPPurchaseStatus.Error:
            show_debug_message("Purchase error:");
            show_debug_message(result.message);
            break;
        
        case AppleIAPPurchaseStatus.Unknown:
            show_debug_message("Unknown purchase result:");
            show_debug_message(result.message);
            break;
        
        default:
            show_debug_message("Unhandled purchase status: " + string(result.status));
            show_debug_message(result.message);
            break;
    }
});