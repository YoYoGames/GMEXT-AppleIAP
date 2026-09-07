event_inherited();


var _can_make_payments = apple_iap_can_make_payments()

if(!_can_make_payments)
{
	show_debug_message($"Payments NOT Availables");
	instance_destroy()
	exit
}

// Initialize Apple IAP and listen for transaction updates
iap_initialized = apple_iap_init(function(result, transaction) {

	show_debug_message("apple_iap_init TRIGGERED");
	show_debug_message("result: " + json_stringify(result));
	show_debug_message("transaction: " + json_stringify(transaction));

	if (!result.success) {
		show_debug_message("apple_iap_init error:");
		show_debug_message("error: " + string(result.error));
		show_debug_message("message: " + result.message);
		return;
	}

	switch (result.status) {
		case AppleIAPTransactionStatus.Success:
			show_debug_message("Transaction update received: " + transaction.product_id);

			debug_entitlement(transaction);

			// Optional: finish verified unfinished/purchased transactions here.
			// Be careful with subscriptions/non-consumables depending on your flow.
			//
			// if (transaction.id != "") {
			//     apple_iap_transaction_finish(transaction.id, function(finish_result) {
			//         show_debug_message("apple_iap_transaction_finish from updates");
			//         show_debug_message("result: " + json_stringify(finish_result));
			//
			//         if (!finish_result.success) {
			//             show_debug_message("finish error:");
			//             show_debug_message(finish_result.message);
			//             return;
			//         }
			//
			//         if (finish_result.status == AppleIAPTransactionStatus.Success) {
			//             show_debug_message("Transaction finished.");
			//         }
			//     });
			// }
			break;

		case AppleIAPTransactionStatus.VerificationFailed:
			show_debug_message("Rejected unverified transaction: " + result.message);
			break;

		default:
			show_debug_message("Transaction listener error: " + result.message);
			break;
	}
});

var _product_ids = [
	"yyg_iap_100gems",
	"yyg_iap_noads",
	"yyg_iap_monthlysub",
	"yyg_iap_yearpromosub"
];

apple_iap_products(_product_ids, function(result, products) {

	show_debug_message("Callback apple_iap_products");
	show_debug_message("result: " + json_stringify(result));

	if (!result.success) {
		show_debug_message("apple_iap_products error:");
		show_debug_message("error: " + string(result.error));
		show_debug_message("message: " + result.message);
		return;
	}

	if (result.status != AppleIAPProductsStatus.Success) {
		show_debug_message("apple_iap_products unexpected status:");
		show_debug_message(string(result.status));
		show_debug_message(result.message);
		return;
	}

	show_debug_message("----- Products from Apple IAPs! -----");

	for (var a = 0; a < array_length(products); a++) {

		var _product = products[a];

		instance_create_depth(
			200 + 300 * a,
			room_height / 2,
			0,
			obj_apple_iap_product,
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

apple_iap_transactions_current_entitlements(function(result, transactions) {

	show_debug_message("Callback apple_iap_transactions_current_entitlements");
	show_debug_message("result: " + json_stringify(result));

	if (!result.success) {
		show_debug_message("apple_iap_transactions_current_entitlements error:");
		show_debug_message("error: " + string(result.error));
		show_debug_message("message: " + result.message);
		return;
	}

	if (result.status != AppleIAPTransactionStatus.Success) {
		show_debug_message("apple_iap_transactions_current_entitlements unexpected status:");
		show_debug_message(string(result.status));
		show_debug_message(result.message);
		return;
	}

	debug_entitlements(transactions);
});
