import Foundation
import CxxStdlib
import StoreKit

public class GMAppleIAPsSwift: GMAppleIAPsInternalSwift {

    private var appProducts: [Product] = []
    private var appProductsById: [String: Product] = [:]
    private var transactionUpdatesTask: Task<Void, Never>?

    public override init() {
        super.init()
    }

    public override func apple_iap_init() -> Bool {
        return true
    }

    public override func apple_iap_products(products_id: [String], callback: GMFunction) {
        Task {
            let productIds = products_id
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }

            guard !productIds.isEmpty else {
                callback.call(self.productsResult(
                    success: false,
                    status: AppleIAPProductsStatus.EmptyProductIds,
                    message: "Product id list is empty."
                ))
                return
            }

            do {
                let products = try await Product.products(for: productIds)

                self.appProducts = products
                self.appProductsById = Dictionary(uniqueKeysWithValues: products.map { ($0.id, $0) })

                callback.call(self.productsResult(
                    success: true,
                    status: AppleIAPProductsStatus.Success,
                    products: products.map { self.productToRecord($0) }
                ))
            } catch {
                callback.call(self.productsResult(
                    success: false,
                    status: AppleIAPProductsStatus.Error,
                    message: error.localizedDescription
                ))
            }
        }
    }

    public override func apple_iap_product_purchase(product_id: String, callback: GMFunction) {
        Task {
            guard let product = self.appProductsById[product_id] ?? self.appProducts.first(where: { $0.id == product_id }) else {
                callback.call(self.purchaseResult(
                    success: false,
                    status: AppleIAPPurchaseStatus.ProductNotFound,
                    message: "Product not found. Call apple_iap_products first."
                ))
                return
            }

            do {
                let purchaseResult = try await product.purchase()

                switch purchaseResult {
                case .success(let verificationResult):
                    callback.call(self.purchaseResult(
                        success: true,
                        status: AppleIAPPurchaseStatus.Success,
                        transaction: self.verificationResultToRecord(verificationResult)
                    ))

                case .userCancelled:
                    callback.call(self.purchaseResult(
                        success: true,
                        status: AppleIAPPurchaseStatus.UserCancelled
                    ))

                case .pending:
                    callback.call(self.purchaseResult(
                        success: true,
                        status: AppleIAPPurchaseStatus.Pending
                    ))

                @unknown default:
                    callback.call(self.purchaseResult(
                        success: true,
                        status: AppleIAPPurchaseStatus.Unknown,
                        message: "Unknown StoreKit purchase result."
                    ))
                }
            } catch {
                callback.call(self.purchaseResult(
                    success: false,
                    status: AppleIAPPurchaseStatus.Error,
                    message: error.localizedDescription
                ))
            }
        }
    }

    public override func apple_iap_transaction_finish(transaction_id: String, callback: GMFunction) {
        Task {
            guard let targetId = UInt64(transaction_id) else {
                callback.call(self.transactionFinishResult(
                    success: false,
                    status: AppleIAPTransactionStatus.InvalidTransactionId,
                    message: "Invalid transaction id."
                ))
                return
            }

            do {
                for await result in StoreKit.Transaction.unfinished {
                    let transaction = try result.payloadValue

                    if transaction.id == targetId {
                        await transaction.finish()
                        callback.call(self.transactionFinishResult(
                            success: true,
                            status: AppleIAPTransactionStatus.Success
                        ))
                        return
                    }
                }

                callback.call(self.transactionFinishResult(
                    success: false,
                    status: AppleIAPTransactionStatus.TransactionNotFound,
                    message: "Transaction not found in unfinished transactions."
                ))
            } catch {
                callback.call(self.transactionFinishResult(
                    success: false,
                    status: AppleIAPTransactionStatus.Error,
                    message: error.localizedDescription
                ))
            }
        }
    }

    public override func apple_iap_transactions_updates(callback: GMFunction) {
        transactionUpdatesTask?.cancel()

        transactionUpdatesTask = Task {
            for await result in StoreKit.Transaction.updates {
                if Task.isCancelled {
                    return
                }

                callback.call(self.transactionResult(
                    success: true,
                    status: AppleIAPTransactionStatus.Success,
                    transaction: self.verificationResultToRecord(result)
                ))
            }
        }
    }

    public override func apple_iap_transactions_updates_stop() -> Bool {
        transactionUpdatesTask?.cancel()
        transactionUpdatesTask = nil
        return true
    }

    public override func apple_iap_transactions_current_entitlement(product_id: String, callback: GMFunction) {
        Task {
            if #available(iOS 18.4, macOS 15.4, tvOS 18.4, *) {
                var transactions: [AppleIAPVerifiedTransaction] = []

                for await result in Transaction.currentEntitlements(for: product_id) {
                    transactions.append(self.verificationResultToRecord(result))
                }

                guard let firstTransaction = transactions.first else {
                    callback.call(self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.NoCurrentEntitlement,
                        message: "No current entitlement for this product."
                    ))
                    return
                }

                callback.call(self.transactionResult(
                    success: true,
                    status: AppleIAPTransactionStatus.Success,
                    transaction: firstTransaction
                ))
            } else {
                guard let verificationResult = await self.legacyCurrentEntitlement(for: product_id) else {
                    callback.call(self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.NoCurrentEntitlement,
                        message: "No current entitlement for this product."
                    ))
                    return
                }

                callback.call(self.transactionResult(
                    success: true,
                    status: AppleIAPTransactionStatus.Success,
                    transaction: self.verificationResultToRecord(verificationResult)
                ))
            }
        }
    }

    public override func apple_iap_transactions_current_entitlements(callback: GMFunction) {
        Task {
            var transactions: [AppleIAPVerifiedTransaction] = []

            for await result in Transaction.currentEntitlements {
                transactions.append(self.verificationResultToRecord(result))
            }

            callback.call(self.transactionsResult(
                success: true,
                status: AppleIAPTransactionStatus.Success,
                transactions: transactions
            ))
        }
    }

    public override func apple_iap_transactions_latest(product_id: String, callback: GMFunction) {
        Task {
            guard let verificationResult = await Transaction.latest(for: product_id) else {
                callback.call(self.transactionResult(
                    success: false,
                    status: AppleIAPTransactionStatus.NoLatestTransaction,
                    message: "No latest transaction for this product."
                ))
                return
            }

            callback.call(self.transactionResult(
                success: true,
                status: AppleIAPTransactionStatus.Success,
                transaction: self.verificationResultToRecord(verificationResult)
            ))
        }
    }

    public override func apple_iap_transactions_unfinished(callback: GMFunction) {
        Task {
            var transactions: [AppleIAPVerifiedTransaction] = []

            for await result in Transaction.unfinished {
                transactions.append(self.verificationResultToRecord(result))
            }

            callback.call(self.transactionsResult(
                success: true,
                status: AppleIAPTransactionStatus.Success,
                transactions: transactions
            ))
        }
    }

    public override func apple_iap_transactions_all(callback: GMFunction) {
        Task {
            var transactions: [AppleIAPVerifiedTransaction] = []

            for await result in Transaction.all {
                transactions.append(self.verificationResultToRecord(result))
            }

            callback.call(self.transactionsResult(
                success: true,
                status: AppleIAPTransactionStatus.Success,
                transactions: transactions
            ))
        }
    }

    public override func apple_iap_synchronize(callback: GMFunction) {
        Task {
            do {
                try await AppStore.sync()
                callback.call(self.syncResult(
                    success: true,
                    status: AppleIAPSyncStatus.Success
                ))
            } catch {
                callback.call(self.syncResult(
                    success: false,
                    status: AppleIAPSyncStatus.Error,
                    message: error.localizedDescription
                ))
            }
        }
    }
}

private extension GMAppleIAPsSwift {

    // MARK: - StoreKit compatibility

    @available(iOS, introduced: 15.0, deprecated: 18.4)
    @available(macOS, introduced: 12.0, deprecated: 15.4)
    @available(tvOS, introduced: 15.0, deprecated: 18.4)
    func legacyCurrentEntitlement(for productId: String) async -> VerificationResult<Transaction>? {
        return await Transaction.currentEntitlement(for: productId)
    }

    // MARK: - Result helpers

    func productsResult(
        success: Bool,
        status: AppleIAPProductsStatus = AppleIAPProductsStatus.None,
        message: String = "",
        products: [AppleIAPProduct] = []
    ) -> AppleIAPProductsResult {
        return AppleIAPProductsResult(
            success: success,
            status: status.rawValue,
            message: message,
            products: products
        )
    }

    func purchaseResult(
        success: Bool,
        status: AppleIAPPurchaseStatus = AppleIAPPurchaseStatus.None,
        message: String = "",
        transaction: AppleIAPVerifiedTransaction? = nil
    ) -> AppleIAPPurchaseResult {
        return AppleIAPPurchaseResult(
            success: success,
            status: status.rawValue,
            message: message,
            transaction: transaction ?? emptyVerifiedTransaction()
        )
    }

    func transactionFinishResult(
        success: Bool,
        status: AppleIAPTransactionStatus = AppleIAPTransactionStatus.None,
        message: String = ""
    ) -> AppleIAPTransactionFinishResult {
        return AppleIAPTransactionFinishResult(
            success: success,
            status: status.rawValue,
            message: message
        )
    }

    func transactionResult(
        success: Bool,
        status: AppleIAPTransactionStatus = AppleIAPTransactionStatus.None,
        message: String = "",
        transaction: AppleIAPVerifiedTransaction? = nil
    ) -> AppleIAPTransactionResult {
        return AppleIAPTransactionResult(
            success: success,
            status: status.rawValue,
            message: message,
            transaction: transaction ?? emptyVerifiedTransaction()
        )
    }

    func transactionsResult(
        success: Bool,
        status: AppleIAPTransactionStatus = AppleIAPTransactionStatus.None,
        message: String = "",
        transactions: [AppleIAPVerifiedTransaction] = []
    ) -> AppleIAPTransactionsResult {
        return AppleIAPTransactionsResult(
            success: success,
            status: status.rawValue,
            message: message,
            transactions: transactions
        )
    }

    func syncResult(
        success: Bool,
        status: AppleIAPSyncStatus = AppleIAPSyncStatus.None,
        message: String = ""
    ) -> AppleIAPSyncResult {
        return AppleIAPSyncResult(
            success: success,
            status: status.rawValue,
            message: message
        )
    }

    func emptyVerifiedTransaction() -> AppleIAPVerifiedTransaction {
        return AppleIAPVerifiedTransaction(
            verified: false,
            transaction: emptyTransaction(),
            verification_error: ""
        )
    }

    func emptyTransaction() -> AppleIAPTransaction {
        return AppleIAPTransaction(
            id: "",
            original_id: "",
            web_order_line_item_id: "",
            product_id: "",
            product_type: AppleIAPProductType.Unknown.rawValue,
            subscription_group_id: "",
            purchase_date_ms: 0.0,
            original_purchase_date_ms: 0.0,
            expiration_date_ms: 0.0,
            revocation_date_ms: 0.0,
            signed_date_ms: 0.0,
            revocation_reason: AppleIAPRevocationReason.None.rawValue,
            is_upgraded: false,
            ownership_type: AppleIAPTransactionOwnershipType.Unknown.rawValue,
            environment: AppleIAPTransactionEnvironment.Unknown.rawValue,
            app_account_token: "",
            offer_id: ""
        )
    }

    // MARK: - Product conversion

    func productToRecord(_ product: Product) -> AppleIAPProduct {
        return AppleIAPProduct(
            id: product.id,
            type: productTypeToRawValue(product.type),
            display_name: product.displayName,
            description: product.description,
            display_price: product.displayPrice,
            price: NSDecimalNumber(decimal: product.price).doubleValue,
            currency_code: productCurrencyCode(product)
        )
    }

    func productCurrencyCode(_ product: Product) -> String {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, *) {
            return product.priceFormatStyle.currencyCode
        }
        return ""
    }

    func productTypeToRawValue(_ type: Product.ProductType) -> Int32 {
        switch type {
        case .consumable:
            return AppleIAPProductType.Consumable.rawValue
        case .nonConsumable:
            return AppleIAPProductType.NonConsumable.rawValue
        case .nonRenewable:
            return AppleIAPProductType.NonRenewable.rawValue
        case .autoRenewable:
            return AppleIAPProductType.AutoRenewable.rawValue
        default:
            return AppleIAPProductType.Unknown.rawValue
        }
    }

    // MARK: - Transaction conversion

    func verificationResultToRecord(_ result: VerificationResult<Transaction>) -> AppleIAPVerifiedTransaction {
        switch result {
        case .verified(let transaction):
            return AppleIAPVerifiedTransaction(
                verified: true,
                transaction: transactionToRecord(transaction),
                verification_error: ""
            )

        case .unverified(let transaction, let verificationError):
            return AppleIAPVerifiedTransaction(
                verified: false,
                transaction: transactionToRecord(transaction),
                verification_error: verificationError.localizedDescription
            )
        }
    }

    func transactionToRecord(_ transaction: Transaction) -> AppleIAPTransaction {
        return AppleIAPTransaction(
            id: String(transaction.id),
            original_id: String(transaction.originalID),
            web_order_line_item_id: transaction.webOrderLineItemID.map { String($0) } ?? "",
            product_id: transaction.productID,
            product_type: productTypeToRawValue(transaction.productType),
            subscription_group_id: transaction.subscriptionGroupID ?? "",
            purchase_date_ms: dateToMs(transaction.purchaseDate),
            original_purchase_date_ms: dateToMs(transaction.originalPurchaseDate),
            expiration_date_ms: dateToMs(transaction.expirationDate),
            revocation_date_ms: dateToMs(transaction.revocationDate),
            signed_date_ms: dateToMs(transaction.signedDate),
            revocation_reason: revocationReasonToRawValue(transaction.revocationReason),
            is_upgraded: transaction.isUpgraded,
            ownership_type: ownershipTypeToRawValue(transaction.ownershipType),
            environment: environmentToRawValue(transaction.environment),
            app_account_token: transaction.appAccountToken?.uuidString ?? "",
            offer_id: transaction.offerID ?? ""
        )
    }

    func dateToMs(_ date: Date?) -> Double {
        guard let date else {
            return 0.0
        }
        return date.timeIntervalSince1970 * 1000.0
    }

    func revocationReasonToRawValue(_ reason: Transaction.RevocationReason?) -> Int32 {
        guard let reason else {
            return AppleIAPRevocationReason.None.rawValue
        }

        switch reason {
        case .developerIssue:
            return AppleIAPRevocationReason.DeveloperIssue.rawValue
        case .other:
            return AppleIAPRevocationReason.Other.rawValue
        default:
            return AppleIAPRevocationReason.Unknown.rawValue
        }
    }

    func ownershipTypeToRawValue(_ ownershipType: Transaction.OwnershipType) -> Int32 {
        switch ownershipType {
        case .purchased:
            return AppleIAPTransactionOwnershipType.Purchased.rawValue
        case .familyShared:
            return AppleIAPTransactionOwnershipType.FamilyShared.rawValue
        default:
            return AppleIAPTransactionOwnershipType.Unknown.rawValue
        }
    }

    func environmentToRawValue(_ environment: AppStore.Environment) -> Int32 {
        switch environment {
        case .xcode:
            return AppleIAPTransactionEnvironment.Xcode.rawValue
        case .sandbox:
            return AppleIAPTransactionEnvironment.Sandbox.rawValue
        case .production:
            return AppleIAPTransactionEnvironment.Production.rawValue
        default:
            return AppleIAPTransactionEnvironment.Unknown.rawValue
        }
    }
}
