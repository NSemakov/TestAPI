// ----------------------------------------------------------------------------
//
//  MediaType.swift
//
//  @author     Irina Zavilkina <ZavilkinaIB@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

open class MediaType: MimeType
{
// MARK: - Construction

//    /**
//     * Create a new {@code MediaType} for the given primary type.
//     * <p>The {@linkplain #getSubtype() subtype} is set to "&#42;", parameters empty.
//     * @param type the primary type
//     * @throws IllegalArgumentException if any of the parameters contain illegal characters
//     */
//    public convenience init(type: String) {
//        self.init(type)
//    }

//    /**
//     * Create a new {@code MediaType} for the given primary type and subtype.
//     * <p>The parameters are empty.
//     * @param type the primary type
//     * @param subtype the subtype
//     * @throws IllegalArgumentException if any of the parameters contain illegal characters
//     */
//    public convenience init(type: String, subtype: String) {
//        self.init(type, subtype, nil)
//    }

//    /**
//     * Create a new {@code MediaType} for the given type, subtype, and character set.
//     * @param type the primary type
//     * @param subtype the subtype
//     * @param charset the character set
//     * @throws IllegalArgumentException if any of the parameters contain illegal characters
//     */
//    public MediaType(String type, String subtype, Charset charset) {
//        super(type, subtype, charset);
//    }

    /**
     * Create a new {@code MediaType} for the given type, subtype, and quality value.
     * @param type the primary type
     * @param subtype the subtype
     * @param qualityValue the quality value
     * @throws IllegalArgumentException if any of the parameters contain illegal characters
     */
    public convenience init?(type: String, subtype: String, qualityValue: Double) {
        self.init(type: type, subtype: subtype, params: [Inner.ParamQualityFactor: String(format: "%.2f", qualityValue)])
    }

//    /**
//     * Copy-constructor that copies the type and subtype of the given {@code MediaType},
//     * and allows for different parameter.
//     * @param other the other media type
//     * @param parameters the parameters, may be {@code null}
//     * @throws IllegalArgumentException if any of the parameters contain illegal characters
//     */
//    public MediaType(MediaType other, Map<String, String> parameters) {
//        super(other.getType(), other.getSubtype(), parameters);
//    }

//    /**
//     * Create a new {@code MediaType} for the given type, subtype, and parameters.
//     * @param type the primary type
//     * @param subtype the subtype
//     * @param parameters the parameters, may be {@code null}
//     * @throws IllegalArgumentException if any of the parameters contain illegal characters
//     */
//    public MediaType(String type, String subtype, Map<String, String> parameters) {
//        super(type, subtype, parameters);
//    }

// MARK: - Functions

    override func checkParameters(_ attribute: String, _ value: String) -> Bool
    {
        var result = super.checkParameters(attribute, value)
        if (result)
        {
            if (attribute == Inner.ParamQualityFactor)
            {
                let newValue = unquote(value)
                let quality = (newValue as NSString).doubleValue

                result = (quality >= 0.0 && quality <= 1.0)
            }
        }

        // Done
        return result
    }

//    /**
//     * Return the quality value, as indicated by a {@code q} parameter, if any.
//     * Defaults to {@code 1.0}.
//     * @return the quality factory
//     */
//    public double getQualityValue() {
//        String qualityFactory = getParameter(PARAM_QUALITY_FACTOR);
//        return (qualityFactory != null ? Double.parseDouble(unquote(qualityFactory)) : 1D);
//    }

//    /**
//     * Indicate whether this {@code MediaType} includes the given media type.
//     * <p>For instance, {@code text/_*} includes {@code text/plain} and {@code text/html}, and {@code application/_*+xml}
//     * includes {@code application/soap+xml}, etc. This method is <b>not</b> symmetric.
//     * @param other the reference media type with which to compare
//     * @return {@code true} if this media type includes the given media type; {@code false} otherwise
//     */
//    public boolean includes(MediaType other) {
//        return super.includes(other);
//    }

    /**
     * Indicate whether this {@code MediaType} is compatible with the given media type.
     * <p>For instance, {@code text/_*} is compatible with {@code text/plain}, {@code text/html}, and vice versa.
     * In effect, this method is similar to {@link #includes(MediaType)}, except that it <b>is</b> symmetric.
     * @param other the reference media type with which to compare
     * @return {@code true} if this media type is compatible with the given media type; {@code false} otherwise
     */
    open override func isCompatibleWith(_ other: MimeType) -> Bool {
        return super.isCompatibleWith(other)
    }

//    /**
//     * Return a replica of this instance with the quality value of the given MediaType.
//     * @return the same instance if the given MediaType doesn't have a quality value, or a new one otherwise
//     */
//    public MediaType copyQualityValue(MediaType mediaType) {
//        if (!mediaType.getParameters().containsKey(PARAM_QUALITY_FACTOR)) {
//            return this;
//        }
//        Map<String, String> params = new LinkedHashMap<String, String>(getParameters());
//        params.put(PARAM_QUALITY_FACTOR, mediaType.getParameters().get(PARAM_QUALITY_FACTOR));
//        return new MediaType(this, params);
//    }

//    /**
//     * Return a replica of this instance with its quality value removed.
//     * @return the same instance if the media type doesn't contain a quality value, or a new one otherwise
//     */
//    public MediaType removeQualityValue() {
//        if (!getParameters().containsKey(PARAM_QUALITY_FACTOR)) {
//            return this;
//        }
//        Map<String, String> params = new LinkedHashMap<String, String>(getParameters());
//        params.remove(PARAM_QUALITY_FACTOR);
//        return new MediaType(this, params);
//    }

    /**
     * Parse the given String value into a {@code MediaType} object,
     * with this method name following the 'valueOf' naming convention
     * (as supported by {@link org.springframework.core.convert.ConversionService}.
     * @see #parseMediaType(String)
     */
    open override class func valueOf(_ value: String, error: NSErrorPointer = nil) -> MediaType? {
        return parseMediaType(value, error: error)
    }

    /**
     * Parse the given String into a single {@code MediaType}.
     * @param mediaType the string to parse
     * @return the media type
     * @throws InvalidMediaTypeException if the string cannot be parsed
     */
    open class func parseMediaType(_ value: String, error: NSErrorPointer = nil) -> MediaType?
    {
        var mediaType: MediaType?

        if let mimeType = MimeTypeUtils.parseMimeType(value, error: error) {
            mediaType = MediaType(type: mimeType.type, subtype: mimeType.subtype, params: mimeType.parameters)
        }

        return mediaType
    }

    /**
     * Parse the given, comma-separated string into a list of {@code MediaType} objects.
     * <p>This method can be used to parse an Accept or Content-Type header.
     * @param mediaTypes the string to parse
     * @return the list of media types
     * @throws IllegalArgumentException if the string cannot be parsed
     */
    open class func parseMediaTypes(_ value: String, error: NSErrorPointer = nil) -> [MediaType]
    {
        var result: [MediaType] = []

        let tokens = value.components(separatedBy: ",").map{ $0.trim() }
        for token in tokens where !(token.isEmpty)
        {
            if let mediaType = parseMediaType(token, error: error) {
                result.append(mediaType)
            }
        }

        return result
    }

    /**
     * Return a string representation of the given list of {@code MediaType} objects.
     * <p>This method can be used to for an {@code Accept} or {@code Content-Type} header.
     * @param the list of media types
     * @return the string media types
     */
    open class func toString(mediaTypes: [MediaType]) -> String {
        return MimeTypeUtils.toString(mimeTypes: mediaTypes)
    }

//    /**
//     * Sorts the given list of {@code MediaType} objects by specificity.
//     * <p>Given two media types:
//     * <ol>
//     * <li>if either media type has a {@linkplain #isWildcardType() wildcard type}, then the media type without the
//     * wildcard is ordered before the other.</li>
//     * <li>if the two media types have different {@linkplain #getType() types}, then they are considered equal and
//     * remain their current order.</li>
//     * <li>if either media type has a {@linkplain #isWildcardSubtype() wildcard subtype}, then the media type without
//     * the wildcard is sorted before the other.</li>
//     * <li>if the two media types have different {@linkplain #getSubtype() subtypes}, then they are considered equal
//     * and remain their current order.</li>
//     * <li>if the two media types have different {@linkplain #getQualityValue() quality value}, then the media type
//     * with the highest quality value is ordered before the other.</li>
//     * <li>if the two media types have a different amount of {@linkplain #getParameter(String) parameters}, then the
//     * media type with the most parameters is ordered before the other.</li>
//     * </ol>
//     * <p>For example:
//     * <blockquote>audio/basic &lt; audio/* &lt; *&#047;*</blockquote>
//     * <blockquote>audio/* &lt; audio/*;q=0.7; audio/*;q=0.3</blockquote>
//     * <blockquote>audio/basic;level=1 &lt; audio/basic</blockquote>
//     * <blockquote>audio/basic == text/html</blockquote>
//     * <blockquote>audio/basic == audio/wave</blockquote>
//     * @param mediaTypes the list of media types to be sorted
//     * @see <a href="http://tools.ietf.org/html/rfc7231#section-5.3.2">HTTP 1.1: Semantics
//     * and Content, section 5.3.2</a>
//     */
//    public static void sortBySpecificity(List<MediaType> mediaTypes) {
//        Assert.notNull(mediaTypes, "'mediaTypes' must not be null");
//        if (mediaTypes.size() > 1) {
//            Collections.sort(mediaTypes, SPECIFICITY_COMPARATOR);
//        }
//    }

//    /**
//     * Sorts the given list of {@code MediaType} objects by quality value.
//     * <p>Given two media types:
//     * <ol>
//     * <li>if the two media types have different {@linkplain #getQualityValue() quality value}, then the media type
//     * with the highest quality value is ordered before the other.</li>
//     * <li>if either media type has a {@linkplain #isWildcardType() wildcard type}, then the media type without the
//     * wildcard is ordered before the other.</li>
//     * <li>if the two media types have different {@linkplain #getType() types}, then they are considered equal and
//     * remain their current order.</li>
//     * <li>if either media type has a {@linkplain #isWildcardSubtype() wildcard subtype}, then the media type without
//     * the wildcard is sorted before the other.</li>
//     * <li>if the two media types have different {@linkplain #getSubtype() subtypes}, then they are considered equal
//     * and remain their current order.</li>
//     * <li>if the two media types have a different amount of {@linkplain #getParameter(String) parameters}, then the
//     * media type with the most parameters is ordered before the other.</li>
//     * </ol>
//     * @param mediaTypes the list of media types to be sorted
//     * @see #getQualityValue()
//     */
//    public static void sortByQualityValue(List<MediaType> mediaTypes) {
//        Assert.notNull(mediaTypes, "'mediaTypes' must not be null");
//        if (mediaTypes.size() > 1) {
//            Collections.sort(mediaTypes, QUALITY_VALUE_COMPARATOR);
//        }
//    }

//    /**
//     * Sorts the given list of {@code MediaType} objects by specificity as the
//     * primary criteria and quality value the secondary.
//     * @see MediaType#sortBySpecificity(List)
//     * @see MediaType#sortByQualityValue(List)
//     */
//    public static void sortBySpecificityAndQuality(List<MediaType> mediaTypes) {
//        Assert.notNull(mediaTypes, "'mediaTypes' must not be null");
//        if (mediaTypes.size() > 1) {
//            Collections.sort(mediaTypes, new CompoundComparator<MediaType>(
//                    MediaType.SPECIFICITY_COMPARATOR, MediaType.QUALITY_VALUE_COMPARATOR));
//        }
//    }

// MARK: - Inner Types

//    /**
//     * Comparator used by {@link #sortByQualityValue(List)}.
//     */
//    public static final Comparator<MediaType> QUALITY_VALUE_COMPARATOR = new Comparator<MediaType>() {
//
//        @Override
//        public int compare(MediaType mediaType1, MediaType mediaType2) {
//            double quality1 = mediaType1.getQualityValue();
//            double quality2 = mediaType2.getQualityValue();
//            int qualityComparison = Double.compare(quality2, quality1);
//            if (qualityComparison != 0) {
//                return qualityComparison;  // audio/*;q=0.7 < audio/*;q=0.3
//            }
//            else if (mediaType1.isWildcardType() && !mediaType2.isWildcardType()) { // */* < audio/*
//                return 1;
//            }
//            else if (mediaType2.isWildcardType() && !mediaType1.isWildcardType()) { // audio/* > */*
//                return -1;
//            }
//            else if (!mediaType1.getType().equals(mediaType2.getType())) { // audio/basic == text/html
//                return 0;
//            }
//            else { // mediaType1.getType().equals(mediaType2.getType())
//                if (mediaType1.isWildcardSubtype() && !mediaType2.isWildcardSubtype()) { // audio/* < audio/basic
//                    return 1;
//                }
//                else if (mediaType2.isWildcardSubtype() && !mediaType1.isWildcardSubtype()) { // audio/basic > audio/*
//                    return -1;
//                }
//                else if (!mediaType1.getSubtype().equals(mediaType2.getSubtype())) { // audio/basic == audio/wave
//                    return 0;
//                }
//                else {
//                    int paramsSize1 = mediaType1.getParameters().size();
//                    int paramsSize2 = mediaType2.getParameters().size();
//                    return (paramsSize2 < paramsSize1 ? -1 : (paramsSize2 == paramsSize1 ? 0 : 1)); // audio/basic;level=1 < audio/basic
//                }
//            }
//        }
//    };

//    /**
//     * Comparator used by {@link #sortBySpecificity(List)}.
//     */
//    public static final Comparator<MediaType> SPECIFICITY_COMPARATOR = new SpecificityComparator<MediaType>() {
//
//        @Override
//        protected int compareParameters(MediaType mediaType1, MediaType mediaType2) {
//            double quality1 = mediaType1.getQualityValue();
//            double quality2 = mediaType2.getQualityValue();
//            int qualityComparison = Double.compare(quality2, quality1);
//            if (qualityComparison != 0) {
//                return qualityComparison;  // audio/*;q=0.7 < audio/*;q=0.3
//            }
//            return super.compareParameters(mediaType1, mediaType2);
//        }
//    };

// MARK: - Constants

    fileprivate struct Inner {
        static let ParamQualityFactor = "q"
    }

    /// Public constant media type that includes all media ranges (i.e. "&#42;/&#42;").
    public static let All = MediaType.valueOf(AllValue)!
    public static let AllValue = "*/*"

    /// Public constant media type for {@code application/atom+xml}.
    public static let ApplicationAtomXml = MediaType.valueOf(ApplicationAtomXmlValue)!
    public static let ApplicationAtomXmlValue = "application/atom+xml"

    /// Public constant media type for {@code application/x-www-form-urlencoded}.
    public static let ApplicationFormUrlencoded = MediaType.valueOf(ApplicationFormUrlencodedValue)!
    public static let ApplicationFormUrlencodedValue = "application/x-www-form-urlencoded"

    /// Public constant media type for {@code application/json}.
    public static let ApplicationJson: MediaType = MediaType.valueOf(ApplicationJsonValue)!
    public static let ApplicationJsonValue = "application/json"

    /// Public constant media type for {@code application/octet-stream}.
    public static let ApplicationOctetStream = MediaType.valueOf(ApplicationOctetStreamValue)!
    public static let ApplicationOctetStreamValue = "application/octet-stream"

    /// Public constant media type for {@code application/xhtml+xml}.
    public static let ApplicationXhtmlXml = MediaType.valueOf(ApplicationXhtmlXmlValue)!
    public static let ApplicationXhtmlXmlValue = "application/xhtml+xml"

    /// Public constant media type for {@code application/xml}.
    public static let ApplicationXml = MediaType.valueOf(ApplicationXmlValue)!
    public static let ApplicationXmlValue = "application/xml"

    /// Public constant media type for {@code image/gif}.
    public static let ImageGif = MediaType.valueOf(ImageGifValue)!
    public static let ImageGifValue = "image/gif"

    /// Public constant media type for {@code image/jpeg}.
    public static let ImageJpeg = MediaType.valueOf(ImageJpegValue)!
    public static let ImageJpegValue = "image/jpeg"

    /// Public constant media type for {@code image/png}.
    public static let ImagePng = MediaType.valueOf(ImagePngValue)!
    public static let ImagePngValue = "image/png"

    /// Public constant media type for {@code multipart/form-data}.
    public static let MultipartFormData = MediaType.valueOf(MultipartFormDataValue)!
    public static let MultipartFormDataValue = "multipart/form-data"

    /// Public constant media type for {@code text/html}.
    public static let TextHtml = MediaType.valueOf(TextHtmlValue)!
    public static let TextHtmlValue = "text/html"

    /// Public constant media type for {@code text/plain}.
    public static let TextPlain = MediaType.valueOf(TextPlainValue)!
    public static let TextPlainValue = "text/plain"

    /// Public constant media type for {@code text/xml}.
    public static let TextXml = MediaType.valueOf(TextXmlValue)!
    public static let TextXmlValue = "text/xml"

}

// ----------------------------------------------------------------------------
