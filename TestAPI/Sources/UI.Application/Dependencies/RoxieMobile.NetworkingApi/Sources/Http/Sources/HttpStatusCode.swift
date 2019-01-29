// ----------------------------------------------------------------------------
//
//  HttpStatusCode.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

public enum HttpStatusCode: Int
{
// MARK: - 1xx Informational

    /**
     * {@code 100 Continue}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.1.1">HTTP/1.1</a>
     */
    case `continue` = 100

    /**
     * {@code 101 Switching Protocols}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.1.2">HTTP/1.1</a>
     */
    case switchingProtocols = 101

    /**
     * {@code 102 Processing}.
     * @see <a href="http://tools.ietf.org/html/rfc2518#section-10.1">WebDAV</a>
     */
    case processing = 102

// MARK: - 2xx Success

    /**
     * {@code 200 OK}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.1">HTTP/1.1</a>
     */
    case ok = 200

    /**
     * {@code 201 Created}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.2">HTTP/1.1</a>
     */
    case created = 201

    /**
     * {@code 202 Accepted}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.3">HTTP/1.1</a>
     */
    case accepted = 202

    /**
     * {@code 203 Non-Authoritative Information}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.4">HTTP/1.1</a>
     */
    case nonAuthoritativeInformation = 203

    /**
     * {@code 204 No Content}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.5">HTTP/1.1</a>
     */
    case noContent = 204

    /**
     * {@code 205 Reset Content}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.6">HTTP/1.1</a>
     */
    case resetContent = 205

    /**
     * {@code 206 Partial Content}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.2.7">HTTP/1.1</a>
     */
    case partialContent = 206

    /**
     * {@code 207 Multi-Status}.
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-13">WebDAV</a>
     */
    case multiStatus = 207

    /**
     * {@code 208 Already Reported}.
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-bind-27#section-7.1">WebDAV Binding Extensions</a>
     */
    case alreadyReported = 208

    /**
     * {@code 226 IM Used}.
     * @see <a href="http://tools.ietf.org/html/rfc3229#section-10.4.1">Delta encoding in HTTP</a>
     */
    case imUsed = 226

// MARK: - 3xx Redirection

    /**
     * {@code 300 Multiple Choices}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.1">HTTP/1.1</a>
     */
    case multipleChoices = 300

    /**
     * {@code 301 Moved Permanently}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.2">HTTP/1.1</a>
     */
    case movedPermanently = 301

    /**
     * {@code 302 Found}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.3">HTTP/1.1</a>
     */
    case found = 302

//    /**
//     * {@code 302 Moved Temporarily}.
//     * @see <a href="http://tools.ietf.org/html/rfc1945#section-9.3">HTTP/1.0</a>
//     */
//    case MovedTemporarily = 302

    /**
     * {@code 303 See Other}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.4">HTTP/1.1</a>
     */
    case seeOther = 303

    /**
     * {@code 304 Not Modified}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.5">HTTP/1.1</a>
     */
    case notModified = 304

    /**
     * {@code 305 Use Proxy}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.6">HTTP/1.1</a>
     */
    case useProxy = 305

    /**
     * {@code 307 Temporary Redirect}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.3.8">HTTP/1.1</a>
     */
    case temporaryRedirect = 307

// MARK: - 4xx Client Error

    /**
     * {@code 400 Bad Request}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.1">HTTP/1.1</a>
     */
    case badRequest = 400

    /**
     * {@code 401 Unauthorized}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.2">HTTP/1.1</a>
     */
    case unauthorized = 401

    /**
     * {@code 402 Payment Required}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.3">HTTP/1.1</a>
     */
    case paymentRequired = 402

    /**
     * {@code 403 Forbidden}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.4">HTTP/1.1</a>
     */
    case forbidden = 403

    /**
     * {@code 404 Not Found}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.5">HTTP/1.1</a>
     */
    case notFound = 404

    /**
     * {@code 405 Method Not Allowed}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.6">HTTP/1.1</a>
     */
    case methodNotAllowed = 405

    /**
     * {@code 406 Not Acceptable}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.7">HTTP/1.1</a>
     */
    case notAcceptable = 406

    /**
     * {@code 407 Proxy Authentication Required}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.8">HTTP/1.1</a>
     */
    case proxyAuthenticationRequired = 407

    /**
     * {@code 408 Request Timeout}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.9">HTTP/1.1</a>
     */
    case requestTimeout = 408

    /**
     * {@code 409 Conflict}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.10">HTTP/1.1</a>
     */
    case conflict = 409

    /**
     * {@code 410 Gone}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.11">HTTP/1.1</a>
     */
    case gone = 410

    /**
     * {@code 411 Length Required}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.12">HTTP/1.1</a>
     */
    case lengthRequired = 411

    /**
     * {@code 412 Precondition failed}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.13">HTTP/1.1</a>
     */
    case preconditionFailed = 412

    /**
     * {@code 413 Request Entity Too Large}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.14">HTTP/1.1</a>
     */
    case requestEntityTooLarge = 413

    /**
     * {@code 414 Request-URI Too Long}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.15">HTTP/1.1</a>
     */
    case requestUriTooLong = 414

    /**
     * {@code 415 Unsupported Media Type}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.16">HTTP/1.1</a>
     */
    case unsupportedMediaType = 415

    /**
     * {@code 416 Requested Range Not Satisfiable}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.17">HTTP/1.1</a>
     */
    case requestedRangeNotSatisfiable = 416

    /**
     * {@code 417 Expectation Failed}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.4.18">HTTP/1.1</a>
     */
    case expectationFailed = 417

    /**
     * {@code 419 Insufficient Space on Resource}.
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-protocol-05#section-10.4">WebDAV Draft</a>
     */
    case insufficientSpaceOnResource = 419

    /**
     * {@code 420 Method Failure}.
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-protocol-05#section-10.5">WebDAV Draft</a>
     */
    case methodFailure = 420

    /**
     * {@code 421 Destination Locked}.
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-protocol-05#section-10.6">WebDAV Draft</a>
     */
    case destinationLocked = 421

    /**
     * {@code 422 Unprocessable Entity}.
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-11.2">WebDAV</a>
     */
    case unprocessableEntity = 422

    /**
     * {@code 423 Locked}.
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-11.3">WebDAV</a>
     */
    case locked = 423

    /**
     * {@code 424 Failed Dependency}.
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-11.4">WebDAV</a>
     */
    case failedDependency = 424

    /**
     * {@code 426 Upgrade Required}.
     * @see <a href="http://tools.ietf.org/html/rfc2817#section-6">Upgrading to TLS Within HTTP/1.1</a>
     */
    case upgradeRequired = 426

    /**
     * {@code 428 Precondition Required}.
     * @see <a href="http://tools.ietf.org/html/rfc6585#section-3">Additional HTTP Status Codes</a>
     */
    case preconditionRequired = 428

    /**
     * {@code 429 Too Many Requests}.
     * @see <a href="http://tools.ietf.org/html/rfc6585#section-4">Additional HTTP Status Codes</a>
     */
    case tooManyRequests = 429

    /**
     * {@code 431 Request Header Fields Too Large}.
     * @see <a href="http://tools.ietf.org/html/rfc6585#section-5">Additional HTTP Status Codes</a>
     */
    case requestHeaderFieldsTooLarge = 431

    /**
     * {@code 440 Login Time-out}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Internet_Information_Services">Internet Information Services</a>
     */
    case loginTimeOut = 440

    /**
     * {@code 444 No Response}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    case noResponse = 444

    /**
     * {@code 449 Retry With}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Internet_Information_Services">Internet Information Services</a>
     */
    case retryWith = 449

    /**
     * {@code 451 Redirect}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Internet_Information_Services">Internet Information Services</a>
     */
    case redirect = 451

    /**
     * {@code 495 SSL Certificate Error}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    case sslCertificateError = 495

    /**
     * {@code 496 SSL Certificate Required}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    case sslCertificateRequired = 496

    /**
     * {@code 497 HTTP Request Sent to HTTPS Port}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    case httpRequestSentToHttpsPort = 497

    /**
     * {@code 499 Client Closed Request}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#nginx">nginx</a>
     */
    case clientClosedRequest = 499

// MARK: - 5xx Server Error

    /**
     * {@code 500 Internal Server Error}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.1">HTTP/1.1</a>
     */
    case internalServerError = 500

    /**
     * {@code 501 Not Implemented}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.2">HTTP/1.1</a>
     */
    case notImplemented = 501

    /**
     * {@code 502 Bad Gateway}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.3">HTTP/1.1</a>
     */
    case badGateway = 502

    /**
     * {@code 503 Service Unavailable}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.4">HTTP/1.1</a>
     */
    case serviceUnavailable = 503

    /**
     * {@code 504 Gateway Timeout}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.5">HTTP/1.1</a>
     */
    case gatewayTimeout = 504

    /**
     * {@code 505 HTTP Version Not Supported}.
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-10.5.6">HTTP/1.1</a>
     */
    case httpVersionNotSupported = 505

    /**
     * {@code 506 Variant Also Negotiates}
     * @see <a href="http://tools.ietf.org/html/rfc2295#section-8.1">Transparent Content Negotiation</a>
     */
    case variantAlsoNegotiates = 506

    /**
     * {@code 507 Insufficient Storage}
     * @see <a href="http://tools.ietf.org/html/rfc4918#section-11.5">WebDAV</a>
     */
    case insufficientStorage = 507

    /**
     * {@code 508 Loop Detected}
     * @see <a href="http://tools.ietf.org/html/draft-ietf-webdav-bind-27#section-7.2">WebDAV Binding Extensions</a>
      */
    case loopDetected = 508

    /**
     * {@code 510 Not Extended}
     * @see <a href="http://tools.ietf.org/html/rfc2774#section-7">HTTP Extension Framework</a>
     */
    case notExtended = 510

    /**
     * {@code 511 Network Authentication Required}.
     * @see <a href="http://tools.ietf.org/html/rfc6585#section-6">Additional HTTP Status Codes</a>
     */
    case networkAuthenticationRequired = 511

    /**
     * {@code 520 Unknown Error}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    case unknownError = 520

    /**
     * {@code 521 Web Server Is Down}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    case webServerIsDown = 521

    /**
     * {@code 522 Connection Timed Out}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    case connectionTimedOut = 522

    /**
     * {@code 523 Origin Is Unreachable}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    case originIsUnreachable = 523

    /**
     * {@code 524 A Timeout Occurred}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    case aTimeoutOccurred = 524

    /**
     * {@code 525 SSL Handshake Failed}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    case sslHandshakeFailed = 525

    /**
     * {@code 526 Invalid SSL Certificate}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    case invalidSslCertificate = 526

    /**
     * {@code 527 Railgun Error}.
     * @see <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#Cloudflare">Cloudflare</a>
     */
    case railgunError = 527
}

// ----------------------------------------------------------------------------
