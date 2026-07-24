import Foundation
import CxxStdlib
import StoreKit

private enum StoreError: LocalizedError {
    case failedVerification

    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "StoreKit transaction verification failed."
        }
    }
}

private actor ProductCache {
    private var productsById: [String: Product] = [:]

    func replace(_ products: [Product]) {
        productsById = Dictionary(
            uniqueKeysWithValues: products.map { ($0.id, $0) }
        )
    }

    func product(for id: String) -> Product? {
        return productsById[id]
    }
}

public class GMAppleIAPsSwift: GMAppleIAPsInternalSwift {

    private let productCache = ProductCache()
    private var transactionUpdatesTask: Task<Void, Never>?

    public override init() {
        super.init()
    }

    deinit {
        transactionUpdatesTask?.cancel()
    }

    // MARK: - Init / transaction updates

    public override func apple_iap_init(callback: GMFunction) -> Bool {
        transactionUpdatesTask?.cancel()

        transactionUpdatesTask = Task { [weak self] in
            for await result in StoreKit.Transaction.updates {
                if Task.isCancelled {
                    return
                }

                guard let self else {
                    return
                }

                do {
                    let transaction = try self.checkVerified(result)
                    callback.call(
                        self.transactionResult(
                            success: true,
                            status: AppleIAPTransactionStatus.Success
                        ),
                        self.transactionToRecord(transaction)
                    )
                } catch StoreError.failedVerification {
                    callback.call(
                        self.transactionResult(
                            success: false,
                            status: AppleIAPTransactionStatus.VerificationFailed,
                            message: StoreError.failedVerification.localizedDescription
                        ),
                        self.emptyTransaction()
                    )
                } catch {
                    callback.call(
                        self.transactionResult(
                            success: false,
                            status: AppleIAPTransactionStatus.Error,
                            message: error.localizedDescription
                        ),
                        self.emptyTransaction()
                    )
                }
            }
        }

        return true
    }

    // MARK: - Products / purchase

    public override func apple_iap_products(products_id: [String], callback: GMFunction) {
        Task {
            let productIds = products_id
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }

            guard !productIds.isEmpty else {
                callback.call(
                    self.productsResult(
                        success: false,
                        status: AppleIAPProductsStatus.EmptyProductIds,
                        message: "Product id list is empty."
                    ),
                    [AppleIAPProduct]()
                )
                return
            }

            do {
                let products = try await Product.products(for: productIds)
                await self.productCache.replace(products)

                callback.call(
                    self.productsResult(
                        success: true,
                        status: AppleIAPProductsStatus.Success
                    ),
                    products.map { self.productToRecord($0) }
                )
            } catch {
                callback.call(
                    self.productsResult(
                        success: false,
                        status: AppleIAPProductsStatus.Error,
                        message: error.localizedDescription
                    ),
                    [AppleIAPProduct]()
                )
            }
        }
    }

    public override func apple_iap_product_purchase(product_id: String, callback: GMFunction) {
        Task {
            guard let product = await self.productCache.product(for: product_id) else {
                callback.call(
                    self.purchaseResult(
                        success: false,
                        status: AppleIAPPurchaseStatus.ProductNotFound,
                        message: "Product not found. Call apple_iap_products first."
                    ),
                    self.emptyTransaction()
                )
                return
            }

            do {
                let purchaseResult = try await product.purchase()

                switch purchaseResult {
                case .success(let verificationResult):
                    let transaction = try self.checkVerified(verificationResult)
                    callback.call(
                        self.purchaseResult(
                            success: true,
                            status: AppleIAPPurchaseStatus.Success
                        ),
                        self.transactionToRecord(transaction)
                    )

                case .userCancelled:
                    callback.call(
                        self.purchaseResult(
                            success: true,
                            status: AppleIAPPurchaseStatus.UserCancelled
                        ),
                        self.emptyTransaction()
                    )

                case .pending:
                    callback.call(
                        self.purchaseResult(
                            success: true,
                            status: AppleIAPPurchaseStatus.Pending
                        ),
                        self.emptyTransaction()
                    )

                @unknown default:
                    callback.call(
                        self.purchaseResult(
                            success: false,
                            status: AppleIAPPurchaseStatus.Unknown,
                            message: "Unknown StoreKit purchase result."
                        ),
                        self.emptyTransaction()
                    )
                }
            } catch StoreError.failedVerification {
                callback.call(
                    self.purchaseResult(
                        success: false,
                        status: AppleIAPPurchaseStatus.VerificationFailed,
                        message: StoreError.failedVerification.localizedDescription
                    ),
                    self.emptyTransaction()
                )
            } catch {
                callback.call(
                    self.purchaseResult(
                        success: false,
                        status: AppleIAPPurchaseStatus.Error,
                        message: error.localizedDescription
                    ),
                    self.emptyTransaction()
                )
            }
        }
    }

    // MARK: - Transactions

    public override func apple_iap_transaction_finish(transaction_id: String, callback: GMFunction) {
        Task {
            guard let targetId = UInt64(transaction_id) else {
                callback.call(
                    self.transactionFinishResult(
                        success: false,
                        status: AppleIAPTransactionStatus.InvalidTransactionId,
                        message: "Invalid transaction id."
                    )
                )
                return
            }

            for await result in StoreKit.Transaction.unfinished {
                // Never finish an unverified transaction.
                guard case .verified(let transaction) = result else {
                    continue
                }

                if transaction.id == targetId {
                    await transaction.finish()
                    callback.call(
                        self.transactionFinishResult(
                            success: true,
                            status: AppleIAPTransactionStatus.Success
                        )
                    )
                    return
                }
            }

            callback.call(
                self.transactionFinishResult(
                    success: false,
                    status: AppleIAPTransactionStatus.TransactionNotFound,
                    message: "Transaction not found in verified unfinished transactions."
                )
            )
        }
    }

    public override func apple_iap_transactions_current_entitlement(product_id: String, callback: GMFunction) {
        Task {
            do {
                if #available(iOS 18.4, macOS 15.4, tvOS 18.4, *) {
                    for await result in Transaction.currentEntitlements(for: product_id) {
                        let transaction = try self.checkVerified(result)
                        callback.call(
                            self.transactionResult(
                                success: true,
                                status: AppleIAPTransactionStatus.Success
                            ),
                            self.transactionToRecord(transaction)
                        )
                        return
                    }
                } else if let result = await self.legacyCurrentEntitlement(for: product_id) {
                    let transaction = try self.checkVerified(result)
                    callback.call(
                        self.transactionResult(
                            success: true,
                            status: AppleIAPTransactionStatus.Success
                        ),
                        self.transactionToRecord(transaction)
                    )
                    return
                }

                callback.call(
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.NoCurrentEntitlement,
                        message: "No current entitlement for this product."
                    ),
                    self.emptyTransaction()
                )
            } catch StoreError.failedVerification {
                callback.call(
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.VerificationFailed,
                        message: StoreError.failedVerification.localizedDescription
                    ),
                    self.emptyTransaction()
                )
            } catch {
                callback.call(
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.Error,
                        message: error.localizedDescription
                    ),
                    self.emptyTransaction()
                )
            }
        }
    }

    public override func apple_iap_transactions_current_entitlements(callback: GMFunction) {
        Task {
            do {
                var transactions: [AppleIAPTransaction] = []

                for await result in Transaction.currentEntitlements {
                    let transaction = try self.checkVerified(result)
                    transactions.append(self.transactionToRecord(transaction))
                }

                callback.call(
                    self.transactionsResult(
                        success: true,
                        status: AppleIAPTransactionStatus.Success
                    ),
                    transactions
                )
            } catch StoreError.failedVerification {
                callback.call(
                    self.transactionsResult(
                        success: false,
                        status: AppleIAPTransactionStatus.VerificationFailed,
                        message: StoreError.failedVerification.localizedDescription
                    ),
                    [AppleIAPTransaction]()
                )
            } catch {
                callback.call(
                    self.transactionsResult(
                        success: false,
                        status: AppleIAPTransactionStatus.Error,
                        message: error.localizedDescription
                    ),
                    [AppleIAPTransaction]()
                )
            }
        }
    }

    public override func apple_iap_transactions_latest(product_id: String, callback: GMFunction) {
        Task {
            do {
                guard let result = await Transaction.latest(for: product_id) else {
                    callback.call(
                        self.transactionResult(
                            success: false,
                            status: AppleIAPTransactionStatus.NoLatestTransaction,
                            message: "No latest transaction for this product."
                        ),
                        self.emptyTransaction()
                    )
                    return
                }

                let transaction = try self.checkVerified(result)
                callback.call(
                    self.transactionResult(
                        success: true,
                        status: AppleIAPTransactionStatus.Success
                    ),
                    self.transactionToRecord(transaction)
                )
            } catch StoreError.failedVerification {
                callback.call(
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.VerificationFailed,
                        message: StoreError.failedVerification.localizedDescription
                    ),
                    self.emptyTransaction()
                )
            } catch {
                callback.call(
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.Error,
                        message: error.localizedDescription
                    ),
                    self.emptyTransaction()
                )
            }
        }
    }

    public override func apple_iap_transactions_unfinished(callback: GMFunction) {
        Task {
            do {
                var transactions: [AppleIAPTransaction] = []

                for await result in Transaction.unfinished {
                    let transaction = try self.checkVerified(result)
                    transactions.append(self.transactionToRecord(transaction))
                }

                callback.call(
                    self.transactionsResult(
                        success: true,
                        status: AppleIAPTransactionStatus.Success
                    ),
                    transactions
                )
            } catch StoreError.failedVerification {
                callback.call(
                    self.transactionsResult(
                        success: false,
                        status: AppleIAPTransactionStatus.VerificationFailed,
                        message: StoreError.failedVerification.localizedDescription
                    ),
                    [AppleIAPTransaction]()
                )
            } catch {
                callback.call(
                    self.transactionsResult(
                        success: false,
                        status: AppleIAPTransactionStatus.Error,
                        message: error.localizedDescription
                    ),
                    [AppleIAPTransaction]()
                )
            }
        }
    }

    public override func apple_iap_transactions_all(callback: GMFunction) {
        Task {
            do {
                var transactions: [AppleIAPTransaction] = []

                for await result in Transaction.all {
                    let transaction = try self.checkVerified(result)
                    transactions.append(self.transactionToRecord(transaction))
                }

                callback.call(
                    self.transactionsResult(
                        success: true,
                        status: AppleIAPTransactionStatus.Success
                    ),
                    transactions
                )
            } catch StoreError.failedVerification {
                callback.call(
                    self.transactionsResult(
                        success: false,
                        status: AppleIAPTransactionStatus.VerificationFailed,
                        message: StoreError.failedVerification.localizedDescription
                    ),
                    [AppleIAPTransaction]()
                )
            } catch {
                callback.call(
                    self.transactionsResult(
                        success: false,
                        status: AppleIAPTransactionStatus.Error,
                        message: error.localizedDescription
                    ),
                    [AppleIAPTransaction]()
                )
            }
        }
    }

    // MARK: - Synchronization

    public override func apple_iap_synchronize(callback: GMFunction) {
        Task {
            do {
                try await AppStore.sync()
                callback.call(
                    self.syncResult(
                        success: true,
                        status: AppleIAPSyncStatus.Success
                    )
                )
            } catch {
                callback.call(
                    self.syncResult(
                        success: false,
                        status: AppleIAPSyncStatus.Error,
                        message: error.localizedDescription
                    )
                )
            }
        }
    }
}

private extension GMAppleIAPsSwift {

    // MARK: - StoreKit verification / compatibility

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

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
        message: String = ""
    ) -> AppleIAPProductsResult {
        return AppleIAPProductsResult(
            success: success,
            status: status,
            message: message
        )
    }

    func purchaseResult(
        success: Bool,
        status: AppleIAPPurchaseStatus = AppleIAPPurchaseStatus.None,
        message: String = ""
    ) -> AppleIAPPurchaseResult {
        return AppleIAPPurchaseResult(
            success: success,
            status: status,
            message: message
        )
    }

    func transactionFinishResult(
        success: Bool,
        status: AppleIAPTransactionStatus = AppleIAPTransactionStatus.None,
        message: String = ""
    ) -> AppleIAPTransactionFinishResult {
        return AppleIAPTransactionFinishResult(
            success: success,
            status: status,
            message: message
        )
    }

    func transactionResult(
        success: Bool,
        status: AppleIAPTransactionStatus = AppleIAPTransactionStatus.None,
        message: String = ""
    ) -> AppleIAPTransactionResult {
        return AppleIAPTransactionResult(
            success: success,
            status: status,
            message: message
        )
    }

    func transactionsResult(
        success: Bool,
        status: AppleIAPTransactionStatus = AppleIAPTransactionStatus.None,
        message: String = ""
    ) -> AppleIAPTransactionsResult {
        return AppleIAPTransactionsResult(
            success: success,
            status: status,
            message: message
        )
    }

    func syncResult(
        success: Bool,
        status: AppleIAPSyncStatus = AppleIAPSyncStatus.None,
        message: String = ""
    ) -> AppleIAPSyncResult {
        return AppleIAPSyncResult(
            success: success,
            status: status,
            message: message
        )
    }

    func emptyTransaction() -> AppleIAPTransaction {
        return AppleIAPTransaction(
            id: "",
            original_id: "",
            web_order_line_item_id: "",
            product_id: "",
            product_type: AppleIAPProductType.Unknown,
            subscription_group_id: "",
            purchase_date_ms: 0.0,
            original_purchase_date_ms: 0.0,
            expiration_date_ms: 0.0,
            revocation_date_ms: 0.0,
            signed_date_ms: 0.0,
            revocation_reason: AppleIAPRevocationReason.None,
            is_upgraded: false,
            ownership_type: AppleIAPTransactionOwnershipType.Unknown,
            environment: AppleIAPTransactionEnvironment.Unknown,
            app_account_token: "",
            offer_id: ""
        )
    }

    // MARK: - Product conversion

    func productToRecord(_ product: Product) -> AppleIAPProduct {
        return AppleIAPProduct(
            id: product.id,
            type: productTypeFromStoreKit(product.type),
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

    func productTypeFromStoreKit(_ type: Product.ProductType) -> AppleIAPProductType {
        switch type {
        case .consumable:
            return AppleIAPProductType.Consumable
        case .nonConsumable:
            return AppleIAPProductType.NonConsumable
        case .nonRenewable:
            return AppleIAPProductType.NonRenewable
        case .autoRenewable:
            return AppleIAPProductType.AutoRenewable
        default:
            return AppleIAPProductType.Unknown
        }
    }

    // MARK: - Transaction conversion

    func transactionToRecord(_ transaction: Transaction) -> AppleIAPTransaction {
        return AppleIAPTransaction(
            id: String(transaction.id),
            original_id: String(transaction.originalID),
            web_order_line_item_id: transaction.webOrderLineItemID.map { String($0) } ?? "",
            product_id: transaction.productID,
            product_type: productTypeFromStoreKit(transaction.productType),
            subscription_group_id: transaction.subscriptionGroupID ?? "",
            purchase_date_ms: dateToMs(transaction.purchaseDate),
            original_purchase_date_ms: dateToMs(transaction.originalPurchaseDate),
            expiration_date_ms: dateToMs(transaction.expirationDate),
            revocation_date_ms: dateToMs(transaction.revocationDate),
            signed_date_ms: dateToMs(transaction.signedDate),
            revocation_reason: revocationReasonFromStoreKit(transaction.revocationReason),
            is_upgraded: transaction.isUpgraded,
            ownership_type: ownershipTypeFromStoreKit(transaction.ownershipType),
            environment: environmentFromStoreKit(transaction.environment),
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

    func revocationReasonFromStoreKit(_ reason: Transaction.RevocationReason?) -> AppleIAPRevocationReason {
        guard let reason else {
            return AppleIAPRevocationReason.None
        }

        switch reason {
        case .developerIssue:
            return AppleIAPRevocationReason.DeveloperIssue
        case .other:
            return AppleIAPRevocationReason.Other
        default:
            return AppleIAPRevocationReason.Unknown
        }
    }

    func ownershipTypeFromStoreKit(_ ownershipType: Transaction.OwnershipType) -> AppleIAPTransactionOwnershipType {
        switch ownershipType {
        case .purchased:
            return AppleIAPTransactionOwnershipType.Purchased
        case .familyShared:
            return AppleIAPTransactionOwnershipType.FamilyShared
        default:
            return AppleIAPTransactionOwnershipType.Unknown
        }
    }

    func environmentFromStoreKit(_ environment: AppStore.Environment) -> AppleIAPTransactionEnvironment {
        switch environment {
        case .xcode:
            return AppleIAPTransactionEnvironment.Xcode
        case .sandbox:
            return AppleIAPTransactionEnvironment.Sandbox
        case .production:
            return AppleIAPTransactionEnvironment.Production
        default:
            return AppleIAPTransactionEnvironment.Unknown
        }
    }
}