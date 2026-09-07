// Optional StoreKit purchase options:
//
// var _app_account_token = "UUID-FOR-YOUR-PLAYER-ACCOUNT";
// var _quantity = 2;
//
// apple_iap_product_purchase(
//     data.id,
//     function(result, transaction) {
//         // ...
//     },
//     _app_account_token,
//     _quantity
// );
//
// Or, to demonstrate quantity only:
//
// apple_iap_product_purchase(
//     data.id,
//     function(result, transaction) {
//         // ...
//     },
//     undefined,
//     2
// );

apple_iap_product_purchase(data.id, function(result, transaction) {

	show_debug_message("apple_iap_product_purchase");
	show_debug_message("result: " + json_stringify(result));
	show_debug_message("transaction: " + json_stringify(transaction));

	if (!result.success) {
		show_debug_message("Purchase request failed:");
		show_debug_message("error: " + string(result.error));
		show_debug_message("message: " + result.message);
		return;
	}

	switch (result.status) {
		case AppleIAPPurchaseStatus.Success:
			show_debug_message("Purchase success.");

			debug_entitlement(transaction);

			if (transaction.id == "") {
				show_debug_message("Purchase transaction has no transaction id.");
				return;
			}

			// -----------------------------------------------------------------
			// Grant the purchase BEFORE finishing the StoreKit transaction.
			// In a real game, replace this with your unlock/currency logic.
			// -----------------------------------------------------------------

			switch (transaction.product_id) {
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
					show_debug_message(transaction.product_id);
					break;
			}

			// -----------------------------------------------------------------
			// Finish the transaction after granting/persisting the purchase.
			// StoreKit transaction id must stay as a string.
			// -----------------------------------------------------------------

			apple_iap_transaction_finish(transaction.id, function(finish_result) {
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

		case AppleIAPPurchaseStatus.VerificationFailed:
			show_debug_message("Purchase verification failed: " + result.message);
			break;

		case AppleIAPPurchaseStatus.ProductNotFound:
			show_debug_message("Product not found. Did you call apple_iap_products first?");
			show_debug_message(result.message);
			break;

		case AppleIAPPurchaseStatus.Error:
			show_debug_message("Purchase error: " + string(result.error));
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
