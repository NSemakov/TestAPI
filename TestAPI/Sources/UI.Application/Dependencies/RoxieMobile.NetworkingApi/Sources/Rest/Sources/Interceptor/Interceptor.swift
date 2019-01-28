// ----------------------------------------------------------------------------
//
//  Interceptor.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

public protocol Interceptor
{
// MARK: - Functions

    func intercept(_ chain: InterceptorChain) throws -> HttpResponse

}

// ----------------------------------------------------------------------------
