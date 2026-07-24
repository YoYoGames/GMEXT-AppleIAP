import CxxStdlib
import Foundation
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

  // MARK: - Products / purchase

  public override func apple_iap_products(products_id: [String], callback: GMFunction) {
    Task {
      let productIds =
        products_id
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }

      guard !productIds.isEmpty else {
        self.invokeCallback(
          callback,
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

        self.invokeCallback(
          callback,
          self.productsResult(
            success: true,
            status: AppleIAPProductsStatus.Success
          ),
          products.map { self.productToRecord($0) }
        )
      } catch {
        self.invokeCallback(
          callback,
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

      do {
        let purchaseResult = try await product.purchase()

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
              success: true,
              status: AppleIAPPurchaseStatus.UserCancelled
            ),
            nil
          )

        case .pending:
          self.invokeCallback(
            callback,
            self.purchaseResult(
              success: true,
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
        self.invokeCallback(
          callback,
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
          self.invokeCallback(
            callback,
            self.transactionFinishResult(
              success: true,
              status: AppleIAPTransactionStatus.Success
            )
          )
          return
        }
      }

      self.invokeCallback(
        callback,
        self.transactionFinishResult(
          success: false,
          status: AppleIAPTransactionStatus.TransactionNotFound,
          message: "Transaction not found in verified unfinished transactions."
        )
      )
    }
  }

  public override func apple_iap_transactions_current_entitlement(
    product_id: String, callback: GMFunction
  ) {
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
      do {
        var transactions: [AppleIAPTransaction] = []

        for await result in Transaction.currentEntitlements {
          let transaction = try self.checkVerified(result)
          transactions.append(self.transactionToRecord(transaction))
        }

        self.invokeCallback(
          callback,
          self.transactionsResult(
            success: true,
            status: AppleIAPTransactionStatus.Success
          ),
          transactions
        )
      } catch StoreError.failedVerification {
        self.invokeCallback(
          callback,
          self.transactionsResult(
            success: false,
            status: AppleIAPTransactionStatus.VerificationFailed,
            message: StoreError.failedVerification.localizedDescription
          ),
          [AppleIAPTransaction]()
        )
      } catch {
        self.invokeCallback(
          callback,
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
      do {
        var transactions: [AppleIAPTransaction] = []

        for await result in Transaction.unfinished {
          let transaction = try self.checkVerified(result)
          transactions.append(self.transactionToRecord(transaction))
        }

        self.invokeCallback(
          callback,
          self.transactionsResult(
            success: true,
            status: AppleIAPTransactionStatus.Success
          ),
          transactions
        )
      } catch StoreError.failedVerification {
        self.invokeCallback(
          callback,
          self.transactionsResult(
            success: false,
            status: AppleIAPTransactionStatus.VerificationFailed,
            message: StoreError.failedVerification.localizedDescription
          ),
          [AppleIAPTransaction]()
        )
      } catch {
        self.invokeCallback(
          callback,
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

        self.invokeCallback(
          callback,
          self.transactionsResult(
            success: true,
            status: AppleIAPTransactionStatus.Success
          ),
          transactions
        )
      } catch StoreError.failedVerification {
        self.invokeCallback(
          callback,
          self.transactionsResult(
            success: false,
            status: AppleIAPTransactionStatus.VerificationFailed,
            message: StoreError.failedVerification.localizedDescription
          ),
          [AppleIAPTransaction]()
        )
      } catch {
        self.invokeCallback(
          callback,
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
        self.invokeCallback(
          callback,
          self.syncResult(
            success: true,
            status: AppleIAPSyncStatus.Success
          )
        )
      } catch {
        self.invokeCallback(
          callback,
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

extension GMAppleIAPsSwift {

  // MARK: - Typed callback dispatch

  fileprivate func invokeCallback(
    _ callback: GMFunction,
    _ result: AppleIAPProductsResult,
    _ products: [AppleIAPProduct]
  ) {
    callback.call(result, products)
  }

  fileprivate func invokeCallback(
    _ callback: GMFunction,
    _ result: AppleIAPPurchaseResult,
    _ transaction: AppleIAPTransaction?
  ) {
    callback.call(result, transaction)
  }

  fileprivate func invokeCallback(
    _ callback: GMFunction,
    _ result: AppleIAPTransactionFinishResult
  ) {
    callback.call(result)
  }

  fileprivate func invokeCallback(
    _ callback: GMFunction,
    _ result: AppleIAPTransactionResult,
    _ transaction: AppleIAPTransaction?
  ) {
    callback.call(result, transaction)
  }

  fileprivate func invokeCallback(
    _ callback: GMFunction,
    _ result: AppleIAPTransactionsResult,
    _ transactions: [AppleIAPTransaction]
  ) {
    callback.call(result, transactions)
  }

  fileprivate func invokeCallback(
    _ callback: GMFunction,
    _ result: AppleIAPSyncResult
  ) {
    callback.call(result)
  }

  // MARK: - StoreKit verification / compatibility

  fileprivate func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
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
  fileprivate func legacyCurrentEntitlement(for productId: String) async -> VerificationResult<
    Transaction
  >? {
    return await Transaction.currentEntitlement(for: productId)
  }

  // MARK: - Result helpers

  fileprivate func productsResult(
    success: Bool,
    status: AppleIAPProductsStatus = AppleIAPProductsStatus.None,
    message: String = ""
  ) -> AppleIAPProductsResult {
    return AppleIAPProductsResult(
      success: success,
      status: status.rawValue,
      message: message
    )
  }

  fileprivate func purchaseResult(
    success: Bool,
    status: AppleIAPPurchaseStatus = AppleIAPPurchaseStatus.None,
    message: String = ""
  ) -> AppleIAPPurchaseResult {
    return AppleIAPPurchaseResult(
      success: success,
      status: status.rawValue,
      message: message
    )
  }

  fileprivate func transactionFinishResult(
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

  fileprivate func transactionResult(
    success: Bool,
    status: AppleIAPTransactionStatus = AppleIAPTransactionStatus.None,
    message: String = ""
  ) -> AppleIAPTransactionResult {
    return AppleIAPTransactionResult(
      success: success,
      status: status.rawValue,
      message: message
    )
  }

  fileprivate func transactionsResult(
    success: Bool,
    status: AppleIAPTransactionStatus = AppleIAPTransactionStatus.None,
    message: String = ""
  ) -> AppleIAPTransactionsResult {
    return AppleIAPTransactionsResult(
      success: success,
      status: status.rawValue,
      message: message
    )
  }

  fileprivate func syncResult(
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

  // MARK: - Product conversion

  fileprivate func productToRecord(_ product: Product) -> AppleIAPProduct {
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

  fileprivate func productCurrencyCode(_ product: Product) -> String {
    if #available(iOS 16.0, macOS 13.0, tvOS 16.0, *) {
      return product.priceFormatStyle.currencyCode
    }
    return ""
  }

  fileprivate func productTypeToRawValue(_ type: Product.ProductType) -> Int32 {
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

  fileprivate func transactionToRecord(_ transaction: Transaction) -> AppleIAPTransaction {
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

  fileprivate func dateToMs(_ date: Date?) -> Double {
    guard let date else {
      return 0.0
    }
    return date.timeIntervalSince1970 * 1000.0
  }

  fileprivate func revocationReasonToRawValue(_ reason: Transaction.RevocationReason?) -> Int32 {
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

  fileprivate func ownershipTypeToRawValue(_ ownershipType: Transaction.OwnershipType) -> Int32 {
    switch ownershipType {
    case .purchased:
      return AppleIAPTransactionOwnershipType.Purchased.rawValue
    case .familyShared:
      return AppleIAPTransactionOwnershipType.FamilyShared.rawValue
    default:
      return AppleIAPTransactionOwnershipType.Unknown.rawValue
    }
  }

  fileprivate func environmentToRawValue(_ environment: AppStore.Environment) -> Int32 {
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
