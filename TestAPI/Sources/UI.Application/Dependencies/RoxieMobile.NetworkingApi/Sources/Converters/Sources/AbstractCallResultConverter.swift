// ----------------------------------------------------------------------------
//
//  AbstractCallResultConverter.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
////import NetworkingApiHttp
//import NetworkingApiRest

// ----------------------------------------------------------------------------

open class AbstractCallResultConverter<T>: CallResultConverter
{
// MARK: - Construction

    public init() {
        // Do nothing
    }

// MARK: - Functions

    open func convert(_ result: CallResult<Data>) -> CallResult<T> {
        var newResult: CallResult<T>

        // Handle call result
        switch result {

            case .success(let entity):
                do {
                    try checkMediaType(entity)

                    // Convert response entity
                    let response = try convert(entity)
                    newResult = .success(response)
                }
                catch (let cause)
                {
                    // Build new error with caught exception
                    let error = ApplicationLayerError(cause: cause)
                    newResult = .failure(error)
                }

            case .failure(let error):
                // Copy an original error
                newResult = .failure(error)
        }

        // Done
        return newResult
    }

    open func convert(_ entity: ResponseEntity<Ti>) throws -> ResponseEntity<To> {
        fatalError()
    }

    open func supportedMediaTypes() -> [MediaType] {
        fatalError()
    }

// MARK: - Private Methods

    private func checkMediaType(_ entity: ResponseEntity<Ti>) throws {
        let mediaType = entity.mediaType
        var found = false

        // Search for compatible MediaType
        if let mediaType = mediaType
        {
            for type in supportedMediaTypes()
            {
                if mediaType.isCompatibleWith(type)
                {
                    found = true
                    break
                }
            }
        }

        // Throw exception if on MediaType found
        if !found {
            throw UnexpectedMediaTypeError(entity: entity)
        }
    }

// MARK: - Inner Types

    public typealias Ti = Data

    public typealias To = T
}

// ----------------------------------------------------------------------------
