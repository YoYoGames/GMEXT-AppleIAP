/**
 * @function_partial apple_iap_init
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial apple_iap_products
 * @param {Array[String]} products_id
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial apple_iap_product_purchase
 * @param {String} product_id
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial apple_iap_transaction_finish
 * @param {String} transaction_id
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial apple_iap_transactions_updates
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial apple_iap_transactions_updates_stop
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial apple_iap_transactions_current_entitlement
 * @param {String} product_id
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial apple_iap_transactions_current_entitlements
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial apple_iap_transactions_latest
 * @param {String} product_id
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial apple_iap_transactions_unfinished
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial apple_iap_transactions_all
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial apple_iap_synchronize
 * @param {Function} callback
 * @function_end
 */

/**
 * @struct_partial AppleIAPProduct
 * @member {String} id
 * @member {Real} type
 * @member {String} display_name
 * @member {String} description
 * @member {String} display_price
 * @member {Real} price
 * @member {String} currency_code
 * @struct_end
 */

/**
 * @struct_partial AppleIAPTransaction
 * @member {String} id
 * @member {String} original_id
 * @member {String} web_order_line_item_id
 * @member {String} product_id
 * @member {Real} product_type
 * @member {String} subscription_group_id
 * @member {Real} purchase_date_ms
 * @member {Real} original_purchase_date_ms
 * @member {Real} expiration_date_ms
 * @member {Real} revocation_date_ms
 * @member {Real} signed_date_ms
 * @member {Real} revocation_reason
 * @member {Bool} is_upgraded
 * @member {Real} ownership_type
 * @member {Real} environment
 * @member {String} app_account_token
 * @member {String} offer_id
 * @struct_end
 */

/**
 * @struct_partial AppleIAPTransactionFinishResult
 * @member {Bool} success
 * @member {Real} status
 * @member {String} message
 * @struct_end
 */

/**
 * @struct_partial AppleIAPSyncResult
 * @member {Bool} success
 * @member {Real} status
 * @member {String} message
 * @struct_end
 */

/**
 * @struct_partial AppleIAPProductsResult
 * @member {Bool} success
 * @member {Real} status
 * @member {String} message
 * @member {Array[Struct.AppleIAPProduct]} products
 * @struct_end
 */

/**
 * @struct_partial AppleIAPVerifiedTransaction
 * @member {Bool} verified
 * @member {Struct.AppleIAPTransaction} transaction
 * @member {String} verification_error
 * @struct_end
 */

/**
 * @struct_partial AppleIAPPurchaseResult
 * @member {Bool} success
 * @member {Real} status
 * @member {String} message
 * @member {Struct.AppleIAPVerifiedTransaction} transaction
 * @struct_end
 */

/**
 * @struct_partial AppleIAPTransactionResult
 * @member {Bool} success
 * @member {Real} status
 * @member {String} message
 * @member {Struct.AppleIAPVerifiedTransaction} transaction
 * @struct_end
 */

/**
 * @struct_partial AppleIAPTransactionsResult
 * @member {Bool} success
 * @member {Real} status
 * @member {String} message
 * @member {Array[Struct.AppleIAPVerifiedTransaction]} transactions
 * @struct_end
 */

/**
 * @enum_partial AppleIAPProductsStatus
 * @member None
 * @member Success
 * @member EmptyProductIds
 * @member Error
 * @enum_end
 */

/**
 * @enum_partial AppleIAPPurchaseStatus
 * @member None
 * @member Success
 * @member UserCancelled
 * @member Pending
 * @member ProductNotFound
 * @member Error
 * @member Unknown
 * @enum_end
 */

/**
 * @enum_partial AppleIAPTransactionStatus
 * @member None
 * @member Success
 * @member InvalidTransactionId
 * @member TransactionNotFound
 * @member NoCurrentEntitlement
 * @member NoLatestTransaction
 * @member Error
 * @enum_end
 */

/**
 * @enum_partial AppleIAPSyncStatus
 * @member None
 * @member Success
 * @member Error
 * @enum_end
 */

/**
 * @enum_partial AppleIAPProductType
 * @member Unknown
 * @member Consumable
 * @member NonConsumable
 * @member NonRenewable
 * @member AutoRenewable
 * @enum_end
 */

/**
 * @enum_partial AppleIAPTransactionEnvironment
 * @member Unknown
 * @member Xcode
 * @member Sandbox
 * @member Production
 * @enum_end
 */

/**
 * @enum_partial AppleIAPTransactionOwnershipType
 * @member Unknown
 * @member Purchased
 * @member FamilyShared
 * @enum_end
 */

/**
 * @enum_partial AppleIAPRevocationReason
 * @member None
 * @member DeveloperIssue
 * @member Other
 * @member Unknown
 * @enum_end
 */

/**
 * @const_partial macros
 * @const_end
 */

