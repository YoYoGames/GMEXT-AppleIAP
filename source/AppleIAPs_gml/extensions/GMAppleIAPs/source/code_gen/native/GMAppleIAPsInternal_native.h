// ##### extgen :: Auto-generated file do not edit!! #####

#pragma once
#include <cstdint>
#include <string_view>
#include <vector>
#include <array>
#include <optional>
#include "core/GMExtWire.h"

namespace gm_consts
{
}


namespace gm_enums
{
    enum class AppleIAPProductsStatus : std::int32_t
    {
        None = 0,
        Success = 1,
        EmptyProductIds = 2,
        Error = 3
    };

    enum class AppleIAPPurchaseStatus : std::int32_t
    {
        None = 0,
        Success = 1,
        UserCancelled = 2,
        Pending = 3,
        ProductNotFound = 4,
        Error = 5,
        Unknown = 6,
        VerificationFailed = 7
    };

    enum class AppleIAPTransactionStatus : std::int32_t
    {
        None = 0,
        Success = 1,
        InvalidTransactionId = 2,
        TransactionNotFound = 3,
        NoCurrentEntitlement = 4,
        NoLatestTransaction = 5,
        Error = 6,
        VerificationFailed = 7
    };

    enum class AppleIAPSyncStatus : std::int32_t
    {
        None = 0,
        Success = 1,
        Error = 2
    };

    enum class AppleIAPProductType : std::int32_t
    {
        Unknown = 0,
        Consumable = 1,
        NonConsumable = 2,
        NonRenewable = 3,
        AutoRenewable = 4
    };

    enum class AppleIAPTransactionEnvironment : std::int32_t
    {
        Unknown = 0,
        Xcode = 1,
        Sandbox = 2,
        Production = 3
    };

    enum class AppleIAPTransactionOwnershipType : std::int32_t
    {
        Unknown = 0,
        Purchased = 1,
        FamilyShared = 2
    };

    enum class AppleIAPRevocationReason : std::int32_t
    {
        None = 0,
        DeveloperIssue = 1,
        Other = 2,
        Unknown = 3
    };

}


namespace gm_structs
{
    struct AppleIAPProduct;
    struct AppleIAPTransaction;
    struct AppleIAPProductsResult;
    struct AppleIAPPurchaseResult;
    struct AppleIAPTransactionFinishResult;
    struct AppleIAPTransactionResult;
    struct AppleIAPTransactionsResult;
    struct AppleIAPSyncResult;

    struct AppleIAPProduct
    {
        std::string id;
        gm_enums::AppleIAPProductType type;
        std::string display_name;
        std::string description;
        std::string display_price;
        double price;
        std::string currency_code;
    };

    struct AppleIAPTransaction
    {
        std::string id;
        std::string original_id;
        std::string web_order_line_item_id;
        std::string product_id;
        gm_enums::AppleIAPProductType product_type;
        std::string subscription_group_id;
        double purchase_date_ms;
        double original_purchase_date_ms;
        double expiration_date_ms;
        double revocation_date_ms;
        double signed_date_ms;
        gm_enums::AppleIAPRevocationReason revocation_reason;
        bool is_upgraded;
        gm_enums::AppleIAPTransactionOwnershipType ownership_type;
        gm_enums::AppleIAPTransactionEnvironment environment;
        std::string app_account_token;
        std::string offer_id;
    };

    struct AppleIAPProductsResult
    {
        bool success;
        gm_enums::AppleIAPProductsStatus status;
        std::string message;
    };

    struct AppleIAPPurchaseResult
    {
        bool success;
        gm_enums::AppleIAPPurchaseStatus status;
        std::string message;
    };

    struct AppleIAPTransactionFinishResult
    {
        bool success;
        gm_enums::AppleIAPTransactionStatus status;
        std::string message;
    };

    struct AppleIAPTransactionResult
    {
        bool success;
        gm_enums::AppleIAPTransactionStatus status;
        std::string message;
    };

    struct AppleIAPTransactionsResult
    {
        bool success;
        gm_enums::AppleIAPTransactionStatus status;
        std::string message;
    };

    struct AppleIAPSyncResult
    {
        bool success;
        gm_enums::AppleIAPSyncStatus status;
        std::string message;
    };

}

namespace gm::wire::codec
{
    template<>
    inline void writeValue<gm_structs::AppleIAPProduct>(gm::byteio::IByteWriter& _buf, const gm_structs::AppleIAPProduct& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.id);
        gm::wire::codec::writeValue(_buf, obj.type);
        gm::wire::codec::writeValue(_buf, obj.display_name);
        gm::wire::codec::writeValue(_buf, obj.description);
        gm::wire::codec::writeValue(_buf, obj.display_price);
        gm::wire::codec::writeValue(_buf, obj.price);
        gm::wire::codec::writeValue(_buf, obj.currency_code);
    }

    template<>
    inline gm_structs::AppleIAPProduct readValue<gm_structs::AppleIAPProduct>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::AppleIAPProduct obj;
        obj.id = gm::wire::codec::readValue<std::string>(_buf);
        obj.type = gm::wire::codec::readValue<gm_enums::AppleIAPProductType>(_buf);
        obj.display_name = gm::wire::codec::readValue<std::string>(_buf);
        obj.description = gm::wire::codec::readValue<std::string>(_buf);
        obj.display_price = gm::wire::codec::readValue<std::string>(_buf);
        obj.price = gm::wire::codec::readValue<double>(_buf);
        obj.currency_code = gm::wire::codec::readValue<std::string>(_buf);
        return obj;
    }

    template<>
    inline void writeValue<gm_structs::AppleIAPTransaction>(gm::byteio::IByteWriter& _buf, const gm_structs::AppleIAPTransaction& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.id);
        gm::wire::codec::writeValue(_buf, obj.original_id);
        gm::wire::codec::writeValue(_buf, obj.web_order_line_item_id);
        gm::wire::codec::writeValue(_buf, obj.product_id);
        gm::wire::codec::writeValue(_buf, obj.product_type);
        gm::wire::codec::writeValue(_buf, obj.subscription_group_id);
        gm::wire::codec::writeValue(_buf, obj.purchase_date_ms);
        gm::wire::codec::writeValue(_buf, obj.original_purchase_date_ms);
        gm::wire::codec::writeValue(_buf, obj.expiration_date_ms);
        gm::wire::codec::writeValue(_buf, obj.revocation_date_ms);
        gm::wire::codec::writeValue(_buf, obj.signed_date_ms);
        gm::wire::codec::writeValue(_buf, obj.revocation_reason);
        gm::wire::codec::writeValue(_buf, obj.is_upgraded);
        gm::wire::codec::writeValue(_buf, obj.ownership_type);
        gm::wire::codec::writeValue(_buf, obj.environment);
        gm::wire::codec::writeValue(_buf, obj.app_account_token);
        gm::wire::codec::writeValue(_buf, obj.offer_id);
    }

    template<>
    inline gm_structs::AppleIAPTransaction readValue<gm_structs::AppleIAPTransaction>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::AppleIAPTransaction obj;
        obj.id = gm::wire::codec::readValue<std::string>(_buf);
        obj.original_id = gm::wire::codec::readValue<std::string>(_buf);
        obj.web_order_line_item_id = gm::wire::codec::readValue<std::string>(_buf);
        obj.product_id = gm::wire::codec::readValue<std::string>(_buf);
        obj.product_type = gm::wire::codec::readValue<gm_enums::AppleIAPProductType>(_buf);
        obj.subscription_group_id = gm::wire::codec::readValue<std::string>(_buf);
        obj.purchase_date_ms = gm::wire::codec::readValue<double>(_buf);
        obj.original_purchase_date_ms = gm::wire::codec::readValue<double>(_buf);
        obj.expiration_date_ms = gm::wire::codec::readValue<double>(_buf);
        obj.revocation_date_ms = gm::wire::codec::readValue<double>(_buf);
        obj.signed_date_ms = gm::wire::codec::readValue<double>(_buf);
        obj.revocation_reason = gm::wire::codec::readValue<gm_enums::AppleIAPRevocationReason>(_buf);
        obj.is_upgraded = gm::wire::codec::readValue<bool>(_buf);
        obj.ownership_type = gm::wire::codec::readValue<gm_enums::AppleIAPTransactionOwnershipType>(_buf);
        obj.environment = gm::wire::codec::readValue<gm_enums::AppleIAPTransactionEnvironment>(_buf);
        obj.app_account_token = gm::wire::codec::readValue<std::string>(_buf);
        obj.offer_id = gm::wire::codec::readValue<std::string>(_buf);
        return obj;
    }

    template<>
    inline void writeValue<gm_structs::AppleIAPProductsResult>(gm::byteio::IByteWriter& _buf, const gm_structs::AppleIAPProductsResult& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.success);
        gm::wire::codec::writeValue(_buf, obj.status);
        gm::wire::codec::writeValue(_buf, obj.message);
    }

    template<>
    inline gm_structs::AppleIAPProductsResult readValue<gm_structs::AppleIAPProductsResult>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::AppleIAPProductsResult obj;
        obj.success = gm::wire::codec::readValue<bool>(_buf);
        obj.status = gm::wire::codec::readValue<gm_enums::AppleIAPProductsStatus>(_buf);
        obj.message = gm::wire::codec::readValue<std::string>(_buf);
        return obj;
    }

    template<>
    inline void writeValue<gm_structs::AppleIAPPurchaseResult>(gm::byteio::IByteWriter& _buf, const gm_structs::AppleIAPPurchaseResult& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.success);
        gm::wire::codec::writeValue(_buf, obj.status);
        gm::wire::codec::writeValue(_buf, obj.message);
    }

    template<>
    inline gm_structs::AppleIAPPurchaseResult readValue<gm_structs::AppleIAPPurchaseResult>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::AppleIAPPurchaseResult obj;
        obj.success = gm::wire::codec::readValue<bool>(_buf);
        obj.status = gm::wire::codec::readValue<gm_enums::AppleIAPPurchaseStatus>(_buf);
        obj.message = gm::wire::codec::readValue<std::string>(_buf);
        return obj;
    }

    template<>
    inline void writeValue<gm_structs::AppleIAPTransactionFinishResult>(gm::byteio::IByteWriter& _buf, const gm_structs::AppleIAPTransactionFinishResult& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.success);
        gm::wire::codec::writeValue(_buf, obj.status);
        gm::wire::codec::writeValue(_buf, obj.message);
    }

    template<>
    inline gm_structs::AppleIAPTransactionFinishResult readValue<gm_structs::AppleIAPTransactionFinishResult>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::AppleIAPTransactionFinishResult obj;
        obj.success = gm::wire::codec::readValue<bool>(_buf);
        obj.status = gm::wire::codec::readValue<gm_enums::AppleIAPTransactionStatus>(_buf);
        obj.message = gm::wire::codec::readValue<std::string>(_buf);
        return obj;
    }

    template<>
    inline void writeValue<gm_structs::AppleIAPTransactionResult>(gm::byteio::IByteWriter& _buf, const gm_structs::AppleIAPTransactionResult& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.success);
        gm::wire::codec::writeValue(_buf, obj.status);
        gm::wire::codec::writeValue(_buf, obj.message);
    }

    template<>
    inline gm_structs::AppleIAPTransactionResult readValue<gm_structs::AppleIAPTransactionResult>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::AppleIAPTransactionResult obj;
        obj.success = gm::wire::codec::readValue<bool>(_buf);
        obj.status = gm::wire::codec::readValue<gm_enums::AppleIAPTransactionStatus>(_buf);
        obj.message = gm::wire::codec::readValue<std::string>(_buf);
        return obj;
    }

    template<>
    inline void writeValue<gm_structs::AppleIAPTransactionsResult>(gm::byteio::IByteWriter& _buf, const gm_structs::AppleIAPTransactionsResult& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.success);
        gm::wire::codec::writeValue(_buf, obj.status);
        gm::wire::codec::writeValue(_buf, obj.message);
    }

    template<>
    inline gm_structs::AppleIAPTransactionsResult readValue<gm_structs::AppleIAPTransactionsResult>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::AppleIAPTransactionsResult obj;
        obj.success = gm::wire::codec::readValue<bool>(_buf);
        obj.status = gm::wire::codec::readValue<gm_enums::AppleIAPTransactionStatus>(_buf);
        obj.message = gm::wire::codec::readValue<std::string>(_buf);
        return obj;
    }

    template<>
    inline void writeValue<gm_structs::AppleIAPSyncResult>(gm::byteio::IByteWriter& _buf, const gm_structs::AppleIAPSyncResult& obj)
    {
        gm::wire::codec::writeValue(_buf, obj.success);
        gm::wire::codec::writeValue(_buf, obj.status);
        gm::wire::codec::writeValue(_buf, obj.message);
    }

    template<>
    inline gm_structs::AppleIAPSyncResult readValue<gm_structs::AppleIAPSyncResult>(gm::byteio::BufferReader& _buf)
    {
        gm_structs::AppleIAPSyncResult obj;
        obj.success = gm::wire::codec::readValue<bool>(_buf);
        obj.status = gm::wire::codec::readValue<gm_enums::AppleIAPSyncStatus>(_buf);
        obj.message = gm::wire::codec::readValue<std::string>(_buf);
        return obj;
    }

}

namespace gm::wire::details
{
    template<>
    struct gm_struct_traits<gm_structs::AppleIAPProduct>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 0;
    };

    template<>
    struct gm_struct_traits<gm_structs::AppleIAPTransaction>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 1;
    };

    template<>
    struct gm_struct_traits<gm_structs::AppleIAPProductsResult>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 2;
    };

    template<>
    struct gm_struct_traits<gm_structs::AppleIAPPurchaseResult>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 3;
    };

    template<>
    struct gm_struct_traits<gm_structs::AppleIAPTransactionFinishResult>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 4;
    };

    template<>
    struct gm_struct_traits<gm_structs::AppleIAPTransactionResult>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 5;
    };

    template<>
    struct gm_struct_traits<gm_structs::AppleIAPTransactionsResult>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 6;
    };

    template<>
    struct gm_struct_traits<gm_structs::AppleIAPSyncResult>
    {
        static constexpr bool is_gm_struct = true;
        static constexpr std::uint32_t codec_id = 7;
    };

}

bool apple_iap_init(const gm::wire::GMFunction& callback);
void apple_iap_products(const std::vector<std::string_view>& products_id, const gm::wire::GMFunction& callback);
void apple_iap_product_purchase(std::string_view product_id, const gm::wire::GMFunction& callback);
void apple_iap_transaction_finish(std::string_view transaction_id, const gm::wire::GMFunction& callback);
void apple_iap_transactions_current_entitlement(std::string_view product_id, const gm::wire::GMFunction& callback);
void apple_iap_transactions_current_entitlements(const gm::wire::GMFunction& callback);
void apple_iap_transactions_latest(std::string_view product_id, const gm::wire::GMFunction& callback);
void apple_iap_transactions_unfinished(const gm::wire::GMFunction& callback);
void apple_iap_transactions_all(const gm::wire::GMFunction& callback);
void apple_iap_synchronize(const gm::wire::GMFunction& callback);
