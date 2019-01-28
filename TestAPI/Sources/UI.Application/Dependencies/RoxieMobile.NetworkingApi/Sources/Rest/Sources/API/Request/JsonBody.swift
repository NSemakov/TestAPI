// ----------------------------------------------------------------------------
//
//  JsonBody.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHttp
//import SwiftCommonsData
import SwiftyJSON

// ----------------------------------------------------------------------------

open class JsonBody: HttpBody
{
// MARK: - Construction

    public init(body: JsonElement?)
    {
        // Init instance variables
        self.jsonBody = body
    }

// MARK: - Properties

    open var mediaType: MediaType? {
        return JsonBody.MediaTypeJson
    }

    open var body: Data? {
        guard let jsonBody = self.jsonBody else {
            return nil
        }
        return try? JSON(jsonBody).rawData()
    }

// MARK: - Constants

    fileprivate static let MediaTypeJson =
            MediaType.valueOf(MediaType.ApplicationJsonValue + "; charset=" + HttpKeys.EncodingName.UTF_8)

// MARK: - Variables
    
    fileprivate let jsonBody: JsonElement?

}

// ----------------------------------------------------------------------------
