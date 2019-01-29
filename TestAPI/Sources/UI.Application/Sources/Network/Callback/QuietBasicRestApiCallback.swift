// ----------------------------------------------------------------------------
//
//  QuietBasicRestApiCallback.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------

class QuietBasicRestApiCallback<Ti, To>: SimpleRestApiCallback<Ti, To>
{
// MARK: - Construction

    override init()
    {
        // Init instance variables
        self.customTag = Roxie.newTag(for: type(of: self))

        // Parent processing
        super.init()
    }

// MARK: - Properties

    let customTag: String

// MARK: - Methods

    override func onFailure(_ call: Call<Ti>, error: RestApiError) {
        super.onFailure(call, error: error)

        // Log error
        Logger.e(self.customTag, "RestApiError", error)

        // Handle ConversionError and UnexpectedMediaTypeError
        if let cause = (error.cause as? AbstractNestedError), (cause is ConversionError) || (cause is UnexpectedMediaTypeError)
        {
            let errorMessage = "Could not create ‘\(Roxie.typeName(of: To.self))’."

            if let body = cause.entity.body,
               let bodyString = String(data: body, encoding: String.Encoding.utf8)
            {
                // TODO: Use cause from JsonSyntaxError
//                let exception = (cause.cause as? JsonSyntaxException)
                Roxie.fatalError(errorMessage + " Unexpected response: " + bodyString)
            }
            else {
                Roxie.fatalError(errorMessage)
            }
        }
    }

    override func onFailureCallback(_ call: Call<Ti>, error: RestApiError) {
        super.onFailureCallback(call, error: error)

        
    }
}

// ----------------------------------------------------------------------------
