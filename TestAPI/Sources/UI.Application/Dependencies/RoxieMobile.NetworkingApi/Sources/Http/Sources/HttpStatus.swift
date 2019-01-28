// ----------------------------------------------------------------------------
//
//  HttpStatus.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

//import SwiftCommonsLang

// ----------------------------------------------------------------------------

public struct HttpStatus
{
// MARK: - Construction

    fileprivate init(_ code: HttpStatusCode, _ reasonPhrase: String)
    {
        // Init instance variables
        self.code = code
        self.reasonPhrase = reasonPhrase
    }

// MARK: - Properties

    /// Integer value of this status code.
    public let code: HttpStatusCode

    /// Reason phrase of this status code.
    public let reasonPhrase: String

// MARK: - Functions

    /**
     * Whether this status code is in the HTTP series
     * {@link org.springframework.http.HttpStatus.Series#INFORMATIONAL}.
     * This is a shortcut for checking the value of {@link #series()}.
     */
    public func is1xxInformational() -> Bool {
        return (self.code.rawValue >= 100) && (self.code.rawValue < 200)
    }

    /**
     * Whether this status code is in the HTTP series
     * {@link org.springframework.http.HttpStatus.Series#SUCCESSFUL}.
     * This is a shortcut for checking the value of {@link #series()}.
     */
    public func is2xxSuccessful() -> Bool {
        return (self.code.rawValue >= 200) && (self.code.rawValue < 300)
    }

    /**
     * Whether this status code is in the HTTP series
     * {@link org.springframework.http.HttpStatus.Series#REDIRECTION}.
     * This is a shortcut for checking the value of {@link #series()}.
     */
    public func is3xxRedirection() -> Bool {
        return (self.code.rawValue >= 300) && (self.code.rawValue < 400)
    }

    /**
     * Whether this status code is in the HTTP series
     * {@link org.springframework.http.HttpStatus.Series#CLIENT_ERROR}.
     * This is a shortcut for checking the value of {@link #series()}.
     */
    public func is4xxClientError() -> Bool {
        return (self.code.rawValue >= 400) && (self.code.rawValue < 500)
    }

    /**
     * Whether this status code is in the HTTP series
     * {@link org.springframework.http.HttpStatus.Series#SERVER_ERROR}.
     * This is a shortcut for checking the value of {@link #series()}.
     */
    public func is5xxServerError() -> Bool {
        return (self.code.rawValue >= 500) && (self.code.rawValue < 600)
    }

    /**
     * Return the enum constant of this type with the specified numeric value.
     * @param statusCode the numeric value of the enum to be returned
     * @return the enum constant with the specified numeric value
     * @throws IllegalArgumentException if this enum has no constant for the specified numeric value
     */
    public static func valueOf(_ statusCode: Int) -> HttpStatus?
    {
        if let statusCode = HttpStatusCode(rawValue: statusCode)
        {
            switch statusCode
            {
                // --- 1xx Informational ---

                case .continue:
                    return HttpStatus.Continue

                case .switchingProtocols:
                    return HttpStatus.SwitchingProtocols

                case .processing:
                    return HttpStatus.Processing

                // --- 2xx Success ---

                case .ok:
                    return HttpStatus.Ok

                case .created:
                    return HttpStatus.Created

                case .accepted:
                    return HttpStatus.Accepted

                case .nonAuthoritativeInformation:
                    return HttpStatus.NonAuthoritativeInformation

                case .noContent:
                    return HttpStatus.NoContent

                case .resetContent:
                    return HttpStatus.ResetContent

                case .partialContent:
                    return HttpStatus.PartialContent

                case .multiStatus:
                    return HttpStatus.MultiStatus

                case .alreadyReported:
                    return HttpStatus.AlreadyReported

                case .imUsed:
                    return HttpStatus.ImUsed

                // --- 3xx Redirection ---

                case .multipleChoices:
                    return HttpStatus.MultipleChoices

                case .movedPermanently:
                    return HttpStatus.MovedPermanently

                case .found:
                    return HttpStatus.Found

                case .seeOther:
                    return HttpStatus.SeeOther

                case .notModified:
                    return HttpStatus.NotModified

                case .useProxy:
                    return HttpStatus.UseProxy

                case .temporaryRedirect:
                    return HttpStatus.TemporaryRedirect

                // --- 4xx Client Error ---

                case .badRequest:
                    return HttpStatus.BadRequest

                case .unauthorized:
                    return HttpStatus.Unauthorized

                case .paymentRequired:
                    return HttpStatus.PaymentRequired

                case .forbidden:
                    return HttpStatus.Forbidden

                case .notFound:
                    return HttpStatus.NotFound

                case .methodNotAllowed:
                    return HttpStatus.MethodNotAllowed

                case .notAcceptable:
                    return HttpStatus.NotAcceptable

                case .proxyAuthenticationRequired:
                    return HttpStatus.ProxyAuthenticationRequired

                case .requestTimeout:
                    return HttpStatus.RequestTimeout

                case .conflict:
                    return HttpStatus.Conflict

                case .gone:
                    return HttpStatus.Gone

                case .lengthRequired:
                    return HttpStatus.LengthRequired

                case .preconditionFailed:
                    return HttpStatus.PreconditionFailed

                case .requestEntityTooLarge:
                    return HttpStatus.RequestEntityTooLarge

                case .requestUriTooLong:
                    return HttpStatus.RequestUriTooLong

                case .unsupportedMediaType:
                    return HttpStatus.UnsupportedMediaType

                case .requestedRangeNotSatisfiable:
                    return HttpStatus.RequestedRangeNotSatisfiable

                case .expectationFailed:
                    return HttpStatus.ExpectationFailed

                case .insufficientSpaceOnResource:
                    return HttpStatus.InsufficientSpaceOnResource

                case .methodFailure:
                    return HttpStatus.MethodFailure

                case .destinationLocked:
                    return HttpStatus.DestinationLocked

                case .unprocessableEntity:
                    return HttpStatus.UnprocessableEntity

                case .locked:
                    return HttpStatus.Locked

                case .failedDependency:
                    return HttpStatus.FailedDependency

                case .upgradeRequired:
                    return HttpStatus.UpgradeRequired

                case .preconditionRequired:
                    return HttpStatus.PreconditionRequired

                case .tooManyRequests:
                    return HttpStatus.TooManyRequests

                case .requestHeaderFieldsTooLarge:
                    return HttpStatus.RequestHeaderFieldsTooLarge

                case .loginTimeOut:
                    return HttpStatus.LoginTimeOut

                case .noResponse:
                    return HttpStatus.NoResponse

                case .retryWith:
                    return HttpStatus.RetryWith

                case .redirect:
                    return HttpStatus.Redirect

                case .sslCertificateError:
                    return HttpStatus.SslCertificateError

                case .sslCertificateRequired:
                    return HttpStatus.SslCertificateRequired

                case .httpRequestSentToHttpsPort:
                    return HttpStatus.HttpRequestSentToHttpsPort

                case .clientClosedRequest:
                    return HttpStatus.ClientClosedRequest

                // --- 5xx Server Error ---

                case .internalServerError:
                    return HttpStatus.InternalServerError

                case .notImplemented:
                    return HttpStatus.NotImplemented

                case .badGateway:
                    return HttpStatus.BadGateway

                case .serviceUnavailable:
                    return HttpStatus.ServiceUnavailable

                case .gatewayTimeout:
                    return HttpStatus.GatewayTimeout

                case .httpVersionNotSupported:
                    return HttpStatus.HttpVersionNotSupported

                case .variantAlsoNegotiates:
                    return HttpStatus.VariantAlsoNegotiates

                case .insufficientStorage:
                    return HttpStatus.InsufficientStorage

                case .loopDetected:
                    return HttpStatus.LoopDetected

                case .notExtended:
                    return HttpStatus.NotExtended

                case .networkAuthenticationRequired:
                    return HttpStatus.NetworkAuthenticationRequired

                case .unknownError:
                    return HttpStatus.UnknownError

                case .webServerIsDown:
                    return HttpStatus.WebServerIsDown

                case .connectionTimedOut:
                    return HttpStatus.ConnectionTimedOut

                case .originIsUnreachable:
                    return HttpStatus.OriginIsUnreachable

                case .aTimeoutOccurred:
                    return HttpStatus.ATimeoutOccurred

                case .sslHandshakeFailed:
                    return HttpStatus.SslHandshakeFailed

                case .invalidSslCertificate:
                    return HttpStatus.InvalidSslCertificate

                case .railgunError:
                    return HttpStatus.RailgunError
            }
        }

        // Terminate application with runtime exception
        Roxie.fatalError("No matching constant for [\(statusCode)].")
    }

    /// Return a string representation of this status code.
    public func toString() -> String {
        return "\(self.code.rawValue) \(self.reasonPhrase)"
    }

// MARK: - Constants

    // --- 1xx Informational ---

    /**
     * {@code 100 Continue}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.1.1">HTTP/1.1</a>
     */
    public static let Continue = HttpStatus(HttpStatusCode.continue, "Continue")

    /**
     * {@code 101 Switching Protocols}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.1.2">HTTP/1.1</a>
     */
    public static let SwitchingProtocols = HttpStatus(HttpStatusCode.switchingProtocols, "Switching Protocols")

    /**
     * {@code 102 Processing}.
     * @see <a href="http://tools.ietf.org/html/rfc2518#section-10.1">WebDAV</a>
     */
    public static let Processing = HttpStatus(HttpStatusCode.processing, "Processing")

    // --- 2xx Success ---

    /**
     * {@code 200 OK}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.1">HTTP/1.1</a>
     */
    public static let Ok = HttpStatus(HttpStatusCode.ok, "OK")

    /**
     * {@code 201 Created}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.2">HTTP/1.1</a>
     */
    public static let Created = HttpStatus(HttpStatusCode.created, "Created")

    /**
     * {@code 202 Accepted}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.3">HTTP/1.1</a>
     */
    public static let Accepted = HttpStatus(HttpStatusCode.accepted, "Accepted")

    /**
     * {@code 203 Non-Authoritative Information}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.4">HTTP/1.1</a>
     */
    public static let NonAuthoritativeInformation = HttpStatus(HttpStatusCode.nonAuthoritativeInformation, "Non-Authoritative Information")

    /**
     * {@code 204 No Content}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.5">HTTP/1.1</a>
     */
    public static let NoContent = HttpStatus(HttpStatusCode.noContent, "No Content")

    /**
     * {@code 205 Reset Content}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.6">HTTP/1.1</a>
     */
    public static let ResetContent = HttpStatus(HttpStatusCode.resetContent, "Reset Content")

    /**
     * {@code 206 Partial Content}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.7">HTTP/1.1</a>
     */
    public static let PartialContent = HttpStatus(HttpStatusCode.partialContent, "Partial Content")

    /**
     * {@code 207 Multi-Status}.
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-13">WebDAV</a>
     */
    public static let MultiStatus = HttpStatus(HttpStatusCode.multiStatus, "Multi-Status")

    /**
     * {@code 208 Already Reported}.
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-bind-27#section-7.1">WebDAV Binding Extensions</a>
     */
    public static let AlreadyReported = HttpStatus(HttpStatusCode.alreadyReported, "Already Reported")

    /**
     * {@code 226 IM Used}.
     * @see <a href="http://tools.ietf.org/html/rfc3229#section-10.4.1">Delta encoding in HTTP</a>
     */
    public static let ImUsed = HttpStatus(HttpStatusCode.imUsed, "IM Used")

    // --- 3xx Redirection ---

    /**
     * {@code 300 Multiple Choices}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.1">HTTP/1.1</a>
     */
    public static let MultipleChoices = HttpStatus(HttpStatusCode.multipleChoices, "Multiple Choices")

    /**
     * {@code 301 Moved Permanently}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.2">HTTP/1.1</a>
     */
    public static let MovedPermanently = HttpStatus(HttpStatusCode.movedPermanently, "Moved Permanently")

    /**
     * {@code 302 Found}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.3">HTTP/1.1</a>
     */
    public static let Found = HttpStatus(HttpStatusCode.found, "Found")

//    /**
//     * {@code 302 Moved Temporarily}.
//     * @see <a href="http://tools.ietf.org/html/rfc1945#section-9.3">HTTP/1.0</a>
//     */
//    public static let MovedTemporarily = HttpStatus(HttpStatusCode.MovedTemporarily, "Moved Temporarily")

    /**
     * {@code 303 See Other}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.4">HTTP/1.1</a>
     */
    public static let SeeOther = HttpStatus(HttpStatusCode.seeOther, "See Other")

    /**
     * {@code 304 Not Modified}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.5">HTTP/1.1</a>
     */
    public static let NotModified = HttpStatus(HttpStatusCode.notModified, "Not Modified")

    /**
     * {@code 305 Use Proxy}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.6">HTTP/1.1</a>
     */
    public static let UseProxy = HttpStatus(HttpStatusCode.useProxy, "Use Proxy")

    /**
     * {@code 307 Temporary Redirect}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.8">HTTP/1.1</a>
     */
    public static let TemporaryRedirect = HttpStatus(HttpStatusCode.temporaryRedirect, "Temporary Redirect")

    // --- 4xx Client Error ---

    /**
     * {@code 400 Bad Request}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.1">HTTP/1.1</a>
     */
    public static let BadRequest = HttpStatus(HttpStatusCode.badRequest, "Bad Request")

    /**
     * {@code 401 Unauthorized}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.2">HTTP/1.1</a>
     */
    public static let Unauthorized = HttpStatus(HttpStatusCode.unauthorized, "Unauthorized")

    /**
     * {@code 402 Payment Required}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.3">HTTP/1.1</a>
     */
    public static let PaymentRequired = HttpStatus(HttpStatusCode.paymentRequired, "Payment Required")

    /**
     * {@code 403 Forbidden}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.4">HTTP/1.1</a>
     */
    public static let Forbidden = HttpStatus(HttpStatusCode.forbidden, "Forbidden")

    /**
     * {@code 404 Not Found}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.5">HTTP/1.1</a>
     */
    public static let NotFound = HttpStatus(HttpStatusCode.notFound, "Not Found")

    /**
     * {@code 405 Method Not Allowed}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.6">HTTP/1.1</a>
     */
    public static let MethodNotAllowed = HttpStatus(HttpStatusCode.methodNotAllowed, "Method Not Allowed")

    /**
     * {@code 406 Not Acceptable}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.7">HTTP/1.1</a>
     */
    public static let NotAcceptable = HttpStatus(HttpStatusCode.notAcceptable, "Not Acceptable")

    /**
     * {@code 407 Proxy Authentication Required}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.8">HTTP/1.1</a>
     */
    public static let ProxyAuthenticationRequired = HttpStatus(HttpStatusCode.proxyAuthenticationRequired, "Proxy Authentication Required")

    /**
     * {@code 408 Request Timeout}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.9">HTTP/1.1</a>
     */
    public static let RequestTimeout = HttpStatus(HttpStatusCode.requestTimeout, "Request Time-out")

    /**
     * {@code 409 Conflict}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.10">HTTP/1.1</a>
     */
    public static let Conflict = HttpStatus(HttpStatusCode.conflict, "Conflict")

    /**
     * {@code 410 Gone}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.11">HTTP/1.1</a>
     */
    public static let Gone = HttpStatus(HttpStatusCode.gone, "Gone")

    /**
     * {@code 411 Length Required}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.12">HTTP/1.1</a>
     */
    public static let LengthRequired = HttpStatus(HttpStatusCode.lengthRequired, "Length Required")

    /**
     * {@code 412 Precondition failed}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.13">HTTP/1.1</a>
     */
    public static let PreconditionFailed = HttpStatus(HttpStatusCode.preconditionFailed, "Precondition Failed")

    /**
     * {@code 413 Request Entity Too Large}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.14">HTTP/1.1</a>
     */
    public static let RequestEntityTooLarge = HttpStatus(HttpStatusCode.requestEntityTooLarge, "Request Entity Too Large")

    /**
     * {@code 414 Request-URI Too Long}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.15">HTTP/1.1</a>
     */
    public static let RequestUriTooLong = HttpStatus(HttpStatusCode.requestUriTooLong, "Request-URI Too Large")

    /**
     * {@code 415 Unsupported Media Type}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.16">HTTP/1.1</a>
     */
    public static let UnsupportedMediaType = HttpStatus(HttpStatusCode.unsupportedMediaType, "Unsupported Media Type")

    /**
     * {@code 416 Requested Range Not Satisfiable}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.17">HTTP/1.1</a>
     */
    public static let RequestedRangeNotSatisfiable = HttpStatus(HttpStatusCode.requestedRangeNotSatisfiable, "Requested range not satisfiable")

    /**
     * {@code 417 Expectation Failed}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.18">HTTP/1.1</a>
     */
    public static let ExpectationFailed = HttpStatus(HttpStatusCode.expectationFailed, "Expectation Failed")

    /**
     * {@code 419 Insufficient Space on Resource}.
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-protocol-05#section-10.4">WebDAV Draft</a>
     */
    public static let InsufficientSpaceOnResource = HttpStatus(HttpStatusCode.insufficientSpaceOnResource, "Insufficient Space On Resource")

    /**
     * {@code 420 Method Failure}.
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-protocol-05#section-10.5">WebDAV Draft</a>
     */
    public static let MethodFailure = HttpStatus(HttpStatusCode.methodFailure, "Method Failure")

    /**
     * {@code 421 Destination Locked}.
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-protocol-05#section-10.6">WebDAV Draft</a>
     */
    public static let DestinationLocked = HttpStatus(HttpStatusCode.destinationLocked, "Destination Locked")

    /**
     * {@code 422 Unprocessable Entity}.
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-11.2">WebDAV</a>
     */
    public static let UnprocessableEntity = HttpStatus(HttpStatusCode.unprocessableEntity, "Unprocessable Entity")

    /**
     * {@code 423 Locked}.
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-11.3">WebDAV</a>
     */
    public static let Locked = HttpStatus(HttpStatusCode.locked, "Locked")

    /**
     * {@code 424 Failed Dependency}.
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-11.4">WebDAV</a>
     */
    public static let FailedDependency = HttpStatus(HttpStatusCode.failedDependency, "Failed Dependency")

    /**
     * {@code 426 Upgrade Required}.
     * @see <a href="http://tools.ietf.org/html/rfc2817#section-6">Upgrading to TLS Within HTTP/1.1</a>
     */
    public static let UpgradeRequired = HttpStatus(HttpStatusCode.upgradeRequired, "Upgrade Required")

    /**
     * {@code 428 Precondition Required}.
     * @see <a href="http://tools.ietf.org/html/rfc6585#section-3">Additional HTTP Status Codes</a>
     */
    public static let PreconditionRequired = HttpStatus(HttpStatusCode.preconditionRequired, "Precondition Required")

    /**
     * {@code 429 Too Many Requests}.
     * @see <a href="http://tools.ietf.org/html/rfc6585#section-4">Additional HTTP Status Codes</a>
     */
    public static let TooManyRequests = HttpStatus(HttpStatusCode.tooManyRequests, "Too Many Requests")

    /**
     * {@code 431 Request Header Fields Too Large}.
     * @see <a href="http://tools.ietf.org/html/rfc6585#section-5">Additional HTTP Status Codes</a>
     */
    public static let RequestHeaderFieldsTooLarge = HttpStatus(HttpStatusCode.requestHeaderFieldsTooLarge, "Request Header Fields Too Large")

    /**
     * {@code 440 Login Time-out}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Internet_Information_Services">Internet Information Services</a>
     */
    public static let LoginTimeOut = HttpStatus(HttpStatusCode.loginTimeOut, "Login Time-out")

    /**
     * {@code 444 No Response}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    public static let NoResponse = HttpStatus(HttpStatusCode.noResponse, "No Response")

    /**
     * {@code 449 Retry With}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Internet_Information_Services">Internet Information Services</a>
     */
    public static let RetryWith = HttpStatus(HttpStatusCode.retryWith, "Retry With")

    /**
     * {@code 451 Redirect}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Internet_Information_Services">Internet Information Services</a>
     */
    public static let Redirect = HttpStatus(HttpStatusCode.redirect, "Redirect")

    /**
     * {@code 495 SSL Certificate Error}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    public static let SslCertificateError = HttpStatus(HttpStatusCode.sslCertificateError, "SSL Certificate Error")

    /**
     * {@code 496 SSL Certificate Required}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    public static let SslCertificateRequired = HttpStatus(HttpStatusCode.sslCertificateRequired, "SSL Certificate Required")

    /**
     * {@code 497 HTTP Request Sent to HTTPS Port}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    public static let HttpRequestSentToHttpsPort = HttpStatus(HttpStatusCode.httpRequestSentToHttpsPort, "HTTP Request Sent to HTTPS Port")

    /**
     * {@code 499 Client Closed Request}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    public static let ClientClosedRequest = HttpStatus(HttpStatusCode.clientClosedRequest, "Client Closed Request")

    // --- 5xx Server Error ---

    /**
     * {@code 500 Internal Server Error}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.1">HTTP/1.1</a>
     */
    public static let InternalServerError = HttpStatus(HttpStatusCode.internalServerError, "Internal Server Error")

    /**
     * {@code 501 Not Implemented}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.2">HTTP/1.1</a>
     */
    public static let NotImplemented = HttpStatus(HttpStatusCode.notImplemented, "Not Implemented")

    /**
     * {@code 502 Bad Gateway}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.3">HTTP/1.1</a>
     */
    public static let BadGateway = HttpStatus(HttpStatusCode.badGateway, "Bad Gateway")

    /**
     * {@code 503 Service Unavailable}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.4">HTTP/1.1</a>
     */
    public static let ServiceUnavailable = HttpStatus(HttpStatusCode.serviceUnavailable, "Service Unavailable")

    /**
     * {@code 504 Gateway Timeout}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.5">HTTP/1.1</a>
     */
    public static let GatewayTimeout = HttpStatus(HttpStatusCode.gatewayTimeout, "Gateway Time-out")

    /**
     * {@code 505 HTTP Version Not Supported}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.6">HTTP/1.1</a>
     */
    public static let HttpVersionNotSupported = HttpStatus(HttpStatusCode.httpVersionNotSupported, "HTTP Version not supported")

    /**
     * {@code 506 Variant Also Negotiates}
     * @see <a href="http://tools.ietf.org/html/rfc2295#section-8.1">Transparent Content Negotiation</a>
     */
    public static let VariantAlsoNegotiates = HttpStatus(HttpStatusCode.variantAlsoNegotiates, "Variant Also Negotiates")

    /**
     * {@code 507 Insufficient Storage}
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-11.5">WebDAV</a>
     */
    public static let InsufficientStorage = HttpStatus(HttpStatusCode.insufficientStorage, "Insufficient Storage")

    /**
     * {@code 508 Loop Detected}
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-bind-27#section-7.2">WebDAV Binding Extensions</a>
      */
    public static let LoopDetected = HttpStatus(HttpStatusCode.loopDetected, "Loop Detected")

    /**
     * {@code 510 Not Extended}
     * @see <a href="http://tools.ietf.org/html/rfc2774#section-7">HTTP Extension Framework</a>
     */
    public static let NotExtended = HttpStatus(HttpStatusCode.notExtended, "Not Extended")

    /**
     * {@code 511 Network Authentication Required}.
     * @see <a href="http://tools.ietf.org/html/rfc6585#section-6">Additional HTTP Status Codes</a>
     */
    public static let NetworkAuthenticationRequired = HttpStatus(HttpStatusCode.networkAuthenticationRequired, "Network Authentication Required")

    /**
     * {@code 520 Unknown Error}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    public static let UnknownError = HttpStatus(HttpStatusCode.unknownError, "Unknown Error")

    /**
     * {@code 521 Web Server Is Down}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    public static let WebServerIsDown = HttpStatus(HttpStatusCode.webServerIsDown, "Web Server Is Down")

    /**
     * {@code 522 Connection Timed Out}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    public static let ConnectionTimedOut = HttpStatus(HttpStatusCode.connectionTimedOut, "Connection Timed Out")

    /**
     * {@code 523 Origin Is Unreachable}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    public static let OriginIsUnreachable = HttpStatus(HttpStatusCode.originIsUnreachable, "Origin Is Unreachable")

    /**
     * {@code 524 A Timeout Occurred}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    public static let ATimeoutOccurred = HttpStatus(HttpStatusCode.aTimeoutOccurred, "A Timeout Occurred")

    /**
     * {@code 525 SSL Handshake Failed}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    public static let SslHandshakeFailed = HttpStatus(HttpStatusCode.sslHandshakeFailed, "SSL Handshake Failed")

    /**
     * {@code 526 Invalid SSL Certificate}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    public static let InvalidSslCertificate = HttpStatus(HttpStatusCode.invalidSslCertificate, "Invalid SSL Certificate")

    /**
     * {@code 527 Railgun Error}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    public static let RailgunError = HttpStatus(HttpStatusCode.railgunError, "Railgun Error")
}

// ----------------------------------------------------------------------------
