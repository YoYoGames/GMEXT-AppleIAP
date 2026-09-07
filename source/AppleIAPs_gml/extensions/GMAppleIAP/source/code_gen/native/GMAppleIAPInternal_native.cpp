// ##### extgen :: Auto-generated file do not edit!! #####

#include "GMAppleIAPInternal_native.h"
#include "GMAppleIAPInternal_exports.h"

using namespace gm_structs;
using namespace gm::wire::codec;

static gm::runtime::DispatchQueue __dispatch_queue;

// Internal function used for fetching dispatched function calls to GML
GMEXPORT double __EXT_NATIVE__GMAppleIAP_invocation_handler(char* __ret_buffer, double __ret_buffer_length)
{
    gm::byteio::BufferWriter __bw{ __ret_buffer, static_cast<size_t>(__ret_buffer_length) };
    return __dispatch_queue.fetch(__bw);
}

GMEXPORT double __EXT_NATIVE__apple_iap_init(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    auto&& __result = apple_iap_init(callback);
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__apple_iap_can_make_payments(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    auto&& __result = apple_iap_can_make_payments(callback);
    return static_cast<double>(__result);
}

GMEXPORT double __EXT_NATIVE__apple_iap_products(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: products_id, type: String[]
    std::vector<std::string_view> products_id = gm::wire::codec::readVector<std::string_view>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    apple_iap_products(products_id, callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__apple_iap_product_purchase(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: product_id, type: String
    std::string_view product_id = gm::wire::codec::readValue<std::string_view>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    // field: app_account_token, type: optional<String>
    std::optional<std::string_view> app_account_token = gm::wire::codec::readOptional<std::string_view>(__br);

    // field: quantity, type: optional<Int32>
    std::optional<std::int32_t> quantity = gm::wire::codec::readOptional<std::int32_t>(__br);

    apple_iap_product_purchase(product_id, callback, app_account_token, quantity);
    return 0;
}

GMEXPORT double __EXT_NATIVE__apple_iap_transaction_finish(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: transaction_id, type: String
    std::string_view transaction_id = gm::wire::codec::readValue<std::string_view>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    apple_iap_transaction_finish(transaction_id, callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__apple_iap_transactions_current_entitlement(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: product_id, type: String
    std::string_view product_id = gm::wire::codec::readValue<std::string_view>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    apple_iap_transactions_current_entitlement(product_id, callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__apple_iap_transactions_current_entitlements(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    apple_iap_transactions_current_entitlements(callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__apple_iap_transactions_latest(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: product_id, type: String
    std::string_view product_id = gm::wire::codec::readValue<std::string_view>(__br);

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    apple_iap_transactions_latest(product_id, callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__apple_iap_transactions_unfinished(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    apple_iap_transactions_unfinished(callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__apple_iap_transactions_all(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    apple_iap_transactions_all(callback);
    return 0;
}

GMEXPORT double __EXT_NATIVE__apple_iap_synchronize(char* __arg_buffer, double __arg_buffer_length)
{
    gm::byteio::BufferReader __br{__arg_buffer, static_cast<size_t>(__arg_buffer_length)};

    // field: callback, type: Function
    gm::wire::GMFunction callback = gm::wire::codec::readFunction(__br, &__dispatch_queue);

    apple_iap_synchronize(callback);
    return 0;
}

