import Foundation
import os.log
import CxxStdlib

open class GMAppleIAPInternalSwift
{
    internal var __dispatch_queue: GMDispatchQueue = GMDispatchQueue()

    public init()
    {
    }

    open func apple_iap_init(callback: GMFunction) -> Bool
    {
        // default stub for apple_iap_init
        return false
    }

    open func apple_iap_can_make_payments() -> Bool
    {
        // default stub for apple_iap_can_make_payments
        return false
    }

    open func apple_iap_products(products_id: [String], callback: GMFunction)
    {
        // default stub for apple_iap_products
    }

    open func apple_iap_product_purchase(product_id: String, callback: GMFunction, app_account_token: String?, quantity: Int32?)
    {
        // default stub for apple_iap_product_purchase
    }

    open func apple_iap_transaction_finish(transaction_id: String, callback: GMFunction)
    {
        // default stub for apple_iap_transaction_finish
    }

    open func apple_iap_transactions_current_entitlement(product_id: String, callback: GMFunction)
    {
        // default stub for apple_iap_transactions_current_entitlement
    }

    open func apple_iap_transactions_current_entitlements(callback: GMFunction)
    {
        // default stub for apple_iap_transactions_current_entitlements
    }

    open func apple_iap_transactions_latest(product_id: String, callback: GMFunction)
    {
        // default stub for apple_iap_transactions_latest
    }

    open func apple_iap_transactions_unfinished(callback: GMFunction)
    {
        // default stub for apple_iap_transactions_unfinished
    }

    open func apple_iap_transactions_all(callback: GMFunction)
    {
        // default stub for apple_iap_transactions_all
    }

    open func apple_iap_synchronize(callback: GMFunction)
    {
        // default stub for apple_iap_synchronize
    }

    public func __EXT_SWIFT__apple_iap_init(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            let __result = self.apple_iap_init(callback: callback)
            return __result ? 1.0 : 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_init'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__apple_iap_can_make_payments() -> Double
    {
        let __result = self.apple_iap_can_make_payments()
        return __result ? 1.0 : 0.0
    }

    public func __EXT_SWIFT__apple_iap_products(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: products_id, type: String[]
            let products_id: [String] = try __br.readRaw([String].self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.apple_iap_products(products_id: products_id, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_products'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__apple_iap_product_purchase(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: product_id, type: String
            let product_id: String = try __br.readRaw(String.self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            // field: app_account_token, type: optional<String>
            let app_account_token: String? = try __br.readRawOptional(String.self)

            // field: quantity, type: optional<Int32>
            let quantity: Int32? = try __br.readRawOptional(Int32.self)

            self.apple_iap_product_purchase(product_id: product_id, callback: callback, app_account_token: app_account_token, quantity: quantity)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_product_purchase'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__apple_iap_transaction_finish(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: transaction_id, type: String
            let transaction_id: String = try __br.readRaw(String.self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.apple_iap_transaction_finish(transaction_id: transaction_id, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_transaction_finish'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__apple_iap_transactions_current_entitlement(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: product_id, type: String
            let product_id: String = try __br.readRaw(String.self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.apple_iap_transactions_current_entitlement(product_id: product_id, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_transactions_current_entitlement'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__apple_iap_transactions_current_entitlements(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.apple_iap_transactions_current_entitlements(callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_transactions_current_entitlements'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__apple_iap_transactions_latest(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: product_id, type: String
            let product_id: String = try __br.readRaw(String.self)

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.apple_iap_transactions_latest(product_id: product_id, callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_transactions_latest'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__apple_iap_transactions_unfinished(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.apple_iap_transactions_unfinished(callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_transactions_unfinished'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__apple_iap_transactions_all(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.apple_iap_transactions_all(callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_transactions_all'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__apple_iap_synchronize(_ __arg_buffer: UnsafeMutablePointer<CChar>?, arg1 __arg_buffer_length: Double) -> Double
    {
        do
        {
            var __br = BufferReader(base: UnsafeRawPointer(__arg_buffer!), size: Int(__arg_buffer_length))

            // field: callback, type: Function
            let callback: GMFunction = try __br.readGMFunction(__dispatch_queue)

            self.apple_iap_synchronize(callback: callback)
            return 0.0
        }
        catch
        {
            os_log("Corrupted buffer when calling 'apple_iap_synchronize'", log: .default, type: .error)
            return -1
        }
    }

    public func __EXT_SWIFT__GMAppleIAP_invocation_handler(_ __ret_buffer: UnsafeMutablePointer<CChar>?, arg1 __ret_buffer_length: Double) -> Double
    {
        var __bw = BufferWriter(base: UnsafeMutableRawPointer(__ret_buffer!), size: Int(__ret_buffer_length))
        return __dispatch_queue.fetch(into: &__bw)
    }

}
