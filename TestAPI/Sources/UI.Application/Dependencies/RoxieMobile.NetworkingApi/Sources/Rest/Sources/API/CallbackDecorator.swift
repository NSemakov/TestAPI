// ----------------------------------------------------------------------------
//
//  CallbackDecorator.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

open class CallbackDecorator<Ti, To>: Callback<Ti, To>
{
// MARK: - Construction

    public override init() {
        // Init instance variables
        self.callback = nil
    }

    public init(callback: Callback<Ti, To>)
    {
        // Init instance variables
        self.callback = callback
    }

// MARK: - Functions

    open override func onShouldExecute(_ call: Call<Ti>) -> Bool
    {
        guard let callback = self.callback else {
            return true
        }

        return callback.onShouldExecute(call)
    }

    open override func onSuccess(_ call: Call<Ti>, entity: ResponseEntity<To>) {
        self.callback?.onSuccess(call, entity: entity)
    }

    open override func onFailure(_ call: Call<Ti>, error: RestApiError) {
        self.callback?.onFailure(call, error: error)
    }

    open override func onCancel(_ call: Call<Ti>) {
        self.callback?.onCancel(call)
    }

// MARK: - Variables

    fileprivate let callback: Callback<Ti, To>?

}

// ----------------------------------------------------------------------------
