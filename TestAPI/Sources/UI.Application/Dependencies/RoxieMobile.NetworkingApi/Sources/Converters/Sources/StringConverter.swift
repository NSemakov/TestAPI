// ----------------------------------------------------------------------------
//
//  StringConverter.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

////import NetworkingApiHttp
//import NetworkingApiRest

// ----------------------------------------------------------------------------

open class StringConverter: AbstractCallResultConverter<String>
{
// MARK: - Construction

    public override init() {
        super.init()
    }

// MARK: - Functions

    open override func convert(_ entity: ResponseEntity<Ti>) throws -> ResponseEntity<To> {
        var newEntity: ResponseEntity<To>
        var newBody: String?

        if let body = entity.body, body.isNotEmpty {

            // Try to parse response body as string
            if let encoding = EncodingProvider.encodingForCharset(entity.headers?.contentType?.charset ?? Inner.DefaultCharset),
               let string = String(data: body, encoding: encoding) {
                newBody = string
            }
            else {
                throw ConversionError(entity: entity)
            }
        }

        // Create response entity
        newEntity = BasicResponseEntityBuilder(entity: entity, body: newBody).build()
        return newEntity
    }

    override open func supportedMediaTypes() -> [MediaType] {
        return StringConverter.SupportedMediaTypes
    }

// MARK: - Constants

    private struct Inner {
        static let DefaultCharset = Charset.forName("ISO-8859-1")
    }

    private static let SupportedMediaTypes = [
        MediaType.All
    ]
}

// ----------------------------------------------------------------------------
