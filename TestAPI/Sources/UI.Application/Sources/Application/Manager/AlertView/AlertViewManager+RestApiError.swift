// ----------------------------------------------------------------------------
//
//  AlertViewManager+RestApiError.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------

extension AlertManager
{
// MARK: - Methods

    class func showErrorAlertView(_ error: RestApiError)
    {
        let params = alertViewParamsForError(error)
        showAlert(params.title, message: params.message)
    }

    class func alertViewParamsForError(_ error: RestApiError) -> AlertViewParams
    {
        let result: AlertViewParams

        switch error
        {
            case let error as TransportLayerError:
                result = paramsForTransportLayerError(error)

            case let error as ApplicationLayerError:
                result = paramsForApplicationLayerError(error)

// FIXME: Uncomment!
//            case let error as TopLevelProtocolError:
//                result = paramsForTopLevelProtocolError(error)

            default:
                result = paramsForUnexpectedError(error)
        }

        return result
    }

// MARK: - Private Methods

    private class func paramsForTransportLayerError(_ error: TransportLayerError) -> AlertViewParams
    {
        let result: AlertViewParams

        if (error.cause is ConnectionError)
        {
            result = AlertViewParams(title: nil, message: "Ошибка доступа к серверу")
        }
        else {
            result = paramsForUnexpectedError(error)
        }

        return result
    }

    private class func paramsForApplicationLayerError(_ error: ApplicationLayerError) -> AlertViewParams
    {
        let result: AlertViewParams

        if let cause = (error.cause as? ResponseError),
           let statusCode = cause.entity.status?.code
        {
            switch statusCode
            {
                default:
                    result = paramsForUnexpectedError(error)
            }
        }
        else
        if (error.cause is ConversionError) || (error.cause is UnexpectedMediaTypeError)
        {
            result = AlertViewParams(title: nil, message: "Ошибка доступа к серверу")
        }
        else {
            result = paramsForUnexpectedError(error)
        }

        return result
    }

    // FIXME: Uncomment!
//    private class func paramsForTopLevelProtocolError(error: TopLevelProtocolError)
//    {
//        guard let error = error.entity.body?.errors?.first else {
//            mdc_fatalError("Errors is empty")
//        }
//
//        showErrorAlertView(message: error.value)
//    }

    private class func paramsForUnexpectedError(_ error: RestApiError) -> AlertViewParams {
        return AlertViewParams(title: nil, message: "Ошибка доступа к серверу")
    }

}

// ----------------------------------------------------------------------------
