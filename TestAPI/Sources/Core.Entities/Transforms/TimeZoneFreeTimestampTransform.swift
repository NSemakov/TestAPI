// ----------------------------------------------------------------------------
//
//  TimeZoneFreeTimestampTransform.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
import SwiftCommonsData

// ----------------------------------------------------------------------------

public final class TimeZoneFreeTimestampTransform: DateFormatterTransform
{
// MARK: - Construction

    public static let shared = TimeZoneFreeTimestampTransform()

    private init() {
        super.init(dateFormatter: TimeZoneFreeTimestampTransform.timestampFormatter)
    }

// MARK: - Private Properties

    private static var timestampFormatter: DateFormatter {
        struct Singleton
        {
            static let formatter: DateFormatter = {
                let object = DateFormatter()

                // Init instance
                object.dateFormat = Inner.TimestampFormat
                object.formatterBehavior = .behavior10_4
                object.locale = Locale(identifier: Inner.LocaleIdentifier)
                object.timeZone = TimeZone.current

                // Done
                return object
            }()
        }

        // Done
        return Singleton.formatter
    }

// MARK: - Constants

    private struct Inner
    {
        static let TimestampFormat = "yyyy-MM-dd'T'HH:mm:ss"
        static let LocaleIdentifier = "en_US_POSIX"
    }
}

// ----------------------------------------------------------------------------
