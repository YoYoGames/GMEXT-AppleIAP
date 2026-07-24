// -----------------------------------------------------------------------------
// Unfinished transactions, debug only
// Callback result:
// AppleIAPTransactionsResult
// -----------------------------------------------------------------------------

apple_iap_transactions_unfinished(function(result, transactions) {
	show_debug_message("apple_iap_transactions_unfinished");
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

	debug_entitlements(transactions);
});
