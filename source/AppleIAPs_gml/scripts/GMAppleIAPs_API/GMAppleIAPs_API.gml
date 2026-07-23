// ##### extgen :: Auto-generated file do not edit!! #####

// #####################################################################
// # Macros
// #####################################################################

// #####################################################################
// # Enums
// #####################################################################

enum AppleIAPProductsStatus
{
    None = 0,
    Success = 1,
    EmptyProductIds = 2,
    Error = 3
}

enum AppleIAPPurchaseStatus
{
    None = 0,
    Success = 1,
    UserCancelled = 2,
    Pending = 3,
    ProductNotFound = 4,
    Error = 5,
    Unknown = 6
}

enum AppleIAPTransactionStatus
{
    None = 0,
    Success = 1,
    InvalidTransactionId = 2,
    TransactionNotFound = 3,
    NoCurrentEntitlement = 4,
    NoLatestTransaction = 5,
    Error = 6
}

enum AppleIAPSyncStatus
{
    None = 0,
    Success = 1,
    Error = 2
}

enum AppleIAPProductType
{
    Unknown = 0,
    Consumable = 1,
    NonConsumable = 2,
    NonRenewable = 3,
    AutoRenewable = 4
}

enum AppleIAPTransactionEnvironment
{
    Unknown = 0,
    Xcode = 1,
    Sandbox = 2,
    Production = 3
}

enum AppleIAPTransactionOwnershipType
{
    Unknown = 0,
    Purchased = 1,
    FamilyShared = 2
}

enum AppleIAPRevocationReason
{
    None = 0,
    DeveloperIssue = 1,
    Other = 2,
    Unknown = 3
}

// #####################################################################
// # Constructors
// #####################################################################

/**
 * @returns {Struct.AppleIAPProduct}
 */
function AppleIAPProduct() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 2816369826;

    self.id = undefined;
    self.type = undefined;
    self.display_name = undefined;
    self.description = undefined;
    self.display_price = undefined;
    self.price = undefined;
    self.currency_code = undefined;

}

/**
 * @returns {Struct.AppleIAPTransaction}
 */
function AppleIAPTransaction() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 1635556429;

    self.id = undefined;
    self.original_id = undefined;
    self.web_order_line_item_id = undefined;
    self.product_id = undefined;
    self.product_type = undefined;
    self.subscription_group_id = undefined;
    self.purchase_date_ms = undefined;
    self.original_purchase_date_ms = undefined;
    self.expiration_date_ms = undefined;
    self.revocation_date_ms = undefined;
    self.signed_date_ms = undefined;
    self.revocation_reason = undefined;
    self.is_upgraded = undefined;
    self.ownership_type = undefined;
    self.environment = undefined;
    self.app_account_token = undefined;
    self.offer_id = undefined;

}

/**
 * @returns {Struct.AppleIAPTransactionFinishResult}
 */
function AppleIAPTransactionFinishResult() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 1637047651;

    self.success = undefined;
    self.status = undefined;
    self.message = undefined;

}

/**
 * @returns {Struct.AppleIAPSyncResult}
 */
function AppleIAPSyncResult() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 1681862245;

    self.success = undefined;
    self.status = undefined;
    self.message = undefined;

}

/**
 * @returns {Struct.AppleIAPProductsResult}
 */
function AppleIAPProductsResult() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 717383690;

    self.success = undefined;
    self.status = undefined;
    self.message = undefined;
    self.products = undefined;

}

/**
 * @returns {Struct.AppleIAPVerifiedTransaction}
 */
function AppleIAPVerifiedTransaction() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 3715803513;

    self.verified = undefined;
    self.transaction = undefined;
    self.verification_error = undefined;

}

/**
 * @returns {Struct.AppleIAPPurchaseResult}
 */
function AppleIAPPurchaseResult() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 2439673653;

    self.success = undefined;
    self.status = undefined;
    self.message = undefined;
    self.transaction = undefined;

}

/**
 * @returns {Struct.AppleIAPTransactionResult}
 */
function AppleIAPTransactionResult() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 3955262172;

    self.success = undefined;
    self.status = undefined;
    self.message = undefined;
    self.transaction = undefined;

}

/**
 * @returns {Struct.AppleIAPTransactionsResult}
 */
function AppleIAPTransactionsResult() constructor
{
    /**
     * Internally generated hash for quick validation
     * @ignore
     */
    static __uid = 462979779;

    self.success = undefined;
    self.status = undefined;
    self.message = undefined;
    self.transactions = undefined;

}

// #####################################################################
// # Codecs
// #####################################################################

/**
 * @func __AppleIAPProduct_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.AppleIAPProduct} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __AppleIAPProduct_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: id, type: String
        if (!is_string(self.id)) show_error($"{_where} :: self.id expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.id));
        buffer_write(_buffer, buffer_string, self.id);

        // field: type, type: Int32
        if (!is_numeric(self.type)) show_error($"{_where} :: self.type expected number", true);
        buffer_write(_buffer, buffer_s32, self.type);

        // field: display_name, type: String
        if (!is_string(self.display_name)) show_error($"{_where} :: self.display_name expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.display_name));
        buffer_write(_buffer, buffer_string, self.display_name);

        // field: description, type: String
        if (!is_string(self.description)) show_error($"{_where} :: self.description expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.description));
        buffer_write(_buffer, buffer_string, self.description);

        // field: display_price, type: String
        if (!is_string(self.display_price)) show_error($"{_where} :: self.display_price expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.display_price));
        buffer_write(_buffer, buffer_string, self.display_price);

        // field: price, type: Float64
        if (!is_numeric(self.price)) show_error($"{_where} :: self.price expected number", true);
        buffer_write(_buffer, buffer_f64, self.price);

        // field: currency_code, type: String
        if (!is_string(self.currency_code)) show_error($"{_where} :: self.currency_code expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.currency_code));
        buffer_write(_buffer, buffer_string, self.currency_code);

    }
}

/**
 * @func __AppleIAPProduct_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.AppleIAPProduct}
 * @ignore
 */
function __AppleIAPProduct_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new AppleIAPProduct();
    with (_inst)
    {
        // field: id, type: String
        buffer_read(_buffer, buffer_u32);
        self.id = buffer_read(_buffer, buffer_string);

        // field: type, type: Int32
        self.type = buffer_read(_buffer, buffer_s32);

        // field: display_name, type: String
        buffer_read(_buffer, buffer_u32);
        self.display_name = buffer_read(_buffer, buffer_string);

        // field: description, type: String
        buffer_read(_buffer, buffer_u32);
        self.description = buffer_read(_buffer, buffer_string);

        // field: display_price, type: String
        buffer_read(_buffer, buffer_u32);
        self.display_price = buffer_read(_buffer, buffer_string);

        // field: price, type: Float64
        self.price = buffer_read(_buffer, buffer_f64);

        // field: currency_code, type: String
        buffer_read(_buffer, buffer_u32);
        self.currency_code = buffer_read(_buffer, buffer_string);

    }

    return _inst;
}

/**
 * @func __AppleIAPTransaction_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.AppleIAPTransaction} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __AppleIAPTransaction_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: id, type: String
        if (!is_string(self.id)) show_error($"{_where} :: self.id expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.id));
        buffer_write(_buffer, buffer_string, self.id);

        // field: original_id, type: String
        if (!is_string(self.original_id)) show_error($"{_where} :: self.original_id expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.original_id));
        buffer_write(_buffer, buffer_string, self.original_id);

        // field: web_order_line_item_id, type: String
        if (!is_string(self.web_order_line_item_id)) show_error($"{_where} :: self.web_order_line_item_id expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.web_order_line_item_id));
        buffer_write(_buffer, buffer_string, self.web_order_line_item_id);

        // field: product_id, type: String
        if (!is_string(self.product_id)) show_error($"{_where} :: self.product_id expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.product_id));
        buffer_write(_buffer, buffer_string, self.product_id);

        // field: product_type, type: Int32
        if (!is_numeric(self.product_type)) show_error($"{_where} :: self.product_type expected number", true);
        buffer_write(_buffer, buffer_s32, self.product_type);

        // field: subscription_group_id, type: String
        if (!is_string(self.subscription_group_id)) show_error($"{_where} :: self.subscription_group_id expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.subscription_group_id));
        buffer_write(_buffer, buffer_string, self.subscription_group_id);

        // field: purchase_date_ms, type: Float64
        if (!is_numeric(self.purchase_date_ms)) show_error($"{_where} :: self.purchase_date_ms expected number", true);
        buffer_write(_buffer, buffer_f64, self.purchase_date_ms);

        // field: original_purchase_date_ms, type: Float64
        if (!is_numeric(self.original_purchase_date_ms)) show_error($"{_where} :: self.original_purchase_date_ms expected number", true);
        buffer_write(_buffer, buffer_f64, self.original_purchase_date_ms);

        // field: expiration_date_ms, type: Float64
        if (!is_numeric(self.expiration_date_ms)) show_error($"{_where} :: self.expiration_date_ms expected number", true);
        buffer_write(_buffer, buffer_f64, self.expiration_date_ms);

        // field: revocation_date_ms, type: Float64
        if (!is_numeric(self.revocation_date_ms)) show_error($"{_where} :: self.revocation_date_ms expected number", true);
        buffer_write(_buffer, buffer_f64, self.revocation_date_ms);

        // field: signed_date_ms, type: Float64
        if (!is_numeric(self.signed_date_ms)) show_error($"{_where} :: self.signed_date_ms expected number", true);
        buffer_write(_buffer, buffer_f64, self.signed_date_ms);

        // field: revocation_reason, type: Int32
        if (!is_numeric(self.revocation_reason)) show_error($"{_where} :: self.revocation_reason expected number", true);
        buffer_write(_buffer, buffer_s32, self.revocation_reason);

        // field: is_upgraded, type: Bool
        if (!is_bool(self.is_upgraded)) show_error($"{_where} :: self.is_upgraded expected bool", true);
        buffer_write(_buffer, buffer_bool, self.is_upgraded);

        // field: ownership_type, type: Int32
        if (!is_numeric(self.ownership_type)) show_error($"{_where} :: self.ownership_type expected number", true);
        buffer_write(_buffer, buffer_s32, self.ownership_type);

        // field: environment, type: Int32
        if (!is_numeric(self.environment)) show_error($"{_where} :: self.environment expected number", true);
        buffer_write(_buffer, buffer_s32, self.environment);

        // field: app_account_token, type: String
        if (!is_string(self.app_account_token)) show_error($"{_where} :: self.app_account_token expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.app_account_token));
        buffer_write(_buffer, buffer_string, self.app_account_token);

        // field: offer_id, type: String
        if (!is_string(self.offer_id)) show_error($"{_where} :: self.offer_id expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.offer_id));
        buffer_write(_buffer, buffer_string, self.offer_id);

    }
}

/**
 * @func __AppleIAPTransaction_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.AppleIAPTransaction}
 * @ignore
 */
function __AppleIAPTransaction_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new AppleIAPTransaction();
    with (_inst)
    {
        // field: id, type: String
        buffer_read(_buffer, buffer_u32);
        self.id = buffer_read(_buffer, buffer_string);

        // field: original_id, type: String
        buffer_read(_buffer, buffer_u32);
        self.original_id = buffer_read(_buffer, buffer_string);

        // field: web_order_line_item_id, type: String
        buffer_read(_buffer, buffer_u32);
        self.web_order_line_item_id = buffer_read(_buffer, buffer_string);

        // field: product_id, type: String
        buffer_read(_buffer, buffer_u32);
        self.product_id = buffer_read(_buffer, buffer_string);

        // field: product_type, type: Int32
        self.product_type = buffer_read(_buffer, buffer_s32);

        // field: subscription_group_id, type: String
        buffer_read(_buffer, buffer_u32);
        self.subscription_group_id = buffer_read(_buffer, buffer_string);

        // field: purchase_date_ms, type: Float64
        self.purchase_date_ms = buffer_read(_buffer, buffer_f64);

        // field: original_purchase_date_ms, type: Float64
        self.original_purchase_date_ms = buffer_read(_buffer, buffer_f64);

        // field: expiration_date_ms, type: Float64
        self.expiration_date_ms = buffer_read(_buffer, buffer_f64);

        // field: revocation_date_ms, type: Float64
        self.revocation_date_ms = buffer_read(_buffer, buffer_f64);

        // field: signed_date_ms, type: Float64
        self.signed_date_ms = buffer_read(_buffer, buffer_f64);

        // field: revocation_reason, type: Int32
        self.revocation_reason = buffer_read(_buffer, buffer_s32);

        // field: is_upgraded, type: Bool
        self.is_upgraded = buffer_read(_buffer, buffer_bool);

        // field: ownership_type, type: Int32
        self.ownership_type = buffer_read(_buffer, buffer_s32);

        // field: environment, type: Int32
        self.environment = buffer_read(_buffer, buffer_s32);

        // field: app_account_token, type: String
        buffer_read(_buffer, buffer_u32);
        self.app_account_token = buffer_read(_buffer, buffer_string);

        // field: offer_id, type: String
        buffer_read(_buffer, buffer_u32);
        self.offer_id = buffer_read(_buffer, buffer_string);

    }

    return _inst;
}

/**
 * @func __AppleIAPTransactionFinishResult_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.AppleIAPTransactionFinishResult} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __AppleIAPTransactionFinishResult_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: success, type: Bool
        if (!is_bool(self.success)) show_error($"{_where} :: self.success expected bool", true);
        buffer_write(_buffer, buffer_bool, self.success);

        // field: status, type: Int32
        if (!is_numeric(self.status)) show_error($"{_where} :: self.status expected number", true);
        buffer_write(_buffer, buffer_s32, self.status);

        // field: message, type: String
        if (!is_string(self.message)) show_error($"{_where} :: self.message expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.message));
        buffer_write(_buffer, buffer_string, self.message);

    }
}

/**
 * @func __AppleIAPTransactionFinishResult_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.AppleIAPTransactionFinishResult}
 * @ignore
 */
function __AppleIAPTransactionFinishResult_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new AppleIAPTransactionFinishResult();
    with (_inst)
    {
        // field: success, type: Bool
        self.success = buffer_read(_buffer, buffer_bool);

        // field: status, type: Int32
        self.status = buffer_read(_buffer, buffer_s32);

        // field: message, type: String
        buffer_read(_buffer, buffer_u32);
        self.message = buffer_read(_buffer, buffer_string);

    }

    return _inst;
}

/**
 * @func __AppleIAPSyncResult_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.AppleIAPSyncResult} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __AppleIAPSyncResult_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: success, type: Bool
        if (!is_bool(self.success)) show_error($"{_where} :: self.success expected bool", true);
        buffer_write(_buffer, buffer_bool, self.success);

        // field: status, type: Int32
        if (!is_numeric(self.status)) show_error($"{_where} :: self.status expected number", true);
        buffer_write(_buffer, buffer_s32, self.status);

        // field: message, type: String
        if (!is_string(self.message)) show_error($"{_where} :: self.message expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.message));
        buffer_write(_buffer, buffer_string, self.message);

    }
}

/**
 * @func __AppleIAPSyncResult_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.AppleIAPSyncResult}
 * @ignore
 */
function __AppleIAPSyncResult_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new AppleIAPSyncResult();
    with (_inst)
    {
        // field: success, type: Bool
        self.success = buffer_read(_buffer, buffer_bool);

        // field: status, type: Int32
        self.status = buffer_read(_buffer, buffer_s32);

        // field: message, type: String
        buffer_read(_buffer, buffer_u32);
        self.message = buffer_read(_buffer, buffer_string);

    }

    return _inst;
}

/**
 * @func __AppleIAPProductsResult_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.AppleIAPProductsResult} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __AppleIAPProductsResult_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: success, type: Bool
        if (!is_bool(self.success)) show_error($"{_where} :: self.success expected bool", true);
        buffer_write(_buffer, buffer_bool, self.success);

        // field: status, type: Int32
        if (!is_numeric(self.status)) show_error($"{_where} :: self.status expected number", true);
        buffer_write(_buffer, buffer_s32, self.status);

        // field: message, type: String
        if (!is_string(self.message)) show_error($"{_where} :: self.message expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.message));
        buffer_write(_buffer, buffer_string, self.message);

        // field: products, type: struct AppleIAPProduct[]
        if (!is_array(self.products)) show_error($"{_where} :: self.products expected array", true);
        var __length__ = array_length(self.products);
        buffer_write(_buffer, buffer_u32, __length__);
        for (var _i = 0; _i < __length__; ++_i)
        {
            if (self.products[_i].__uid != 2816369826) show_error($"{_where} :: self.products[_i] expected AppleIAPProduct", true);
            __AppleIAPProduct_encode(self.products[_i], _buffer, buffer_tell(_buffer), _where);
        }

    }
}

/**
 * @func __AppleIAPProductsResult_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.AppleIAPProductsResult}
 * @ignore
 */
function __AppleIAPProductsResult_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new AppleIAPProductsResult();
    with (_inst)
    {
        // field: success, type: Bool
        self.success = buffer_read(_buffer, buffer_bool);

        // field: status, type: Int32
        self.status = buffer_read(_buffer, buffer_s32);

        // field: message, type: String
        buffer_read(_buffer, buffer_u32);
        self.message = buffer_read(_buffer, buffer_string);

        // field: products, type: struct AppleIAPProduct[]
        var __length__ = buffer_read(_buffer, buffer_u32);
        self.products = array_create(__length__);
        for (var _i = 0; _i < __length__; ++_i)
        {
            self.products[_i] = __AppleIAPProduct_decode(_buffer, buffer_tell(_buffer));
        }

    }

    return _inst;
}

/**
 * @func __AppleIAPVerifiedTransaction_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.AppleIAPVerifiedTransaction} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __AppleIAPVerifiedTransaction_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: verified, type: Bool
        if (!is_bool(self.verified)) show_error($"{_where} :: self.verified expected bool", true);
        buffer_write(_buffer, buffer_bool, self.verified);

        // field: transaction, type: struct AppleIAPTransaction
        if (self.transaction.__uid != 1635556429) show_error($"{_where} :: self.transaction expected AppleIAPTransaction", true);
        __AppleIAPTransaction_encode(self.transaction, _buffer, buffer_tell(_buffer), _where);

        // field: verification_error, type: String
        if (!is_string(self.verification_error)) show_error($"{_where} :: self.verification_error expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.verification_error));
        buffer_write(_buffer, buffer_string, self.verification_error);

    }
}

/**
 * @func __AppleIAPVerifiedTransaction_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.AppleIAPVerifiedTransaction}
 * @ignore
 */
function __AppleIAPVerifiedTransaction_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new AppleIAPVerifiedTransaction();
    with (_inst)
    {
        // field: verified, type: Bool
        self.verified = buffer_read(_buffer, buffer_bool);

        // field: transaction, type: struct AppleIAPTransaction
        self.transaction = __AppleIAPTransaction_decode(_buffer, buffer_tell(_buffer));

        // field: verification_error, type: String
        buffer_read(_buffer, buffer_u32);
        self.verification_error = buffer_read(_buffer, buffer_string);

    }

    return _inst;
}

/**
 * @func __AppleIAPPurchaseResult_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.AppleIAPPurchaseResult} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __AppleIAPPurchaseResult_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: success, type: Bool
        if (!is_bool(self.success)) show_error($"{_where} :: self.success expected bool", true);
        buffer_write(_buffer, buffer_bool, self.success);

        // field: status, type: Int32
        if (!is_numeric(self.status)) show_error($"{_where} :: self.status expected number", true);
        buffer_write(_buffer, buffer_s32, self.status);

        // field: message, type: String
        if (!is_string(self.message)) show_error($"{_where} :: self.message expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.message));
        buffer_write(_buffer, buffer_string, self.message);

        // field: transaction, type: struct AppleIAPVerifiedTransaction
        if (self.transaction.__uid != 3715803513) show_error($"{_where} :: self.transaction expected AppleIAPVerifiedTransaction", true);
        __AppleIAPVerifiedTransaction_encode(self.transaction, _buffer, buffer_tell(_buffer), _where);

    }
}

/**
 * @func __AppleIAPPurchaseResult_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.AppleIAPPurchaseResult}
 * @ignore
 */
function __AppleIAPPurchaseResult_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new AppleIAPPurchaseResult();
    with (_inst)
    {
        // field: success, type: Bool
        self.success = buffer_read(_buffer, buffer_bool);

        // field: status, type: Int32
        self.status = buffer_read(_buffer, buffer_s32);

        // field: message, type: String
        buffer_read(_buffer, buffer_u32);
        self.message = buffer_read(_buffer, buffer_string);

        // field: transaction, type: struct AppleIAPVerifiedTransaction
        self.transaction = __AppleIAPVerifiedTransaction_decode(_buffer, buffer_tell(_buffer));

    }

    return _inst;
}

/**
 * @func __AppleIAPTransactionResult_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.AppleIAPTransactionResult} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __AppleIAPTransactionResult_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: success, type: Bool
        if (!is_bool(self.success)) show_error($"{_where} :: self.success expected bool", true);
        buffer_write(_buffer, buffer_bool, self.success);

        // field: status, type: Int32
        if (!is_numeric(self.status)) show_error($"{_where} :: self.status expected number", true);
        buffer_write(_buffer, buffer_s32, self.status);

        // field: message, type: String
        if (!is_string(self.message)) show_error($"{_where} :: self.message expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.message));
        buffer_write(_buffer, buffer_string, self.message);

        // field: transaction, type: struct AppleIAPVerifiedTransaction
        if (self.transaction.__uid != 3715803513) show_error($"{_where} :: self.transaction expected AppleIAPVerifiedTransaction", true);
        __AppleIAPVerifiedTransaction_encode(self.transaction, _buffer, buffer_tell(_buffer), _where);

    }
}

/**
 * @func __AppleIAPTransactionResult_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.AppleIAPTransactionResult}
 * @ignore
 */
function __AppleIAPTransactionResult_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new AppleIAPTransactionResult();
    with (_inst)
    {
        // field: success, type: Bool
        self.success = buffer_read(_buffer, buffer_bool);

        // field: status, type: Int32
        self.status = buffer_read(_buffer, buffer_s32);

        // field: message, type: String
        buffer_read(_buffer, buffer_u32);
        self.message = buffer_read(_buffer, buffer_string);

        // field: transaction, type: struct AppleIAPVerifiedTransaction
        self.transaction = __AppleIAPVerifiedTransaction_decode(_buffer, buffer_tell(_buffer));

    }

    return _inst;
}

/**
 * @func __AppleIAPTransactionsResult_encode(_inst, _buffer, _offset, _where)
 * @param {Struct.AppleIAPTransactionsResult} _inst
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @param {String} _where
 * @ignore
 */
function __AppleIAPTransactionsResult_encode(_inst, _buffer, _offset, _where = _GMFUNCTION_)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);
    with (_inst)
    {
        // field: success, type: Bool
        if (!is_bool(self.success)) show_error($"{_where} :: self.success expected bool", true);
        buffer_write(_buffer, buffer_bool, self.success);

        // field: status, type: Int32
        if (!is_numeric(self.status)) show_error($"{_where} :: self.status expected number", true);
        buffer_write(_buffer, buffer_s32, self.status);

        // field: message, type: String
        if (!is_string(self.message)) show_error($"{_where} :: self.message expected string", true);
        buffer_write(_buffer, buffer_u32, string_byte_length(self.message));
        buffer_write(_buffer, buffer_string, self.message);

        // field: transactions, type: struct AppleIAPVerifiedTransaction[]
        if (!is_array(self.transactions)) show_error($"{_where} :: self.transactions expected array", true);
        var __length__ = array_length(self.transactions);
        buffer_write(_buffer, buffer_u32, __length__);
        for (var _i = 0; _i < __length__; ++_i)
        {
            if (self.transactions[_i].__uid != 3715803513) show_error($"{_where} :: self.transactions[_i] expected AppleIAPVerifiedTransaction", true);
            __AppleIAPVerifiedTransaction_encode(self.transactions[_i], _buffer, buffer_tell(_buffer), _where);
        }

    }
}

/**
 * @func __AppleIAPTransactionsResult_decode(_buffer, _offset)
 * @param {Id.Buffer} _buffer
 * @param {Real} _offset
 * @returns {Struct.AppleIAPTransactionsResult}
 * @ignore
 */
function __AppleIAPTransactionsResult_decode(_buffer, _offset)
{
    buffer_seek(_buffer, buffer_seek_start, _offset);

    _inst = new AppleIAPTransactionsResult();
    with (_inst)
    {
        // field: success, type: Bool
        self.success = buffer_read(_buffer, buffer_bool);

        // field: status, type: Int32
        self.status = buffer_read(_buffer, buffer_s32);

        // field: message, type: String
        buffer_read(_buffer, buffer_u32);
        self.message = buffer_read(_buffer, buffer_string);

        // field: transactions, type: struct AppleIAPVerifiedTransaction[]
        var __length__ = buffer_read(_buffer, buffer_u32);
        self.transactions = array_create(__length__);
        for (var _i = 0; _i < __length__; ++_i)
        {
            self.transactions[_i] = __AppleIAPVerifiedTransaction_decode(_buffer, buffer_tell(_buffer));
        }

    }

    return _inst;
}

// #####################################################################
// # Functions
// #####################################################################

// Skipping function apple_iap_init (no wrapper is required)


/**
 * @param {Array[String]} _products_id
 * @param {Function} _callback
 */
function apple_iap_products(_products_id, _callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _products_id, type: String[]
    if (!is_array(_products_id)) show_error($"{_GMFUNCTION_} :: _products_id expected array", true);
    var __length__ = array_length(_products_id);
    buffer_write(__args_buffer, buffer_u32, __length__);
    for (var _i = 0; _i < __length__; ++_i)
    {
        if (!is_string(_products_id[_i])) show_error($"{_GMFUNCTION_} :: _products_id[_i] expected string", true);
        buffer_write(__args_buffer, buffer_u32, string_byte_length(_products_id[_i]));
        buffer_write(__args_buffer, buffer_string, _products_id[_i]);
    }

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_products(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {String} _product_id
 * @param {Function} _callback
 */
function apple_iap_product_purchase(_product_id, _callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _product_id, type: String
    if (!is_string(_product_id)) show_error($"{_GMFUNCTION_} :: _product_id expected string", true);
    buffer_write(__args_buffer, buffer_u32, string_byte_length(_product_id));
    buffer_write(__args_buffer, buffer_string, _product_id);

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_product_purchase(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {String} _transaction_id
 * @param {Function} _callback
 */
function apple_iap_transaction_finish(_transaction_id, _callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _transaction_id, type: String
    if (!is_string(_transaction_id)) show_error($"{_GMFUNCTION_} :: _transaction_id expected string", true);
    buffer_write(__args_buffer, buffer_u32, string_byte_length(_transaction_id));
    buffer_write(__args_buffer, buffer_string, _transaction_id);

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_transaction_finish(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {Function} _callback
 */
function apple_iap_transactions_updates(_callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_transactions_updates(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

// Skipping function apple_iap_transactions_updates_stop (no wrapper is required)


/**
 * @param {String} _product_id
 * @param {Function} _callback
 */
function apple_iap_transactions_current_entitlement(_product_id, _callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _product_id, type: String
    if (!is_string(_product_id)) show_error($"{_GMFUNCTION_} :: _product_id expected string", true);
    buffer_write(__args_buffer, buffer_u32, string_byte_length(_product_id));
    buffer_write(__args_buffer, buffer_string, _product_id);

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_transactions_current_entitlement(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {Function} _callback
 */
function apple_iap_transactions_current_entitlements(_callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_transactions_current_entitlements(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {String} _product_id
 * @param {Function} _callback
 */
function apple_iap_transactions_latest(_product_id, _callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _product_id, type: String
    if (!is_string(_product_id)) show_error($"{_GMFUNCTION_} :: _product_id expected string", true);
    buffer_write(__args_buffer, buffer_u32, string_byte_length(_product_id));
    buffer_write(__args_buffer, buffer_string, _product_id);

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_transactions_latest(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {Function} _callback
 */
function apple_iap_transactions_unfinished(_callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_transactions_unfinished(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {Function} _callback
 */
function apple_iap_transactions_all(_callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_transactions_all(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/**
 * @param {Function} _callback
 */
function apple_iap_synchronize(_callback)
{
    var __available__ = __GMAppleIAPs_is_available();
    if (!__available__) return;

    var __dispatcher__ = __GMAppleIAPs_get_dispatcher();

    var __args_buffer = __ext_core_get_args_buffer();

    // param: _callback, type: Function
    if (!is_callable(_callback)) show_error($"{_GMFUNCTION_} :: _callback expected callable type", true);
    var _callback_handle = __ext_core_function_register(_callback, __dispatcher__);
    buffer_write(__args_buffer, buffer_u64, _callback_handle);

    var __return_value__ = __apple_iap_synchronize(buffer_get_address(__args_buffer), buffer_tell(__args_buffer));

    return __return_value__;
}

/// @ignore
function __GMAppleIAPs_get_decoders()
{
    static __decoders__ = [
        __AppleIAPProduct_decode,
        __AppleIAPTransaction_decode,
        __AppleIAPTransactionFinishResult_decode,
        __AppleIAPSyncResult_decode,
        __AppleIAPProductsResult_decode,
        __AppleIAPVerifiedTransaction_decode,
        __AppleIAPPurchaseResult_decode,
        __AppleIAPTransactionResult_decode,
        __AppleIAPTransactionsResult_decode
    ];
    return __decoders__;
}
/// @ignore
function __GMAppleIAPs_get_dispatcher()
{
    static __dispatcher__ = new __GMNativeFunctionDispatcher(__GMAppleIAPs_invocation_handler, __GMAppleIAPs_get_decoders());
    return __dispatcher__;
}
/// @ignore
function __GMAppleIAPs_is_available()
{
    static __available__ = extension_exists("GMAppleIAPs");
    return __available__;
}
