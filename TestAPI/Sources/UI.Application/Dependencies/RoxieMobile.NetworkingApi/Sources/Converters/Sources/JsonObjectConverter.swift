// ----------------------------------------------------------------------------
//
//  JsonObjectConverter.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

////import NetworkingApiHttp
//import NetworkingApiRest
//import SwiftCommonsData
import SwiftyJSON

// ----------------------------------------------------------------------------

open class JsonObjectConverter: AbstractCallResultConverter<JsonObject>
{
// MARK: - Construction

    public override init() {
        super.init()
    }

// MARK: - Functions

    open override func convert(_ entity: ResponseEntity<Ti>) throws -> ResponseEntity<To> {
        var newEntity: ResponseEntity<To>
        var newBody: JsonObject?

        if let body = entity.body, body.isNotEmpty {
            do {
                // Try to parse response body as JSON object
                if let jsonObject = try JSON(data: body, options: .allowFragments).object as? JsonObject {
                    newBody = jsonObject
                }
                else {
                    throw JsonSyntaxError(reason: "Failed to convert response body to JSON object.")
                }
            }
            catch {
                throw ConversionError(entity: entity, cause: error)
            }
        }

        // Create response entity
        newEntity = BasicResponseEntityBuilder(entity: entity, body: newBody).build()
        return newEntity
    }

    open override func supportedMediaTypes() -> [MediaType] {
        return JsonObjectConverter.SupportedMediaTypes
    }

// MARK: - Constants

    private static let SupportedMediaTypes = [
        MediaType.ApplicationJson
    ]
}

// ----------------------------------------------------------------------------
