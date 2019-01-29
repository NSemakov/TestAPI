// ----------------------------------------------------------------------------
//
//  AbstractTask.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHttp
////import SwiftCommonsConcurrent
////import SwiftCommonsDiagnostics
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

open class AbstractTask<Ti: HttpBody, To>: Task<Ti, To>, Cancellable
{
// MARK: - Construction

    public init(builder: AbstractTaskBuilder<Ti, To>)
    {
        // Init instance variables
        self.tag = builder.tag
        self.requestEntity = builder.requestEntity
    }

// MARK: - Properties

    /**
    * The tag associated with a task.
    */
    override open func getTag() -> String {
        return self.tag
    }

    /**
     * The original request entity.
     */
    override open func getRequestEntity() -> RequestEntity<Ti> {
        return self.requestEntity
    }

    /**
     * The http client config.
     */
    open func getHttpClientConfig() -> HttpClientConfig {
        return AbstractTaskInner.HttpClientConfig
    }

// MARK: - Methods

    /**
    * Synchronously send the request and return its response.
    */
    open override func execute(_ callback: Callback<Ti, To>?)
    {
        var shouldExecute = true
        var result: CallResult<To>?

        if let callback = callback {
            shouldExecute = callback.onShouldExecute(self)
        }

        if shouldExecute {
            result = call()
        }

        // Yielding result to listener
        if let callback = callback, shouldExecute {
            yieldResult(result, callback: callback)
        }
    }

    open override func enqueue(_ callback: Callback<Ti, To>?, callbackOnUiThread: Bool) -> Cancellable {
        return TaskQueue.enqueue(self, callback: callback, callbackOnUiThread: callbackOnUiThread)
    }

    /**
     * Performs the request and returns the response.
     * May return null if this call was canceled.
     */
    final func call() -> CallResult<To>?
    {
        Guard.isFalse(Thread.isMainThread, "This method must not be called from the main thread!")
        var result: CallResult<To>?

        // Send request to the server
        let httpResult = callExecute()
        var error: RestApiError?

        // Are HTTP response is still needed?
        if !isCancelled()
        {
            // Handle HTTP response
            switch httpResult
            {
                case .success(let entity):
                    // Create a new call result
                    if let status = entity.status, status.is2xxSuccessful() {
                        result = onSuccess(.success(entity))
                    }
                    else {
                        let cause = ResponseError(entity: entity)
                        // Build application layer error
                        error = ApplicationLayerError(cause: cause)
                    }

                case .failure(let cause):
                    var cause = cause

                    // Wrap up HTTP connection error
                    if isConnectionError(cause) {
                        cause = ConnectionError(cause: cause)
                    }

                    // Build transport layer error
                    error = TransportLayerError(cause: cause)
            }

            // Handle error
            if let error = error {
                result = onFailure(.failure(error))
            }
        }

        // Done
        return result
    }

    open func callExecute() -> HttpResult {
        raiseAbstractMethodException()
    }

    open func newClient() -> RestApiClient
    {
        // Get HTTP client config
        let config = getHttpClientConfig()

        // Create/init HTTP client
        let builder = RestApiClientBuilder()
                // Set the timeout until a connection is established
                .connectTimeout(config.connectTimeout())
                // Set the default socket timeout which is the timeout for waiting for data
                .requestTimeout(config.readTimeout())
                // Set an application interceptors
                .interceptors(config.interceptors())
                // Set an network interceptors
                .networkInterceptors(config.networkInterceptors())

        // Done
        return builder.build()
    }

    open func newRequestEntity(_ route: HttpRoute) -> RequestEntity<HttpBody>
    {
        let entity = self.requestEntity

        // Create HTTP request entity
        return BasicRequestEntityBuilder(entity: entity, body: entity.body)
                .url(route.url)
                .headers(httpHeaders())
                .build()
    }

    open func httpHeaders() -> HttpHeaders {
        return (self.requestEntity.headers ?? HttpHeaders([:]))
    }

    open func onSuccess(_ httpResult: CallResult<Data>) -> CallResult<To> {
        raiseAbstractMethodException()
    }

    open func onFailure(_ httpResult: CallResult<Data>) -> CallResult<To>
    {
        var result: CallResult<To>

        switch httpResult
        {
            case .success(_):
                Roxie.fatalError("Trying to call onFailure(_:) method for .Success(_) call result.")

            case .failure(let error):
                // Copy an original error
                result = .failure(error)
        }

        return result
    }

    open override func clone() -> AbstractTask<Ti, To> {
        return newBuilder().build()
    }

    open func newBuilder() -> AbstractTaskBuilder<Ti, To> {
        raiseAbstractMethodException()
    }

    open func isCancelled() -> Bool {
        return self.cancelled.value
    }

    open func cancel() -> Bool {
        return !(self.cancelled.swap(true))
    }

// MARK: - Private Functions

    fileprivate func isConnectionError(_ error: Error) -> Bool {
        return ((error as NSError).domain == NSURLErrorDomain || (error as NSError).domain == (kCFErrorDomainCFNetwork as NSString) as String)
    }

    fileprivate func yieldResult(_ result: CallResult<To>?, callback: Callback<Ti, To>)
    {
        if !isCancelled()
        {
            if let result = result
            {
                switch result
                {
                    case .success(let entity):
                        callback.onSuccess(self, entity: entity)

                    case .failure(let error):
                        callback.onFailure(self, error: error)
                }
            }
            else {
                Roxie.fatalError("!isCancelled() && (result == null)")
            }
        }
        else {
            callback.onCancel(self)
        }
    }

// MARK: - Inner Types

    public typealias TaskTi = Ti

    public typealias TaskTo = To

// MARK: - Variables

    fileprivate let tag: String

    fileprivate let requestEntity: RequestEntity<Ti>

    fileprivate let cancelled = Atomic<Bool>(false)

}

// ----------------------------------------------------------------------------

// WORKAROUND: Type 'Inner' nested in generic type 'AbstractTask' is not allowed
private struct AbstractTaskInner
{
// MARK: - Constants

    static let HttpClientConfig = DefaultHttpClientConfig()

}

// ----------------------------------------------------------------------------

open class AbstractTaskBuilder<Ti: HttpBody, To>: TaskBuilder<Ti, To>
{
// MARK: - Construction

    public override init()
    {
        // Init instance variables
        self.tag = nil
        self.requestEntity = nil
    }

    public init(task: Task<Ti, To>)
    {
        // Init instance variables
        self.tag = task.getTag()
        self.requestEntity = task.getRequestEntity()
    }

// MARK: - Properties

    open override func getTag() -> String {
        return self.tag
    }

    open override func getRequestEntity() -> RequestEntity<Ti> {
        return self.requestEntity
    }

// MARK: - Functions

    open func tag(_ tag: String) -> Self
    {
        self.tag = tag
        return self
    }

    open func requestEntity(_ requestEntity: RequestEntity<Ti>) -> Self
    {
        self.requestEntity = requestEntity
        return self
    }

    open override func build() -> AbstractTask<Ti, To>
    {
        checkInvalidState()
        return newTask()
    }

    open func checkInvalidState()
    {
        Guard.notNil(self.requestEntity)
    }

    open func newTask() -> AbstractTask<Ti, To> {
        raiseAbstractMethodException()
    }

// MARK: - Variables

    fileprivate var tag: String!

    fileprivate var requestEntity: RequestEntity<Ti>!

}

// ----------------------------------------------------------------------------
