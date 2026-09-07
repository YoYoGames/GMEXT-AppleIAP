/**
 * @function_partial apple_iap_init
 * @param {Function} callback
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial apple_iap_can_make_payments
 * @param {Function} callback
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
 * @param {String} [app_account_token]
 * @param {Real} [quantity]
 * @function_end
 */

/**
 * @function_partial apple_iap_transaction_finish
 * @param {String} transaction_id
 * @param {Function} callback
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
 * @member {Enum.AppleIAPProductType} type
 * @member {String} display_name
 * @member {String} description
 * @member {String} display_price
 * @member {Real} price
 * @member {String} currency_code
 * @struct_end
 */

/**
 * @struct_partial AppleIAPTransactionOffer
 * @member {String} [id]
 * @member {Enum.AppleIAPTransactionOfferType} type
 * @member {Enum.AppleIAPTransactionOfferPaymentMode} [payment_mode]
 * @struct_end
 */

/**
 * @struct_partial AppleIAPProductsResult
 * @member {Bool} success
 * @member {Enum.AppleIAPProductsStatus} status
 * @member {Enum.AppleIAPError} error
 * @member {String} message
 * @struct_end
 */

/**
 * @struct_partial AppleIAPPurchaseResult
 * @member {Bool} success
 * @member {Enum.AppleIAPPurchaseStatus} status
 * @member {Enum.AppleIAPError} error
 * @member {String} message
 * @struct_end
 */

/**
 * @struct_partial AppleIAPTransactionFinishResult
 * @member {Bool} success
 * @member {Enum.AppleIAPTransactionStatus} status
 * @member {String} message
 * @struct_end
 */

/**
 * @struct_partial AppleIAPTransactionResult
 * @member {Bool} success
 * @member {Enum.AppleIAPTransactionStatus} status
 * @member {String} message
 * @struct_end
 */

/**
 * @struct_partial AppleIAPTransactionsResult
 * @member {Bool} success
 * @member {Enum.AppleIAPTransactionStatus} status
 * @member {String} message
 * @struct_end
 */

/**
 * @struct_partial AppleIAPSyncResult
 * @member {Bool} success
 * @member {Enum.AppleIAPSyncStatus} status
 * @member {Enum.AppleIAPError} error
 * @member {String} message
 * @struct_end
 */

/**
 * @struct_partial AppleIAPTransaction
 * @member {String} id
 * @member {String} original_id
 * @member {String} web_order_line_item_id
 * @member {String} product_id
 * @member {Enum.AppleIAPProductType} product_type
 * @member {String} subscription_group_id
 * @member {Real} purchase_date_ms
 * @member {Real} original_purchase_date_ms
 * @member {Real} expiration_date_ms
 * @member {Real} revocation_date_ms
 * @member {Real} signed_date_ms
 * @member {Enum.AppleIAPRevocationReason} revocation_reason
 * @member {Bool} is_upgraded
 * @member {Enum.AppleIAPTransactionOwnershipType} ownership_type
 * @member {Enum.AppleIAPTransactionEnvironment} environment
 * @member {String} app_account_token
 * @member {Struct.AppleIAPTransactionOffer} [offer]
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
 * @member VerificationFailed
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
 * @member VerificationFailed
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
 * @enum_partial AppleIAPError
 * @member None
 * @member ProductUnavailable
 * @member PurchaseNotAllowed
 * @member IneligibleForOffer
 * @member InvalidOfferPrice
 * @member InvalidOfferSignature
 * @member InvalidOfferIdentifier
 * @member InvalidQuantity
 * @member MissingOfferParameters
 * @member PaymentMethodBindingConfigurationRequired
 * @member NetworkError
 * @member SystemError
 * @member StoreUserCancelled
 * @member NotAvailableInStorefront
 * @member NotEntitled
 * @member Unsupported
 * @member InvalidPresentationContext
 * @member Unknown
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
 * @enum_partial AppleIAPTransactionOfferType
 * @member Introductory
 * @member Promotional
 * @member Code
 * @member WinBack
 * @member Unknown
 * @enum_end
 */

/**
 * @enum_partial AppleIAPTransactionOfferPaymentMode
 * @member FreeTrial
 * @member PayAsYouGo
 * @member PayUpFront
 * @member OneTime
 * @member Unknown
 * @enum_end
 */

/**
 * @const_partial macros
 * @const_end
 */

