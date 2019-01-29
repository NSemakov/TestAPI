// ----------------------------------------------------------------------------
//
//  TransportLayerError.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

open class TransportLayerError: AbstractRestApiError
{
// MARK: - Properties

    open override var type: RestApiErrorType {
        return .transportLayer
    }

}

// ----------------------------------------------------------------------------
