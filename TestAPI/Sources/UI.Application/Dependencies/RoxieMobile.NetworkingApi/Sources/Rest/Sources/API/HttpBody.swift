// ----------------------------------------------------------------------------
//
//  HttpBody.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHttp

// ----------------------------------------------------------------------------

public protocol HttpBody
{
// MARK: - Properties

    var mediaType: MediaType? { get }

    var body: Data? { get }

}

// ----------------------------------------------------------------------------
