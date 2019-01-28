// ----------------------------------------------------------------------------
//
//  BasicHttpCookieStore.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

//import DispatchFramework
import Foundation
////import SwiftCommonsConcurrent
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

open class BasicHttpCookieStore: HTTPCookieStorage
{
// MARK: - Construction

    public init(cookies: [AnyObject]?) {
        super.init()

        // Init instance variables
        self.cookieStore = extractCookies(cookies ?? [AnyObject]())
    }

    public override init() {
        super.init()
    }

// MARK: - Properties

    open override var cookies: [HTTPCookie]? {
        return Array(self.cookieStore.values) as? [HTTPCookie]
    }

// MARK: - Functions

    open override func setCookie(_ cookie: HTTPCookie) {
        add(cookie)
    }

    open override func setCookies(_ cookies: [HTTPCookie], for URL: URL?, mainDocumentURL: URL?)
    {
        if (self.cookieAcceptPolicy == .never) { return }

        var changed = false

        // Add Cookies to the CookieStore
        for object in cookies
        {
            let cookie = object
            
            if (self.cookieAcceptPolicy == .onlyFromMainDocumentDomain) && (mainDocumentURL != nil)
            {
                let domain = cookie.domain
                let host = mainDocumentURL!.host
                
                if (host != nil) && ((domain.hasPrefix(".") && host!.hasSuffix(domain)) || (host! == domain)) {
                    changed = add(cookie, notify: false) || changed
                }
            }
            else {
                changed = add(cookie, notify: false) || changed
            }
        }

        // Post notification if needed
        if changed {
            postCookiesChangedNotification()
        }
    }

    open override func cookies(for URL: URL) -> [HTTPCookie]? {
        return get(URL) as? [HTTPCookie]
    }

    open override func deleteCookie(_ cookie: HTTPCookie) {
        remove(cookie)
    }

    open override func removeCookies(since date: Date)
    {
        // NOTE: Shallow copy
        let cookies = self.cookieStore
        var changed = false

        // Remove NON expired HTTP cookies only
        for (_, cookie) in cookies
        {
            if !cookie.isExpired(date) {
                changed = remove(cookie, notify: false) || changed
            }
        }

        // Post notification if needed
        if changed {
            postCookiesChangedNotification()
        }
    }

    @available(iOS, introduced: 5.0)
    open override func sortedCookies(using sortOrder: [NSSortDescriptor]) -> [HTTPCookie] {
        let cookies = (Array(self.cookieStore.values) as NSArray).sortedArray(using: sortOrder)
        return (cookies as? [HTTPCookie]) ?? [HTTPCookie]()
    }

    @available(iOS, introduced: 8.0)
    open override func storeCookies(_ cookies: [HTTPCookie], for task: URLSessionTask) {
        setCookies(cookies, for: task.currentRequest?.url, mainDocumentURL: nil)
    }

    @available(iOS, introduced: 8.0)
    open override func getCookiesFor(_ task: URLSessionTask, completionHandler: (@escaping ([HTTPCookie]?) -> Void))
    {
        var result: [HTTPCookie]?

        if let url = task.currentRequest?.url {
            result = cookies(for: url)
        }

        completionHandler(result)
    }

// MARK: - Private Functions

    fileprivate func extractCookies(_ objects: [AnyObject]) -> [String: HttpCookieProtocol]
    {
        var cookieStore = [String: HttpCookieProtocol]()

        // Look up for valid HTTP cookies only
        for object in objects
        {
            if let cookie = HTTPCookie(object as? HttpCookieProtocol), !cookie.isExpired() {
                cookieStore[key(cookie)] = cookie
            }
        }

        // Done
        return cookieStore
    }

    fileprivate func key(_ cookie: HttpCookieProtocol) -> String
    {
        let path = cookie.path
        return (cookie.domain + (":" + path) + ":" + cookie.name)
    }

// MARK: - Variables

    fileprivate var cookieStore = [String: HttpCookieProtocol]()

}

// ----------------------------------------------------------------------------
// MARK: - @protocol HttpCookieStore
// ----------------------------------------------------------------------------

extension BasicHttpCookieStore
{
// MARK: - Functions

    /**
     * Saves a HTTP cookie to this store.
     */
    public func add(_ cookie: HttpCookieProtocol) {
        add(cookie, notify: true)
    }

    /**
     * Retrieves cookies that match the specified URI.
     *
     * @returns not expired cookies.
     */
    public func get(_ url: URL) -> [HttpCookieProtocol]
    {
        var cookies = [HttpCookieProtocol]()

        // Search for corresponded HTTP cookies only
        for (_, cookie) in self.cookieStore
        {
            if cookie.matchesURL(url) {
                cookies.append(cookie)
            }
        }

        // Done
        return cookies
    }

    /**
     * Remove the specified cookie from the store.
     *
     * @returns TRUE if the specified cookie is contained in this store and removed successfully.
     */
    @discardableResult public func remove(_ cookie: HttpCookieProtocol) -> Bool {
        return remove(cookie, notify: true)
    }

    /**
     * Clear this cookie store.
     *
     * @returns TRUE if any cookies were removed as a result of this call.
     */
    @discardableResult public func removeAll() -> Bool
    {
        let result = !self.cookieStore.isEmpty
        if  result
        {
            // Remove all Cookies from CookieStore
            self.cookieStore.removeAll()

            // Post notification
            postCookiesChangedNotification()
        }

        // Done
        return result
    }

// MARK: - Private Functions

    /**
     * Saves a HTTP cookie to this store AND posts notification if needed.
     */
    @discardableResult fileprivate func add(_ cookie: HttpCookieProtocol, notify: Bool) -> Bool
    {
        if (self.cookieAcceptPolicy == .never) { return false }

        // Add new Cookie to the CookieStore
        self.cookieStore[key(cookie)] = cookie

        // Post notification if needed
        if notify {
            postCookiesChangedNotification()
        }

        // Done
        return true
    }

    /**
     * Removes the specified cookie from the store AND posts notification if needed.
     *
     * @returns TRUE if the specified cookie is contained in this store and removed successfully.
     */
    fileprivate func remove(_ cookie: HttpCookieProtocol, notify: Bool) -> Bool
    {
        let changed = (self.cookieStore.removeValue(forKey: key(cookie)) != nil)

        // Post notification if needed
        if changed && notify {
            postCookiesChangedNotification()
        }

        // Done
        return changed
    }

    /**
     * Posts notification NSHTTPCookieManagerCookiesChangedNotification.
     */
    fileprivate func postCookiesChangedNotification()
    {
        weak var instance = self

        // .. on main thread
        Dispatch.sync(Queue.main)
        {
            var notificationCenter: NotificationCenter!
#if os(iOS)
            notificationCenter = NotificationCenter.default
#elseif os(OSX)
            notificationCenter = NSDistributedNotificationCenter.defaultCenter()
#else
            mdc_fatalException("It's that mythical new Apple product.")
#endif
            // Post notification
            notificationCenter.post(name: NSNotification.Name.NSHTTPCookieManagerCookiesChanged, object: instance)
        }
    }

}

// ----------------------------------------------------------------------------
// MARK: - @protocol Printable, DebugPrintable
// ----------------------------------------------------------------------------

extension BasicHttpCookieStore // : CustomDebugStringConvertible
{
// MARK: - Properties

    open override var description: String
    {
        var output = ""

        for cookie in self.cookieStore.values {
            output += "  " + cookie.description + "\n"
        }

        if !output.isEmpty {
            output = "cookies:\n" + output
        }

        output = "<\(Roxie.typeName(of: self)) cookies count:\(self.cookieStore.count) \(output)>"

        // Done
        return output
    }

    open override var debugDescription: String {
        return self.description
    }

}

// ----------------------------------------------------------------------------
