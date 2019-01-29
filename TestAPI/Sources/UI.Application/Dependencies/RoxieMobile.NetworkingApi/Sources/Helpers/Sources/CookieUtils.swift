// ----------------------------------------------------------------------------
//
//  CookieUtils.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHttp
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

public final class CookieUtils: NonCreatable
{
// MARK: - Functions

    public class func cookie(_ cookieStore: HttpCookieStore, name: String) -> HTTPCookie?
    {
        var outCookie: HTTPCookie?

        // Search for Cookie with requested name
        for cookie in (cookieStore.cookies ?? []) {
            if cookie.name.lowercased() == name.lowercased() {
                outCookie = cookie
                break
            }
        }

        // Done
        return outCookie
    }

    public class func cookie(_ cookies: [HttpCookieProtocol], name: String) -> HTTPCookie?
    {
        var outCookie: HTTPCookie?

        // Search for Cookie with requested name
        for cookie in cookies {
            if cookie.name.lowercased() == name.lowercased() {
                outCookie = HTTPCookie(cookie)
                break
            }
        }

        // Done
        return outCookie
    }

    public class func isNullOrExpired(_ cookie: HTTPCookie?, offsetInSeconds offset: TimeInterval) -> Bool
    {
        guard let cookie = cookie else {
            return true
        }

        guard let expiresDate = cookie.expiresDate else {
            // From Apple documentation: nil if there is no specific expiration date such as in the case of “session-only” cookies
            // @link: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSHTTPCookie_Class
            return false
        }

        // Check if cookie has expired
        return (Date(timeIntervalSinceNow: offset).compare(expiresDate) == .orderedDescending)
    }

}

// ----------------------------------------------------------------------------
