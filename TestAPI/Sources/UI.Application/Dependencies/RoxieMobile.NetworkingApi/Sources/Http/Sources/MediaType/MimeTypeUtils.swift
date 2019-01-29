// ----------------------------------------------------------------------------
//
//  AbstractAuthenticationRequest.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

public final class MimeTypeUtils: NonCreatable
{
// MARK: - Functions

    /**
     * Parse the given String into a single {@code MimeType}.
     * @param mimeType the string to parse
     * @return the mime type
     * @throws InvalidMimeTypeException if the string cannot be parsed
     */
    public class func parseMimeType(_ mimeType: String, error: NSErrorPointer = nil) -> MimeType?
    {
        if mimeType.isEmpty
        {
            setError(error, failureReason: "'mimeType' must not be empty")
            return nil
        }

        let parts = mimeType.split { $0 == ";" }.map { String($0) }

        var fullType = parts[0].trimmingCharacters(in: CharacterSet.whitespaces)
        // java.net.HttpURLConnection returns a *; q=.2 Accept header
        if (fullType == MimeType.WildcardType) {
            fullType = "*/*"
        }

        let subRange: Range<String.Index>? = fullType.range(of: "/")
        if (subRange == nil)
        {
            setError(error, failureReason: "Does not contain ‘/’")
            return nil
        }

        if (subRange!.upperBound == fullType.endIndex)
        {
            setError(error, failureReason: "Does not contain subtype after ‘/’")
            return nil
        }

        let type = String(fullType[..<subRange!.lowerBound])
        let subtype = String(fullType[fullType.index(after: subRange!.lowerBound)...])
        if (type == MimeType.WildcardType) && (subtype != MimeType.WildcardType)
        {
            setError(error, failureReason: "Wildcard type is legal only in ‘*/*’ (all mime types)")
            return nil
        }

        var parameters = [String: String]()
        if (parts.count > 1)
        {
            for parameter in parts
            {
                if let eqIndex = parameter.range(of: "=")
                {
                    let attribute = String(parameter[..<eqIndex.lowerBound]).trim()
                    let value = String(parameter[parameter.index(after: eqIndex.lowerBound)...]).trim()
                    parameters[attribute] = value
                }
            }
        }

        let mimeType = MimeType(type: type, subtype: subtype, params: parameters, error: error)

        // Done
        return mimeType
    }

//    /**
//     * Parse the given, comma-separated string into a list of {@code MimeType} objects.
//     * @param mimeTypes the string to parse
//     * @return the list of mime types
//     * @throws IllegalArgumentException if the string cannot be parsed
//     */
//    public static List<MimeType> parseMimeTypes(String mimeTypes) {
//        if (!StringUtils.hasLength(mimeTypes)) {
//            return Collections.emptyList();
//        }
//        String[] tokens = mimeTypes.split(",\\s*");
//        List<MimeType> result = new ArrayList<MimeType>(tokens.length);
//        for (String token : tokens) {
//            result.add(parseMimeType(token));
//        }
//        return result;
//    }

    /**
     * Return a string representation of the given list of {@code MimeType} objects.
     * @param mimeTypes the list of mime types
     * @return the string mime types
     */
    public class func toString(mimeTypes: [MimeType]) -> String {
        return mimeTypes.map{ $0.description }.joined(separator: ", ")
    }

//    /**
//     * Sorts the given list of {@code MimeType} objects by specificity.
//     * <p>Given two mime types:
//     * <ol>
//     * <li>if either mime type has a {@linkplain MimeType#isWildcardType() wildcard type},
//     * then the mime type without the wildcard is ordered before the other.</li>
//     * <li>if the two mime types have different {@linkplain MimeType#getType() types},
//     * then they are considered equal and remain their current order.</li>
//     * <li>if either mime type has a {@linkplain MimeType#isWildcardSubtype() wildcard subtype}
//     * , then the mime type without the wildcard is sorted before the other.</li>
//     * <li>if the two mime types have different {@linkplain MimeType#getSubtype() subtypes},
//     * then they are considered equal and remain their current order.</li>
//     * <li>if the two mime types have a different amount of
//     * {@linkplain MimeType#getParameter(String) parameters}, then the mime type with the most
//     * parameters is ordered before the other.</li>
//     * </ol>
//     * <p>For example: <blockquote>audio/basic &lt; audio/_* &lt; *&#047;*</blockquote>
//     * <blockquote>audio/basic;level=1 &lt; audio/basic</blockquote>
//     * <blockquote>audio/basic == text/html</blockquote> <blockquote>audio/basic ==
//     * audio/wave</blockquote>
//     * @param mimeTypes the list of mime types to be sorted
//     * @see <a href="http://tools.ietf.org/html/rfc7231#section-5.3.2">HTTP 1.1: Semantics
//     * and Content, section 5.3.2</a>
//     */
//    public static void sortBySpecificity(List<MimeType> mimeTypes) {
//        Assert.notNull(mimeTypes, "'mimeTypes' must not be null");
//        if (mimeTypes.size() > 1) {
//            Collections.sort(mimeTypes, SPECIFICITY_COMPARATOR);
//        }
//    }

//    /**
//     * Comparator used by {@link #sortBySpecificity(List)}.
//     */
//    public static final Comparator<MimeType> SPECIFICITY_COMPARATOR = new SpecificityComparator<MimeType>();

// MARK: - Private Functions

    fileprivate class func setError(_ error: NSErrorPointer, failureReason: String, errorCode: Int = -1) {
        error?.pointee = NSError(domain: "InvalidMimeTypeError", code: errorCode, userInfo: [NSLocalizedDescriptionKey: failureReason])
    }

// MARK: - Inner Types

    /// Public constant media type that includes all media ranges (i.e. "&#42;/&#42;").
    public static let All = MimeType.valueOf(AllValue)!
    public static let AllValue = "*/*"

    /// Public constant media type for {@code application/atom+xml}.
    public static let ApplicationAtomXml = MimeType.valueOf(ApplicationAtomXmlValue)!
    public static let ApplicationAtomXmlValue = "application/atom+xml"

    /// Public constant media type for {@code application/x-www-form-urlencoded}.
    public static let ApplicationFormUrlencoded = MimeType.valueOf(ApplicationFormUrlencodedValue)!
    public static let ApplicationFormUrlencodedValue = "application/x-www-form-urlencoded"

    /// Public constant media type for {@code application/json}.
    public static let ApplicationJson = MimeType.valueOf(ApplicationJsonValue)!
    public static let ApplicationJsonValue = "application/json"

    /// Public constant media type for {@code application/octet-stream}.
    public static let ApplicationOctetStream = MimeType.valueOf(ApplicationOctetStreamValue)!
    public static let ApplicationOctetStreamValue = "application/octet-stream"

    /// Public constant media type for {@code application/xhtml+xml}.
    public static let ApplicationXhtmlXml = MimeType.valueOf(ApplicationXhtmlXmlValue)!
    public static let ApplicationXhtmlXmlValue = "application/xhtml+xml"

    /// Public constant media type for {@code application/xml}.
    public static let ApplicationXml = MimeType.valueOf(ApplicationXmlValue)!
    public static let ApplicationXmlValue = "application/xml"

    /// Public constant media type for {@code image/gif}.
    public static let ImageGif = MimeType.valueOf(ImageGifValue)!
    public static let ImageGifValue = "image/gif"

    /// Public constant media type for {@code image/jpeg}.
    public static let ImageJpeg = MimeType.valueOf(ImageJpegValue)!
    public static let ImageJpegValue = "image/jpeg"

    /// Public constant media type for {@code image/png}.
    public static let ImagePng = MimeType.valueOf(ImagePngValue)!
    public static let ImagePngValue = "image/png"

    /// Public constant media type for {@code multipart/form-data}.
    public static let MultipartFormData = MimeType.valueOf(MultipartFormDataValue)!
    public static let MultipartFormDataValue = "multipart/form-data"

    /// Public constant media type for {@code text/html}.
    public static let TextHtml = MimeType.valueOf(TextHtmlValue)!
    public static let TextHtmlValue = "text/html"

    /// Public constant media type for {@code text/plain}.
    public static let TextPlain = MimeType.valueOf(TextPlainValue)!
    public static let TextPlainValue = "text/plain"

    /// Public constant media type for {@code text/xml}.
    public static let TextXml = MimeType.valueOf(TextXmlValue)!
    public static let TextXmlValue = "text/xml"

}

// ----------------------------------------------------------------------------
