// ----------------------------------------------------------------------------
//
//  StandardCharsets.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

class StandardCharsets: CharsetProvider
{
// MARK: - Construction

    init() {
        super.init(aliases: Inner.Aliases, classes: Inner.Classes)
    }

// MARK: - Constants

    fileprivate struct Inner
    {
        // Maps alias names to canonical names
        static let Aliases: [String: String] =
        {
            var output = [String: String]()
            for (name, type) in Inner.Classes
            {
                if let charset = type.init() as? Charset
                {
                    for alias in charset.aliases {
                        output[alias.lowercased()] = name
                    }
                }
            }

            // Done
            return output
        }()

        // Maps canonical names to class names
        static let Classes: [String: NSObject.Type] =
        {
            return [
                Charset.US_ASCII.Const.Name: Charset.US_ASCII.self,

                Charset.ISO_8859_1.Const.Name: Charset.ISO_8859_1.self,
                Charset.ISO_8859_2.Const.Name: Charset.ISO_8859_2.self,

                Charset.UTF_8.Const.Name: Charset.UTF_8.self,

                Charset.UTF_16.Const.Name: Charset.UTF_16.self,
                Charset.UTF_16BE.Const.Name: Charset.UTF_16BE.self,
                Charset.UTF_16LE.Const.Name: Charset.UTF_16LE.self,

                Charset.UTF_32.Const.Name: Charset.UTF_32.self,
                Charset.UTF_32BE.Const.Name: Charset.UTF_32BE.self,
                Charset.UTF_32LE.Const.Name: Charset.UTF_32LE.self,

                Charset.WINDOWS_1250.Const.Name: Charset.WINDOWS_1250.self,
                Charset.WINDOWS_1251.Const.Name: Charset.WINDOWS_1251.self,
                Charset.WINDOWS_1252.Const.Name: Charset.WINDOWS_1252.self,
                Charset.WINDOWS_1253.Const.Name: Charset.WINDOWS_1253.self,
                Charset.WINDOWS_1254.Const.Name: Charset.WINDOWS_1254.self,
            ]
        }()
    }

}

// ----------------------------------------------------------------------------
