// ----------------------------------------------------------------------------
//
//  VoidBody.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHttp

// ----------------------------------------------------------------------------

open class VoidBody: HttpBody
{
// MARK: - Properties

    open var mediaType: MediaType? {
        return nil
    }

    open var body: Data? {
        return nil
    }

}

// ----------------------------------------------------------------------------
