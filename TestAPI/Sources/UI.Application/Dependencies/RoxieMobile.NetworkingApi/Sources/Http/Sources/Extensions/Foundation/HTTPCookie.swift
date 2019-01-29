// ----------------------------------------------------------------------------
//
//  HTTPCookie.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import SwiftCommonsExtensions

// ----------------------------------------------------------------------------

extension HTTPCookie: HttpCookieProtocol
{
// MARK: - Construction

    public convenience init?(_ cookie: HttpCookieProtocol?)
    {
        let properties = cookie?.properties ?? [HTTPCookiePropertyKey : Any]()
        self.init(properties: properties)

        // Validate instance
        if properties.isEmpty { return nil }
    }

// MARK: - Functions

    /// Reports whether this http cookie has expired according to the time passed in or not.
    public func isExpired(_ date: Date) -> Bool {
        guard let expiresDate = self.expiresDate else {
            return false
        }
        
        return (expiresDate.compare(date) == .orderedAscending)
    }

    /// Reports whether this http cookie has expired or not.
    public func isExpired() -> Bool {
        return isExpired(Date())
    }

    /**
     * Checks if this cookie matches the given URL.
     *
     * Ported from java.net.CookieManager
     * @link http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/8-b132/java/net/CookieManager.java
     */
    public func matchesURL(_ url: URL) -> Bool
    {
        var result = false

        let scheme = (url.scheme?.lowercased() ?? "http")
        let secureLink = (scheme == "https")
        let path = (url.path.isNotEmpty ? url.path : "/")

        repeat {
            // Apply path-matches rule (RFC 2965 sec. 3.3.4) and check for the possible
            // "secure" tag (i.e. don't send "secure" cookies over unsecure links)
            if pathMatches(path, pathToMatchWith: self.path) && (secureLink || !self.isSecure)
            {
                // Enforce httponly attribute
                if (self.isHTTPOnly)
                {
                    let s  = (url.scheme?.lowercased() ?? "")
                    if (s != "http") && (s != "https") {
                        break
                    }
                }

                // Let's check the authorize port list if it exists
                if let ports = self.portList, !ports.isEmpty {
                    var port = url.port

                    if (port == nil) || (port == -1) {
                        port = (scheme == "https") ? 443 : 80
                    }

                    result = (ports as NSArray).contains(port!)
                }
                else {
                    result = true
                }
            }
        }
        while (false)

        // Done
        return result
    }

// MARK: - Private Functions

    /// Path-matches algorithm, as defined by RFC 2965.
    fileprivate func pathMatches(_ path: String?, pathToMatchWith: String?) -> Bool
    {
        if (path == pathToMatchWith) {
            return true
        }
        if (path == nil) || (pathToMatchWith == nil) {
            return false
        }
        if (path!.hasPrefix(pathToMatchWith!)) {
            return true
        }

        return false
    }

}

// ----------------------------------------------------------------------------
