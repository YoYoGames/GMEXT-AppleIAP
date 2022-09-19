
// This is a local verification of the signature of the receipt
// NOTE: This will not validate the receipt itself.
var validRes = iap_ValidateReceipt();
show_debug_message("Receipt valid: " + string(validRes));

