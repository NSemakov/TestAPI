// ----------------------------------------------------------------------------
//
//  AbstractValidatableModelConverter.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

//import NetworkingApiRest
//import SwiftCommonsData
import SwiftyJSON

// ----------------------------------------------------------------------------

open class AbstractValidatableModelConverter<T: ValidatableModel>: AbstractCallResultConverter<T>
{
// MARK: - Construction

    public override init() {
        super.init()
    }

// MARK: - Functions

    open override func convert(_ entity: ResponseEntity<Ti>) throws -> ResponseEntity<To> {
        var newEntity: ResponseEntity<To>
        var newBody: T?

        if let body = entity.body, body.isNotEmpty {
            do {
                // Try to parse response body as JSON object
                if let jsonObject = try JSON(data: body, options: .allowFragments).object as? JsonObject {
                    newBody = try T.init(from: jsonObject)
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
}

// ----------------------------------------------------------------------------
