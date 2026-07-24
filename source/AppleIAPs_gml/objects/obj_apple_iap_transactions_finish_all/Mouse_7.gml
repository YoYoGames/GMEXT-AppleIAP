// -----------------------------------------------------------------------------
// Finish all unfinished transactions
//
// apple_iap_transactions_unfinished result:
// AppleIAPTransactionsResult
//
// apple_iap_transaction_finish result:
// AppleIAPTransactionFinishResult
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

	for (var a = 0; a < array_length(transactions); a++) {
		var _transaction = transactions[a];

		var _transaction_id = _transaction.id;

		if (_transaction_id == "") {
			show_debug_message("Skipping transaction: no transaction id found.");
			continue;
		}

		apple_iap_transaction_finish(_transaction_id, function(finish_result) {
			show_debug_message("apple_iap_transaction_finish");
			show_debug_message("result: " + json_stringify(finish_result));

			if (!finish_result.success) {
				show_debug_message("error:");
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
	}
});
