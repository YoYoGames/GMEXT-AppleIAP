function debug_entitlements(transactions)
{
	show_debug_message("----Debug Transactions----");

	for (var a = 0; a < array_length(transactions); a++)
	{
		debug_entitlement(transactions[a], a);
	}
}

function debug_entitlement(transaction, ind = 0)
{
	if (!is_struct(transaction))
	{
		show_debug_message(string(ind) + ") Invalid transaction: not a struct");
		return;
	}

	if (!variable_struct_exists(transaction, "product_id"))
	{
		show_debug_message(string(ind) + ") Invalid transaction: missing product_id");
		return;
	}

	var _str =
		string(ind) + ") ProductID: " + string(transaction.product_id) + "\n" +
		"PurchaseDate: " + string(transaction.purchase_date_ms) + "\n";

	if (transaction.expiration_date_ms > 0)
	{
		_str += "ExpirationDate: " + string(transaction.expiration_date_ms) + "\n";
	}

	_str +=
		"TransactionID: " + string(transaction.id) + "\n" +
		"OriginalID: " + string(transaction.original_id) + "\n" +
		"ProductType: " + string(transaction.product_type) + "\n" +
		"Environment: " + string(transaction.environment) + "\n" +
		"OwnershipType: " + string(transaction.ownership_type);

	if (!is_undefined(transaction.offer)) {
		_str += "\nOfferType: " + string(transaction.offer.type);

		if (!is_undefined(transaction.offer.id)) {
			_str += "\nOfferID: " + transaction.offer.id;
		}

		if (!is_undefined(transaction.offer.payment_mode)) {
			_str += "\nOfferPaymentMode: " + string(transaction.offer.payment_mode);
		}
	}

	show_debug_message(_str);
}
