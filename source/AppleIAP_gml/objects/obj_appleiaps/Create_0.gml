
#macro iap_consumable "yyg_iap_100gems"
#macro iap_nonconsumable "yyg_iap_noads"
#macro iap_renewablesub "yyg_iap_monthlysub"
#macro iap_nonrenewablesub "yyg_iap_yearpromosub"

iap_Init()

waitingRefreh = false;
validationRequests = {};

iap_AddProduct(iap_consumable);
iap_AddProduct(iap_nonconsumable);
iap_AddProduct(iap_renewablesub);
iap_AddProduct(iap_nonrenewablesub);

// Query newly added products
iap_QueryProducts();

// Handle pending purchases
var purchasesJson = iap_QueryPurchases();
if (purchasesJson != "") {
	var purchasesData = json_parse(purchasesJson);
	var purchases = purchasesData.purchases;
	
	HandlePurchases(purchases, true);
}


