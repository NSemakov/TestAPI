// ----------------------------------------------------------------------------
//
//  AddRecordTask.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

open class AddRecordTask: AbstractTask<FormBody, Void>
{
// MARK: - Construction

    init(builder: AddRecordTaskBuilder)
    {
        // Init instance variables
        self.options = builder.options

        // Parent processing
        super.init(builder: builder)
    }

// MARK: - Methods

    override open func callExecute() -> HttpResult
    {
        let route = RestApiRoute.base(getRequestEntity().url!)
        return newClient().post(newRequestEntity(route))
    }

    override open func onSuccess(_ httpResult: CallResult<Data>) -> CallResult<Void> {
        return AddRecordTask.Converter.convert(httpResult)
    }

    override open func newBuilder() -> AddRecordTaskBuilder {
        return AddRecordTaskBuilder(task: self)
    }

// MARK: - Inner Types

    fileprivate struct Options
    {
        // ...
    }

// MARK: - Constants

    private static let Converter = VoidConverter()

// MARK: - Variables

    fileprivate let options: Options

}

// ----------------------------------------------------------------------------

open class AddRecordTaskBuilder: AbstractTaskBuilder<FormBody, Void>
{
// MARK: - Construction

    public override init() {
        super.init()
    }

    public init(task: AddRecordTask)
    {
        // Init instance variables
        self.options = task.options

        // Parent processing
        super.init(task: task)
    }

// MARK: - Methods

    override open func newTask() -> AddRecordTask {
        return AddRecordTask(builder: self)
    }

// MARK: - Variables

    fileprivate var options = AddRecordTask.Options()
    
}

// ----------------------------------------------------------------------------
