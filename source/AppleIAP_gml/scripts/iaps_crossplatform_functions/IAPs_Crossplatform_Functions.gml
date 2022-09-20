
function iap_IsAuthorisedForPayment()
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_IsAuthorisedForPayment()
	else
	if(os_type == os_macosx)
		return mac_iap_IsAuthorisedForPayment()
}
function iap_AddProduct(_productId)
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_AddProduct(_productId)
	else
	if(os_type == os_macosx)
		return mac_iap_AddProduct(_productId)
}

function iap_QueryProducts()
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_QueryProducts()
	else
	if(os_type == os_macosx)
		return mac_iap_QueryProducts()
}

function iap_QueryPurchases()
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_QueryPurchases()
	else
	if(os_type == os_macosx)
		return mac_iap_QueryPurchases()
}

function iap_PurchaseProduct(_productId)
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_PurchaseProduct(_productId)
	else
	if(os_type == os_macosx)
		return mac_iap_PurchaseProduct(_productId)
}

function iap_RestorePurchases()
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_RestorePurchases()
	else
	if(os_type == os_macosx)
		return mac_iap_RestorePurchases()
}

function iap_FinishTransaction(_purchaseToken)
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_FinishTransaction(_purchaseToken)
	else
	if(os_type == os_macosx)
		return mac_iap_FinishTransaction(_purchaseToken)
}

function iap_GetReceipt()
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_GetReceipt()
	else
	if(os_type == os_macosx)
		return mac_iap_GetReceipt()
}

function iap_ValidateReceipt()
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_ValidateReceipt()
	else
	if(os_type == os_macosx)
		return mac_iap_ValidateReceipt()
}

function iap_RefreshReceipt()
{
	if(os_type == os_ios or os_type == os_tvos)
		return ios_iap_RefreshReceipt();
	else
	if(os_type == os_macosx)
		return mac_iap_RefreshReceipt();
}

function iap_PurchaseFailed(_state)
{
	if(os_type == os_ios or os_type == os_tvos)
		return _state == ios_purchase_failed;
	else
	if(os_type == os_macosx)
		return _state == mac_purchase_failed;
}

