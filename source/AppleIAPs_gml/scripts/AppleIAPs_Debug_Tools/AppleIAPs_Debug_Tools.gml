function debug_entitlements(entitlements)
{
    show_debug_message("----Debug Entitlements----");

    for (var a = 0; a < array_length(entitlements); a++)
    {
        debug_entitlement(entitlements[a], a);
    }
}

//{"transactionId":"2000000339990473","originalTransactionId":"2000000339990473","bundleId":"com.yoyogames.updatediaptest","productId":"yyg_iap_noads","purchaseDate":1685375470000,"originalPurchaseDate":1685375470000,"quantity":1,"type":"Non-Consumable","deviceVerification":"M3UPjv4TNVy7fKhV+EXQKPXfQUrkbmqDKPy5b/F9mC9JRIu6xWvOnBBfVuRDWkio","deviceVerificationNonce":"6b60167a-39fe-40ae-b210-610cd5e15694","inAppOwnershipType":"PURCHASED","signedDate":1740545575940,"environment":"Sandbox","transactionReason":"PURCHASE","storefront":"MEX","storefrontId":"143468","price":129000,"currency":"MXN","appTransactionId":"704283432244916019"}
function debug_entitlement(entitlement, ind = 0)
{
    if (!is_struct(entitlement))
    {
        show_debug_message(string(ind) + ") Invalid entitlement: not a struct");
        return;
    }

    if (!variable_struct_exists(entitlement, "transaction"))
    {
        show_debug_message(string(ind) + ") Invalid entitlement: missing transaction");
        return;
    }

    var _transaction = entitlement.transaction;

    var _str =
        string(ind) + ") ProductID: " + string(_transaction.product_id) + "\n" +
        "Verified: " + string(entitlement.verified) + "\n" +
        "PurchaseDate: " + string(_transaction.purchase_date_ms) + "\n";

    if (_transaction.expiration_date_ms > 0)
    {
        _str += "ExpirationDate: " + string(_transaction.expiration_date_ms) + "\n";
    }

    if (!entitlement.verified)
    {
        _str += "VerificationError: " + string(entitlement.verification_error) + "\n";
    }

    _str +=
        "TransactionID: " + string(_transaction.id) + "\n" +
        "OriginalID: " + string(_transaction.original_id) + "\n" +
        "ProductType: " + string(_transaction.product_type) + "\n" +
        "Environment: " + string(_transaction.environment) + "\n" +
        "OwnershipType: " + string(_transaction.ownership_type);

    show_debug_message(_str);
}

