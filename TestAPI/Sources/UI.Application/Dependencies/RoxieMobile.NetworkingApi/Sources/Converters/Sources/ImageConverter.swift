// ----------------------------------------------------------------------------
//
//  ImageConverter.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

////import NetworkingApiHttp
//import NetworkingApiRest
//import SwiftCommonsData
import UIKit

// ----------------------------------------------------------------------------

open class ImageConverter: AbstractCallResultConverter<UIImage>
{
// MARK: - Construction

    public override init() {
        super.init()
    }

// MARK: - Functions

    open override func convert(_ entity: ResponseEntity<Ti>) throws -> ResponseEntity<To> {
        var newEntity: ResponseEntity<To>
        var newBody: UIImage?

        if let body = entity.body, body.isNotEmpty {
            do {
                // Try to parse response body as image
                if let image = UIImage(data: body) {
                    newBody = image
                }
                else {
                    throw JsonSyntaxError(reason: "Failed to convert response body to image.")
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
        return ImageConverter.SupportedMediaTypes
    }

// MARK: - Constants

    private static let SupportedMediaTypes = [
        MediaType.ImageJpeg,
        MediaType.ImagePng
    ]
}

// ----------------------------------------------------------------------------
