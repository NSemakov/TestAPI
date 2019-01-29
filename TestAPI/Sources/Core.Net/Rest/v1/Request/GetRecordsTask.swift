// ----------------------------------------------------------------------------
//
//  GetRecordsTask.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

open class GetRecordsTask: VendorAbstractTask<JsonBody, [RecordModel]>
{
// MARK: - Construction

    init(builder: GetRecordsTaskBuilder)
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

    override open func onSuccess(_ httpResult: CallResult<Data>) -> CallResult<[RecordModel]> {
        return GetRecordsTask.Converter.convert(httpResult)
    }

    override open func newBuilder() -> GetRecordsTaskBuilder {
        return GetRecordsTaskBuilder(task: self)
    }

// MARK: - Inner Types

    fileprivate struct Options
    {
        // ...
    }

// MARK: - Constants

    private static let Converter = ValidatableModelArrayConverter<RecordModel>()

// MARK: - Variables

    fileprivate let options: Options

}

// ----------------------------------------------------------------------------

open class GetRecordsTaskBuilder: VendorAbstractTaskBuilder<VoidBody, Void>
{
// MARK: - Construction

    public override init() {
        super.init()
    }

    public init(task: GetRecordsTask)
    {
        // Init instance variables
        self.options = task.options

        // Parent processing
        super.init(task: task)
    }

// MARK: - Methods

    override open func checkInvalidState() {
        super.checkInvalidState()

        Guard.notNil(self.options.orderId)
    }

    override open func newTask() -> GetRecordsTask {
        return GetRecordsTask(builder: self)
    }

// MARK: - Variables

    fileprivate var options = GetRecordsTask.Options()
    
}

// ----------------------------------------------------------------------------
