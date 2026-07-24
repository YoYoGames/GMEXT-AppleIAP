// -----------------------------------------------------------------------------
// Latest transaction - noads
// Callback result:
// AppleIAPTransactionResult
// -----------------------------------------------------------------------------

apple_iap_transactions_latest("yyg_iap_noads", function(result, transaction) {
	show_debug_message("apple_iap_transactions_latest: yyg_iap_noads");
	show_debug_message("result: " + json_stringify(result));

	if (!result.success) {
		if (result.status == AppleIAPTransactionStatus.NoLatestTransaction) {
			show_debug_message("No latest transaction for yyg_iap_noads.");
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

	debug_entitlement(transaction);
});


// -----------------------------------------------------------------------------
// Latest transaction - 100 gems
// Callback result:
// AppleIAPTransactionResult
// -----------------------------------------------------------------------------

apple_iap_transactions_latest("yyg_iap_100gems", function(result, transaction) {
	show_debug_message("apple_iap_transactions_latest: yyg_iap_100gems");
	show_debug_message("result: " + json_stringify(result));

	if (!result.success) {
		if (result.status == AppleIAPTransactionStatus.NoLatestTransaction) {
			show_debug_message("No latest transaction for yyg_iap_100gems.");
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

	debug_entitlement(transaction);
});
