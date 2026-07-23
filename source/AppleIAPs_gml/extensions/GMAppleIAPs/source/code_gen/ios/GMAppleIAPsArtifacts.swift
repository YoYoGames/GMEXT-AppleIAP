public enum AppleIAPProductsStatus: Int32
{
    case None = 0
    case Success = 1
    case EmptyProductIds = 2
    case Error = 3
}

public enum AppleIAPPurchaseStatus: Int32
{
    case None = 0
    case Success = 1
    case UserCancelled = 2
    case Pending = 3
    case ProductNotFound = 4
    case Error = 5
    case Unknown = 6
}

public enum AppleIAPTransactionStatus: Int32
{
    case None = 0
    case Success = 1
    case InvalidTransactionId = 2
    case TransactionNotFound = 3
    case NoCurrentEntitlement = 4
    case NoLatestTransaction = 5
    case Error = 6
}

public enum AppleIAPSyncStatus: Int32
{
    case None = 0
    case Success = 1
    case Error = 2
}

public enum AppleIAPProductType: Int32
{
    case Unknown = 0
    case Consumable = 1
    case NonConsumable = 2
    case NonRenewable = 3
    case AutoRenewable = 4
}

public enum AppleIAPTransactionEnvironment: Int32
{
    case Unknown = 0
    case Xcode = 1
    case Sandbox = 2
    case Production = 3
}

public enum AppleIAPTransactionOwnershipType: Int32
{
    case Unknown = 0
    case Purchased = 1
    case FamilyShared = 2
}

public enum AppleIAPRevocationReason: Int32
{
    case None = 0
    case DeveloperIssue = 1
    case Other = 2
    case Unknown = 3
}

public struct AppleIAPProduct: ITypedStruct
{
    public var id: String
    public var type: Int32
    public var display_name: String
    public var description: String
    public var display_price: String
    public var price: Double
    public var currency_code: String
}

public struct AppleIAPTransaction: ITypedStruct
{
    public var id: String
    public var original_id: String
    public var web_order_line_item_id: String
    public var product_id: String
    public var product_type: Int32
    public var subscription_group_id: String
    public var purchase_date_ms: Double
    public var original_purchase_date_ms: Double
    public var expiration_date_ms: Double
    public var revocation_date_ms: Double
    public var signed_date_ms: Double
    public var revocation_reason: Int32
    public var is_upgraded: Bool
    public var ownership_type: Int32
    public var environment: Int32
    public var app_account_token: String
    public var offer_id: String
}

public struct AppleIAPTransactionFinishResult: ITypedStruct
{
    public var success: Bool
    public var status: Int32
    public var message: String
}

public struct AppleIAPSyncResult: ITypedStruct
{
    public var success: Bool
    public var status: Int32
    public var message: String
}

public struct AppleIAPProductsResult: ITypedStruct
{
    public var success: Bool
    public var status: Int32
    public var message: String
    public var products: [AppleIAPProduct]
}

public struct AppleIAPVerifiedTransaction: ITypedStruct
{
    public var verified: Bool
    public var transaction: AppleIAPTransaction
    public var verification_error: String
}

public struct AppleIAPPurchaseResult: ITypedStruct
{
    public var success: Bool
    public var status: Int32
    public var message: String
    public var transaction: AppleIAPVerifiedTransaction
}

public struct AppleIAPTransactionResult: ITypedStruct
{
    public var success: Bool
    public var status: Int32
    public var message: String
    public var transaction: AppleIAPVerifiedTransaction
}

public struct AppleIAPTransactionsResult: ITypedStruct
{
    public var success: Bool
    public var status: Int32
    public var message: String
    public var transactions: [AppleIAPVerifiedTransaction]
}

extension AppleIAPProduct
{
    public static let codecID: UInt32 = 0

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.id = try r.readRaw(String.self)
        self.type = try r.readRaw(Int32.self)
        self.display_name = try r.readRaw(String.self)
        self.description = try r.readRaw(String.self)
        self.display_price = try r.readRaw(String.self)
        self.price = try r.readRaw(Double.self)
        self.currency_code = try r.readRaw(String.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.id)
        try w.writeRaw(self.type)
        try w.writeRaw(self.display_name)
        try w.writeRaw(self.description)
        try w.writeRaw(self.display_price)
        try w.writeRaw(self.price)
        try w.writeRaw(self.currency_code)
    }
}

extension AppleIAPTransaction
{
    public static let codecID: UInt32 = 1

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.id = try r.readRaw(String.self)
        self.original_id = try r.readRaw(String.self)
        self.web_order_line_item_id = try r.readRaw(String.self)
        self.product_id = try r.readRaw(String.self)
        self.product_type = try r.readRaw(Int32.self)
        self.subscription_group_id = try r.readRaw(String.self)
        self.purchase_date_ms = try r.readRaw(Double.self)
        self.original_purchase_date_ms = try r.readRaw(Double.self)
        self.expiration_date_ms = try r.readRaw(Double.self)
        self.revocation_date_ms = try r.readRaw(Double.self)
        self.signed_date_ms = try r.readRaw(Double.self)
        self.revocation_reason = try r.readRaw(Int32.self)
        self.is_upgraded = try r.readRaw(Bool.self)
        self.ownership_type = try r.readRaw(Int32.self)
        self.environment = try r.readRaw(Int32.self)
        self.app_account_token = try r.readRaw(String.self)
        self.offer_id = try r.readRaw(String.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.id)
        try w.writeRaw(self.original_id)
        try w.writeRaw(self.web_order_line_item_id)
        try w.writeRaw(self.product_id)
        try w.writeRaw(self.product_type)
        try w.writeRaw(self.subscription_group_id)
        try w.writeRaw(self.purchase_date_ms)
        try w.writeRaw(self.original_purchase_date_ms)
        try w.writeRaw(self.expiration_date_ms)
        try w.writeRaw(self.revocation_date_ms)
        try w.writeRaw(self.signed_date_ms)
        try w.writeRaw(self.revocation_reason)
        try w.writeRaw(self.is_upgraded)
        try w.writeRaw(self.ownership_type)
        try w.writeRaw(self.environment)
        try w.writeRaw(self.app_account_token)
        try w.writeRaw(self.offer_id)
    }
}

extension AppleIAPTransactionFinishResult
{
    public static let codecID: UInt32 = 2

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.success = try r.readRaw(Bool.self)
        self.status = try r.readRaw(Int32.self)
        self.message = try r.readRaw(String.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.success)
        try w.writeRaw(self.status)
        try w.writeRaw(self.message)
    }
}

extension AppleIAPSyncResult
{
    public static let codecID: UInt32 = 3

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.success = try r.readRaw(Bool.self)
        self.status = try r.readRaw(Int32.self)
        self.message = try r.readRaw(String.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.success)
        try w.writeRaw(self.status)
        try w.writeRaw(self.message)
    }
}

extension AppleIAPProductsResult
{
    public static let codecID: UInt32 = 4

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.success = try r.readRaw(Bool.self)
        self.status = try r.readRaw(Int32.self)
        self.message = try r.readRaw(String.self)
        self.products = try r.readRaw([AppleIAPProduct].self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.success)
        try w.writeRaw(self.status)
        try w.writeRaw(self.message)
        try w.writeRawList(self.products)
    }
}

extension AppleIAPVerifiedTransaction
{
    public static let codecID: UInt32 = 5

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.verified = try r.readRaw(Bool.self)
        self.transaction = try r.readRaw(AppleIAPTransaction.self)
        self.verification_error = try r.readRaw(String.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.verified)
        try w.writeRaw(self.transaction)
        try w.writeRaw(self.verification_error)
    }
}

extension AppleIAPPurchaseResult
{
    public static let codecID: UInt32 = 6

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.success = try r.readRaw(Bool.self)
        self.status = try r.readRaw(Int32.self)
        self.message = try r.readRaw(String.self)
        self.transaction = try r.readRaw(AppleIAPVerifiedTransaction.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.success)
        try w.writeRaw(self.status)
        try w.writeRaw(self.message)
        try w.writeRaw(self.transaction)
    }
}

extension AppleIAPTransactionResult
{
    public static let codecID: UInt32 = 7

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.success = try r.readRaw(Bool.self)
        self.status = try r.readRaw(Int32.self)
        self.message = try r.readRaw(String.self)
        self.transaction = try r.readRaw(AppleIAPVerifiedTransaction.self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.success)
        try w.writeRaw(self.status)
        try w.writeRaw(self.message)
        try w.writeRaw(self.transaction)
    }
}

extension AppleIAPTransactionsResult
{
    public static let codecID: UInt32 = 8

    public init<R: IByteReader>(_ r: inout R) throws
    {
        self.success = try r.readRaw(Bool.self)
        self.status = try r.readRaw(Int32.self)
        self.message = try r.readRaw(String.self)
        self.transactions = try r.readRaw([AppleIAPVerifiedTransaction].self)
    }

    public func encode<W: IByteWriter>(_ w: inout W) throws
    {
        try w.writeRaw(self.success)
        try w.writeRaw(self.status)
        try w.writeRaw(self.message)
        try w.writeRawList(self.transactions)
    }
}

