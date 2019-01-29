// ----------------------------------------------------------------------------
//
//  RestApiRoute.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public final class RestApiRoute: NonCreatable
{
// MARK: - Methods

    // GET
    public static func base(_ baseURL: URL) -> HttpRoute {
        return HttpRoute.buildRoute(baseURL)
    }


}
// ----------------------------------------------------------------------------
