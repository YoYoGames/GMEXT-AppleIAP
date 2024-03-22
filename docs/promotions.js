// Functions

/**
 * @function iap_Promotion_Order_Fetch
 * @desc > **Apple IAP Function:** [fetchStorePromotionOrderWithCompletionHandler](https://developer.apple.com/documentation/storekit/skproductstorepromotioncontroller/2915873-fetchstorepromotionorderwithcomp?language=objc)
 * 
 * This function reads the product order override that determines the promoted product order on this device.
 * 
 * @event iap
 * @member {constant.iap_promotion_event_id} id The constant value `iap_promotion_order_fetch`.
 * @member {boolean} success Whether the fetch succeeded or not.
 * @member {string} products A JSON string containing information on the products.
 * @event_end
 * 
 * @function_end
 */

/**
 * @function iap_Promotion_Order_Update
 * @desc > **Apple IAP Function:** [updateStorePromotionOrder:completionHandler:](https://developer.apple.com/documentation/storekit/skproductstorepromotioncontroller/2915874-updatestorepromotionorder?language=objc)
 * 
 * This function overrides the promoted product order on this device.
 * 
 * @param {string} products A JSON-encoded string of an array of IAP identifiers.
 * 
 * @event iap
 * @member {constant.iap_promotion_event_id} id The constant value `iap_promotion_order_update`.
 * @member {boolean} success Whether the update was successful or not.
 * @event_end
 * 
 * @function_end
 */

/**
 * @function iap_Promotion_Visibility_Fetch
 * @desc > **Apple IAP Function:** [fetchStorePromotionVisibilityForProduct:completionHandler:](https://developer.apple.com/documentation/storekit/skproductstorepromotioncontroller/2915867-fetchstorepromotionvisibilityfor?language=objc)
 * 
 * This function reads the visibility setting of a promoted product in the App Store for this device.
 * 
 * @param {string} product The product identifier for which to get the visibility.
 * 
 * @event iap
 * @member {constant.iap_promotion_event_id} id The constant value `iap_promotion_visibility_fetch`.
 * @member {string} product The product identifier.
 * @member {boolean} success Whether the fetch was successful or not.
 * @member {constant.iap_promotion_visibility} visibility The visibility of the product.
 * @event_end
 * 
 * @function_end
 */

/**
 * @function iap_Promotion_Visibility_Update
 * @desc > **Apple IAP Function:** [updateStorePromotionVisibility:forProduct:completionHandler:](https://developer.apple.com/documentation/storekit/skproductstorepromotioncontroller/2915868-updatestorepromotionvisibility?language=objc)
 * 
 * This function updates the visibility of the product on the App Store, per device.
 * 
 * @param {constant.iap_promotion_event_id} product The IAP identifier of the product.
 * @param {constant.iap_promotion_visibility} visibility The visibility of the product.
 * 
 * @event iap
 * @desc 
 * @member {constant.iap_promotion_event_id} id The constant value `iap_promotion_visibility_update`.
 * @member {boolean} success Whether the fetch was successful or not.
 * @event_end
 * 
 * @function_end
 */

// Constants

/**
 * @const iap_promotion_event_id
 * @desc This constant represents an async event ID (or type) related to IAP promotions.
 * @member iap_promotion_purchase This event ID indicates a response to a promotion purchase.
 * @member iap_promotion_order_fetch This event ID indicates a response to an order fetch.
 * @member iap_promotion_order_update This event ID indicates a response to an order update.
 * @member iap_promotion_visibility_fetch This event ID indicates a response to a fetch of visibility settings.
 * @member iap_promotion_visibility_update This event ID indicates a response to an update of visibility settings.
 * @const_end
 */

/**
 * @const iap_promotion_visibility
 * @desc This constant represents the possibilities for promotion visibility.
 * @member iap_promotion_visibility_default Use the default promotion visibility.
 * @member iap_promotion_visibility_show Show promotions.
 * @member iap_promotion_visibility_hide Hide promotions.
 * @const_end
 */

/**
 * @module promotions
 * @title Promotions
 * @desc This is the Apple IAP Promotions module, which allows you to promote in-app purchases.
 * 
 * > **Apple IAP Object:** https://developer.apple.com/documentation/storekit/skproductstorepromotioncontroller?language=objc
 * 
 * For more information on promoting in-app purchases, see: 
 * 
 * > https://developer.apple.com/documentation/storekit/skpaymenttransactionobserver/promoting_in-app_purchases?language=objc
 * 
 * @section_func
 * @desc These are the module's functions: 
 * @ref iap_Promotion_Order_Fetch
 * @ref iap_Promotion_Order_Update
 * @ref iap_Promotion_Visibility_Fetch
 * @ref iap_Promotion_Visibility_Update
 * @section_end
 * 
 * @section_const
 * @desc These are the module's constants: 
 * @ref iap_promotion_event_id
 * @ref iap_promotion_visibility
 * @section_end
 * 
 * @module_end
 */
