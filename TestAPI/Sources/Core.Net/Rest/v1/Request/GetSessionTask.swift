// ----------------------------------------------------------------------------
//
//  GetSessionTask.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

open class GetSessionTask: AbstractTask<FormBody, SessionModel>
{
// MARK: - Construction

    init(builder: GetSessionTaskBuilder)
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

    override open func onSuccess(_ httpResult: CallResult<Data>) -> CallResult<SessionModel> {
        return GetSessionTask.Converter.convert(httpResult)
    }

    override open func newBuilder() -> GetSessionTaskBuilder {
        return GetSessionTaskBuilder(task: self)
    }

// MARK: - Inner Types

    fileprivate struct Options
    {
        // ...
    }

// MARK: - Constants

    private static let Converter = ValidatableModelConverter<SessionModel>()

// MARK: - Variables

    fileprivate let options: Options

}

// ----------------------------------------------------------------------------

open class GetSessionTaskBuilder: AbstractTaskBuilder<FormBody, SessionModel>
{
// MARK: - Construction

    public override init() {
        super.init()
    }

    public init(task: GetSessionTask)
    {
        // Init instance variables
        self.options = task.options

        // Parent processing
        super.init(task: task)
    }

// MARK: - Methods

    override open func newTask() -> GetSessionTask {
        return GetSessionTask(builder: self)
    }

// MARK: - Variables

    fileprivate var options = GetSessionTask.Options()
    
}

// ----------------------------------------------------------------------------
