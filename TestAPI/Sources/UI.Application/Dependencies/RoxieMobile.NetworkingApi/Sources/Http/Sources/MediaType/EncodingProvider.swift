// ----------------------------------------------------------------------------
//
//  EncodingProvider.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

//import SwiftCommonsLang

// ----------------------------------------------------------------------------

open class EncodingProvider: NonCreatable
{
// MARK: - Functions

    /**
     * Retrieves a encoding for the given charset.
     *
     * @param  charset
     *         The requested charset.
     *
     * @return  A encoding object for the requested charset, or NIL
     *          if the named charset is not supported by this provider.
     *
     * @throws  FatalError
     *          If no support for the named charset is available
     */
    open class func encodingForCharset(_ charset: Charset) -> String.Encoding? {
        return encodingForCharsetName(charset.name)
    }

    /**
     * Retrieves a encoding for the given charset name. </p>
     *
     * @param  charsetName
     *         The name of the requested charset; may be either
     *         a canonical name or an alias.
     *
     * @return  A charset object for the named charset, or <tt>null</tt>
     *          if the named charset is not supported by this provider.
     *
     * @throws  FatalError
     *          If no support for the named charset is available
     */
    open class func encodingForCharsetName(_ charsetName: String) -> String.Encoding?
    {
        var encoding: String.Encoding?

        switch (charsetName.lowercased())
        {
            case Charset.US_ASCII.Const.Name:
                encoding = String.Encoding.ascii

            case Charset.ISO_8859_1.Const.Name:
                encoding = String.Encoding.isoLatin1
            case Charset.ISO_8859_2.Const.Name:
                encoding = String.Encoding.isoLatin2

            case Charset.UTF_8.Const.Name:
                encoding = String.Encoding.utf8

            case Charset.UTF_16.Const.Name:
                encoding = String.Encoding.utf16
            case Charset.UTF_16BE.Const.Name:
                encoding = String.Encoding.utf16BigEndian
            case Charset.UTF_16LE.Const.Name:
                encoding = String.Encoding.utf16LittleEndian

            case Charset.UTF_32.Const.Name:
                encoding = String.Encoding.utf32
            case Charset.UTF_32BE.Const.Name:
                encoding = String.Encoding.utf32BigEndian
            case Charset.UTF_32LE.Const.Name:
                encoding = String.Encoding.utf32LittleEndian

            case Charset.WINDOWS_1250.Const.Name:
                encoding = String.Encoding.windowsCP1250
            case Charset.WINDOWS_1251.Const.Name:
                encoding = String.Encoding.windowsCP1251
            case Charset.WINDOWS_1252.Const.Name:
                encoding = String.Encoding.windowsCP1252
            case Charset.WINDOWS_1253.Const.Name:
                encoding = String.Encoding.windowsCP1253
            case Charset.WINDOWS_1254.Const.Name:
                encoding = String.Encoding.windowsCP1254

            default:
                // Terminate application with runtime exception
                Roxie.fatalError("‘\(charsetName)’ charset is not supported.")
        }

        return encoding
    }
}

// ----------------------------------------------------------------------------
