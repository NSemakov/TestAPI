// ----------------------------------------------------------------------------
//
//  TaskQueue.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
////import NetworkingApiHelpers
//import NetworkingApiHttp
////import SwiftCommonsConcurrent
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

open class TaskQueue: NonCreatable
{
// MARK: - Functions

    @discardableResult public static func enqueue<Ti, To>(_ task: Task<Ti, To>) -> Cancellable {
        return enqueue(task, callback: nil)
    }

    @discardableResult public static func enqueue<Ti, To>(_ task: Task<Ti, To>, callback: Callback<Ti, To>?) -> Cancellable {
        return enqueue(task, callback: callback, callbackOnUiThread: Thread.isMainThread)
    }

    @discardableResult public static func enqueue<Ti, To>(_ task: Task<Ti, To>, callback: Callback<Ti, To>?, callbackOnUiThread: Bool) -> Cancellable
    {
        let innerTask = InnerTask(task: task, callback: callback, callbackOnUiThread: callbackOnUiThread)
        self.tasks.withValue { tasks in
            tasks.add(innerTask, key: task.getTag())
        }

        // Execute the task on the background thread
        DispatchQueue.global(qos: .utility).async
        {
            innerTask.execute()

            self.tasks.withValue { tasks in
                tasks.remove(task.getTag(), value: innerTask)
            }
        }

        // Done
        return innerTask
    }

    public static func cancel(_ tag: String)
    {
        let cancelledTasks = self.tasks.map { tasks in
            return tasks.remove(tag)
        }

        for task in cancelledTasks {
            task.cancel()
        }
    }

// MARK: - Variables

    fileprivate static let tasks = Atomic(MultiValueDictionary<String, Cancellable>())
}

// ----------------------------------------------------------------------------

private final class InnerTask<Ti, To>: Cancellable
{
// MARK: - Construction

    init(task: Task<Ti, To>, callback: Callback<Ti, To>?, callbackOnUiThread: Bool)
    {
        // Init instance variables
        self.task = task.clone()
        self.callback = InnerCallback(callback: callback, callbackOnUiThread: callbackOnUiThread)
    }

// MARK: - Functions

    func execute() {
        self.task.execute(self.callback)
    }

    func cancel() -> Bool {
        return self.callback.cancel(self.task)
    }

// MARK: - Variables

    fileprivate let task: Task<Ti, To>

    fileprivate let callback: InnerCallback<Ti, To>
}

// ----------------------------------------------------------------------------

private final class InnerCallback<Ti, To>: CallbackDecorator<Ti, To>
{
// MARK: - Construction

    init(callback: Callback<Ti, To>?, callbackOnUiThread: Bool)
    {
        // Init instance variables
        self.queue = callbackOnUiThread ?
                DispatchQueue.main :
                DispatchQueue.global(qos: .default)

        // Parent processing
        super.init(callback: callback ?? CallbackDecorator())
    }

// MARK: - Functions

    override func onShouldExecute(_ call: Call<Ti>) -> Bool
    {
        guard !(self.done.value) else { return false }

        var result = false

        self.queue.sync {
            result = super.onShouldExecute(call)
        }

        return result
    }

    override func onSuccess(_ call: Call<Ti>, entity: ResponseEntity<To>)
    {
        guard !(self.done.swap(true)) else { return }

        self.queue.async {
            super.onSuccess(call, entity: entity)
        }
    }

    override func onFailure(_ call: Call<Ti>, error: RestApiError)
    {
        guard !(self.done.swap(true)) else { return }

        self.queue.async {
            super.onFailure(call, error: error)
        }
    }

    override func onCancel(_ call: Call<Ti>)
    {
        guard !(self.done.swap(true)) else { return }

        self.queue.async {
            super.onCancel(call)
        }
    }

    func cancel(_ call: Call<Ti>) -> Bool
    {
        let result = !self.done.swap(true)

        if result
        {
            (call as? Cancellable)?.cancel()

            self.queue.async {
                super.onCancel(call)
            }
        }

        return result
    }

// MARK: - Variables

    fileprivate let queue: DispatchQueue

    fileprivate let done = Atomic<Bool>(false)
}

// ----------------------------------------------------------------------------
