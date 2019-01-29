// ----------------------------------------------------------------------------
//
//  SimpleRestApiCallback.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------

class SimpleRestApiCallback<Ti, To>: CallbackDecorator<Ti, To>
{
// MARK: - Construction

    override init() {
        super.init()
    }

    func then(
            onShouldExecute onShouldExecuteBlock: OnShouldExecuteBlock? = nil,
            onSuccess onSuccessBlock: OnSuccessBlock? = nil,
            onFailure onFailureBlock: OnFailureBlock? = nil,
            onCancel onCancelBlock: OnCancelBlock? = nil)
    {
        // Init instance variables
        self.onShouldExecuteBlock = onShouldExecuteBlock
        self.onSuccessBlock = onSuccessBlock
        self.onFailureBlock = onFailureBlock
        self.onCancelBlock = onCancelBlock
    }

// MARK: - Properties

    // ...

// MARK: - Methods

    override func onShouldExecute(_ call: Call<Ti>) -> Bool
    {
        if let block = self.onShouldExecuteBlock
        {
            return block(call, onShouldExecuteCallback)
        }
        else {
            return onShouldExecuteCallback(call)
        }
    }

    func onShouldExecuteCallback(_ call: Call<Ti>) -> Bool {
        return super.onShouldExecute(call)
    }

    override func onSuccess(_ call: Call<Ti>, entity: ResponseEntity<To>)
    {
        if let block = self.onSuccessBlock
        {
            block(call, entity, onSuccessCallback)
        }
        else {
            onSuccessCallback(call, entity: entity)
        }
    }

    func onSuccessCallback(_ call: Call<Ti>, entity: ResponseEntity<To>) {
        super.onSuccess(call, entity: entity)
    }

    override func onFailure(_ call: Call<Ti>, error: RestApiError)
    {
        if let block = self.onFailureBlock
        {
            block(call, error, onFailureCallback)
        }
        else {
            onFailureCallback(call, error: error)
        }
    }

    func onFailureCallback(_ call: Call<Ti>, error: RestApiError) {
        super.onFailure(call, error: error)
    }

    override func onCancel(_ call: Call<Ti>)
    {
        if let block = self.onCancelBlock
        {
            block(call, onCancelCallback)
        }
        else {
            onCancelCallback(call)
        }
    }

    func onCancelCallback(_ call: Call<Ti>) {
        super.onCancel(call)
    }

// MARK: - Actions

    // ...

// MARK: - Private Methods

    // ...

// MARK: - Inner Types

    typealias OnShouldExecuteCallback = (Call<Ti>) -> Bool
    typealias OnShouldExecuteBlock = (Call<Ti>, OnShouldExecuteCallback) -> Bool

    typealias OnSuccessBlockCallback = (Call<Ti>, ResponseEntity<To>) -> Void
    typealias OnSuccessBlock = (Call<Ti>, ResponseEntity<To>, OnSuccessBlockCallback) -> Void

    typealias OnFailureBlockCallback = (Call<Ti>, RestApiError) -> Void
    typealias OnFailureBlock = (Call<Ti>, RestApiError, OnFailureBlockCallback) -> Void

    typealias OnCancelBlockCallback = (_ call: Call<Ti>) -> Void
    typealias OnCancelBlock = (Call<Ti>, OnCancelBlockCallback) -> Void

// MARK: - Constants

    // ...

// MARK: - Variables

    private var onShouldExecuteBlock: OnShouldExecuteBlock?

    private var onSuccessBlock: OnSuccessBlock?

    private var onFailureBlock: OnFailureBlock?

    private var onCancelBlock: OnCancelBlock?

}

// ----------------------------------------------------------------------------
