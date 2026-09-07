
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

public class GMAppleIAPSwift: GMAppleIAPInternalSwift {

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
                    self.invokeCallback(
                        callback,
                        self.transactionResult(
                            success: true,
                            status: AppleIAPTransactionStatus.Success
                        ),
                        self.transactionToRecord(transaction)
                    )
                } catch StoreError.failedVerification {
                    self.invokeCallback(
                        callback,
                        self.transactionResult(
                            success: false,
                            status: AppleIAPTransactionStatus.VerificationFailed,
                            message: StoreError.failedVerification.localizedDescription
                        ),
                        nil
                    )
                } catch {
                    self.invokeCallback(
                        callback,
                        self.transactionResult(
                            success: false,
                            status: AppleIAPTransactionStatus.Error,
                            message: error.localizedDescription
                        ),
                        nil
                    )
                }
            }
        }
        return true
    }

    public override func apple_iap_can_make_payments(callback: GMFunction) -> Bool {
        let canPay = AppStore.canMakePayments
        callback.call(canPay)
        return canPay
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
                        error: self.appleIAPError(from: error),
                        message: error.localizedDescription
                    ),
                    [AppleIAPProduct]()
                )
            }
        }
    }

    public override func apple_iap_product_purchase(
        product_id: String,
        callback: GMFunction,
        app_account_token: String?,
        quantity: Int32?
    ) {
        Task {
            guard let product = await self.productCache.product(for: product_id) else {
                self.invokeCallback(
                    callback,
                    self.purchaseResult(
                        success: false,
                        status: AppleIAPPurchaseStatus.ProductNotFound,
                        message: "Product not found. Call apple_iap_products first."
                    ),
                    nil
                )
                return
            }

            var options = Set<Product.PurchaseOption>()

            if let appAccountToken = app_account_token {
                guard let token = UUID(uuidString: appAccountToken) else {
                    self.invokeCallback(
                        callback,
                        self.purchaseResult(
                            success: false,
                            status: AppleIAPPurchaseStatus.Error,
                            error: AppleIAPError.Unknown,
                            message: "app_account_token must be a valid UUID string."
                        ),
                        nil
                    )
                    return
                }
                options.insert(.appAccountToken(token))
            }

            if let quantity {
                options.insert(.quantity(Int(quantity)))
            }

            do {
                let purchaseResult = try await product.purchase(options: options)
                switch purchaseResult {
                case .success(let verificationResult):
                    let transaction = try self.checkVerified(verificationResult)
                    self.invokeCallback(
                        callback,
                        self.purchaseResult(
                            success: true,
                            status: AppleIAPPurchaseStatus.Success
                        ),
                        self.transactionToRecord(transaction)
                    )
                case .userCancelled:
                    self.invokeCallback(
                        callback,
                        self.purchaseResult(
                            success: false,
                            status: AppleIAPPurchaseStatus.UserCancelled
                        ),
                        nil
                    )
                case .pending:
                    self.invokeCallback(
                        callback,
                        self.purchaseResult(
                            success: false,
                            status: AppleIAPPurchaseStatus.Pending
                        ),
                        nil
                    )
                @unknown default:
                    self.invokeCallback(
                        callback,
                        self.purchaseResult(
                            success: false,
                            status: AppleIAPPurchaseStatus.Unknown,
                            message: "Unknown StoreKit purchase result."
                        ),
                        nil
                    )
                }
            } catch StoreError.failedVerification {
                self.invokeCallback(
                    callback,
                    self.purchaseResult(
                        success: false,
                        status: AppleIAPPurchaseStatus.VerificationFailed,
                        message: StoreError.failedVerification.localizedDescription
                    ),
                    nil
                )
            } catch {
                self.invokeCallback(
                    callback,
                    self.purchaseResult(
                        success: false,
                        status: AppleIAPPurchaseStatus.Error,
                        error: self.appleIAPError(from: error),
                        message: error.localizedDescription
                    ),
                    nil
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
                switch result {
                case .verified(let transaction):
                    guard transaction.id == targetId else {
                        continue
                    }
                    await transaction.finish()
                    callback.call(
                        self.transactionFinishResult(
                            success: true,
                            status: AppleIAPTransactionStatus.Success
                        )
                    )
                    return
                case .unverified(let transaction, let verificationError):
                    guard transaction.id == targetId else {
                        continue
                    }
                    // Identify the matching transaction, but never finish it.
                    callback.call(
                        self.transactionFinishResult(
                            success: false,
                            status: AppleIAPTransactionStatus.VerificationFailed,
                            message: verificationError.localizedDescription
                        )
                    )
                    return
                }
            }
            callback.call(
                self.transactionFinishResult(
                    success: false,
                    status: AppleIAPTransactionStatus.TransactionNotFound,
                    message: "Transaction not found in unfinished transactions."
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
                        self.invokeCallback(
                            callback,
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
                    self.invokeCallback(
                        callback,
                        self.transactionResult(
                            success: true,
                            status: AppleIAPTransactionStatus.Success
                        ),
                        self.transactionToRecord(transaction)
                    )
                    return
                }
                self.invokeCallback(
                    callback,
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.NoCurrentEntitlement,
                        message: "No current entitlement for this product."
                    ),
                    nil
                )
            } catch StoreError.failedVerification {
                self.invokeCallback(
                    callback,
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.VerificationFailed,
                        message: StoreError.failedVerification.localizedDescription
                    ),
                    nil
                )
            } catch {
                self.invokeCallback(
                    callback,
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.Error,
                        message: error.localizedDescription
                    ),
                    nil
                )
            }
        }
    }

    public override func apple_iap_transactions_current_entitlements(callback: GMFunction) {
        Task {
            var transactions: [AppleIAPTransaction] = []
            var verificationFailureCount = 0
            var firstVerificationError = ""

            for await result in Transaction.currentEntitlements {
                switch result {
                case .verified(let transaction):
                    transactions.append(self.transactionToRecord(transaction))
                case .unverified(_, let verificationError):
                    verificationFailureCount += 1
                    if firstVerificationError.isEmpty {
                        firstVerificationError = verificationError.localizedDescription
                    }
                }
            }
            callback.call(
                self.transactionsResultForCollection(
                    verificationFailureCount: verificationFailureCount,
                    firstVerificationError: firstVerificationError
                ),
                transactions
            )
        }
    }

    public override func apple_iap_transactions_latest(product_id: String, callback: GMFunction) {
        Task {
            do {
                guard let result = await Transaction.latest(for: product_id) else {
                    self.invokeCallback(
                        callback,
                        self.transactionResult(
                            success: false,
                            status: AppleIAPTransactionStatus.NoLatestTransaction,
                            message: "No latest transaction for this product."
                        ),
                        nil
                    )
                    return
                }
                let transaction = try self.checkVerified(result)
                self.invokeCallback(
                    callback,
                    self.transactionResult(
                        success: true,
                        status: AppleIAPTransactionStatus.Success
                    ),
                    self.transactionToRecord(transaction)
                )
            } catch StoreError.failedVerification {
                self.invokeCallback(
                    callback,
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.VerificationFailed,
                        message: StoreError.failedVerification.localizedDescription
                    ),
                    nil
                )
            } catch {
                self.invokeCallback(
                    callback,
                    self.transactionResult(
                        success: false,
                        status: AppleIAPTransactionStatus.Error,
                        message: error.localizedDescription
                    ),
                    nil
                )
            }
        }
    }

    public override func apple_iap_transactions_unfinished(callback: GMFunction) {
        Task {
            var transactions: [AppleIAPTransaction] = []
            var verificationFailureCount = 0
            var firstVerificationError = ""

            for await result in Transaction.unfinished {
                switch result {
                case .verified(let transaction):
                    transactions.append(self.transactionToRecord(transaction))
                case .unverified(_, let verificationError):
                    verificationFailureCount += 1
                    if firstVerificationError.isEmpty {
                        firstVerificationError = verificationError.localizedDescription
                    }
                }
            }
            callback.call(
                self.transactionsResultForCollection(
                    verificationFailureCount: verificationFailureCount,
                    firstVerificationError: firstVerificationError
                ),
                transactions
            )
        }
    }

    public override func apple_iap_transactions_all(callback: GMFunction) {
        Task {
            var transactions: [AppleIAPTransaction] = []
            var verificationFailureCount = 0
            var firstVerificationError = ""

            for await result in Transaction.all {
                switch result {
                case .verified(let transaction):
                    transactions.append(self.transactionToRecord(transaction))
                case .unverified(_, let verificationError):
                    verificationFailureCount += 1
                    if firstVerificationError.isEmpty {
                        firstVerificationError = verificationError.localizedDescription
                    }
                }
            }
            callback.call(
                self.transactionsResultForCollection(
                    verificationFailureCount: verificationFailureCount,
                    firstVerificationError: firstVerificationError
                ),
                transactions
            )
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
                        error: self.appleIAPError(from: error),
                        message: error.localizedDescription
                    )
                )
            }
        }
    }
}

private extension GMAppleIAPSwift {

    // MARK: - StoreKit verification / compatibility

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    func appleIAPError(from error: Error) -> AppleIAPError {
        if let purchaseError = error as? Product.PurchaseError {
            switch purchaseError {
            case .productUnavailable:
                return AppleIAPError.ProductUnavailable
            case .purchaseNotAllowed:
                return AppleIAPError.PurchaseNotAllowed
            case .ineligibleForOffer:
                return AppleIAPError.IneligibleForOffer
            case .invalidOfferPrice:
                return AppleIAPError.InvalidOfferPrice
            case .invalidOfferSignature:
                return AppleIAPError.InvalidOfferSignature
            case .invalidOfferIdentifier:
                return AppleIAPError.InvalidOfferIdentifier
            case .invalidQuantity:
                return AppleIAPError.InvalidQuantity
            case .missingOfferParameters:
                return AppleIAPError.MissingOfferParameters
            case .paymentMethodBindingConfigurationRequired:
                return AppleIAPError.PaymentMethodBindingConfigurationRequired
            @unknown default:
                return AppleIAPError.Unknown
            }
        }

        if let storeKitError = error as? StoreKitError {
            switch storeKitError {
            case .networkError(_):
                return AppleIAPError.NetworkError
            case .systemError(_):
                return AppleIAPError.SystemError
            case .userCancelled:
                return AppleIAPError.StoreUserCancelled
            case .notAvailableInStorefront:
                return AppleIAPError.NotAvailableInStorefront
            case .notEntitled:
                return AppleIAPError.NotEntitled
            case .unsupported:
                return AppleIAPError.Unsupported
            case .invalidPresentationContext:
                return AppleIAPError.InvalidPresentationContext
            case .unknown:
                return AppleIAPError.Unknown
            @unknown default:
                return AppleIAPError.Unknown
            }
        }

        return AppleIAPError.Unknown
    }

    @available(iOS, introduced: 15.0, deprecated: 18.4)
    @available(macOS, introduced: 12.0, deprecated: 15.4)
    @available(tvOS, introduced: 15.0, deprecated: 18.4)
    func legacyCurrentEntitlement(for productId: String) async -> VerificationResult<Transaction>? {
        return await Transaction.currentEntitlement(for: productId)
    }

    // MARK: - Typed callback helpers

    /// GMFunction's C++ bridge cannot construct std::optional<T> directly from
    /// Swift. When the optional payload is absent, call the GML function with
    /// only the result argument; the declared second GML parameter is undefined.
    func invokeCallback(
        _ callback: GMFunction,
        _ result: AppleIAPPurchaseResult,
        _ transaction: AppleIAPTransaction?
    ) {
        if let transaction {
            callback.call(result, transaction)
        } else {
            callback.call(result)
        }
    }

    func invokeCallback(
        _ callback: GMFunction,
        _ result: AppleIAPTransactionResult,
        _ transaction: AppleIAPTransaction?
    ) {
        if let transaction {
            callback.call(result, transaction)
        } else {
            callback.call(result)
        }
    }

    func transactionsResultForCollection(
        verificationFailureCount: Int,
        firstVerificationError: String
    ) -> AppleIAPTransactionsResult {
        guard verificationFailureCount > 0 else {
            return transactionsResult(
                success: true,
                status: AppleIAPTransactionStatus.Success
            )
        }

        var message = "\(verificationFailureCount) transaction(s) failed StoreKit verification. Verified transactions are included."
        if !firstVerificationError.isEmpty {
            message += " First verification error: \(firstVerificationError)"
        }

        return transactionsResult(
            success: false,
            status: AppleIAPTransactionStatus.VerificationFailed,
            message: message
        )
    }


    // MARK: - Result helpers

    func productsResult(
        success: Bool,
        status: AppleIAPProductsStatus = AppleIAPProductsStatus.None,
        error: AppleIAPError = AppleIAPError.None,
        message: String = ""
    ) -> AppleIAPProductsResult {
        return AppleIAPProductsResult(
            success: success,
            status: status,
            error: error,
            message: message
        )
    }

    func purchaseResult(
        success: Bool,
        status: AppleIAPPurchaseStatus = AppleIAPPurchaseStatus.None,
        error: AppleIAPError = AppleIAPError.None,
        message: String = ""
    ) -> AppleIAPPurchaseResult {
        return AppleIAPPurchaseResult(
            success: success,
            status: status,
            error: error,
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
        error: AppleIAPError = AppleIAPError.None,
        message: String = ""
    ) -> AppleIAPSyncResult {
        return AppleIAPSyncResult(
            success: success,
            status: status,
            error: error,
            message: message
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
            offer: transactionOfferToRecord(transaction)
        )
    }

    func transactionOfferToRecord(_ transaction: Transaction) -> AppleIAPTransactionOffer? {
        if #available(iOS 17.2, macOS 14.2, tvOS 17.2, *) {
            return transaction.offer.map { self.offerToRecord($0) }
        }
        return nil
    }

    @available(iOS 17.2, macOS 14.2, tvOS 17.2, *)
    func offerToRecord(_ offer: Transaction.Offer) -> AppleIAPTransactionOffer {
        return AppleIAPTransactionOffer(
            id: offer.id,
            type: offerTypeFromStoreKit(offer.type),
            payment_mode: offer.paymentMode.map {
                offerPaymentModeFromStoreKit($0)
            }
        )
    }

    @available(iOS 17.2, macOS 14.2, tvOS 17.2, *)
    func offerTypeFromStoreKit(
        _ type: Transaction.OfferType
    ) -> AppleIAPTransactionOfferType {
        switch type {
        case .introductory:
            return AppleIAPTransactionOfferType.Introductory
        case .promotional:
            return AppleIAPTransactionOfferType.Promotional
        case .code:
            return AppleIAPTransactionOfferType.Code
        case .winBack:
            return AppleIAPTransactionOfferType.WinBack
        default:
            return AppleIAPTransactionOfferType.Unknown
        }
    }

    @available(iOS 17.2, macOS 14.2, tvOS 17.2, *)
    func offerPaymentModeFromStoreKit(
        _ paymentMode: Transaction.Offer.PaymentMode
    ) -> AppleIAPTransactionOfferPaymentMode {
        switch paymentMode {
        case .freeTrial:
            return AppleIAPTransactionOfferPaymentMode.FreeTrial
        case .payAsYouGo:
            return AppleIAPTransactionOfferPaymentMode.PayAsYouGo
        case .payUpFront:
            return AppleIAPTransactionOfferPaymentMode.PayUpFront
        case .oneTime:
            return AppleIAPTransactionOfferPaymentMode.OneTime
        default:
            return AppleIAPTransactionOfferPaymentMode.Unknown
        }
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
