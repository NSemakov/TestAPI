// ----------------------------------------------------------------------------
//
//  MimeType.swift
//
//  @author     Irina Zavilkina <ZavilkinaIB@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

open class MimeType
{
// MARK: - Construction

    /**
     * Create a new {@code MimeType} for the given primary type.
     * <p>The {@linkplain #getSubtype() subtype} is set to "&#42;", parameters empty.
     * @param type the primary type
     * @throws IllegalArgumentException if any of the parameters contain illegal characters
     */
    public convenience init?(type: String) {
        self.init(type: type, subtype: MimeType.WildcardType)
    }

    /**
     * Create a new {@code MimeType} for the given primary type and subtype.
     * <p>The parameters are empty.
     * @param type the primary type
     * @param subtype the subtype
     * @throws IllegalArgumentException if any of the parameters contain illegal characters
     */
    public convenience init?(type: String, subtype: String) {
        self.init(type: type, subtype: subtype, params: nil)
    }

//    /**
//     * Create a new {@code MimeType} for the given type, subtype, and character set.
//     * @param type the primary type
//     * @param subtype the subtype
//     * @param charSet the character set
//     * @throws IllegalArgumentException if any of the parameters contain illegal characters
//     */
//    public MimeType(String type, String subtype, Charset charSet) {
//        this(type, subtype, Collections.singletonMap(PARAM_CHARSET, charSet.name()));
//    }

//    /**
//     * Copy-constructor that copies the type and subtype of the given {@code MimeType},
//     * and allows for different parameter.
//     * @param other the other media type
//     * @param parameters the parameters, may be {@code null}
//     * @throws IllegalArgumentException if any of the parameters contain illegal characters
//     */
//    public MimeType(MimeType other, Map<String, String> parameters) {
//        this(other.getType(), other.getSubtype(), parameters);
//    }

    /**
     * Create a new {@code MimeType} for the given type, subtype, and parameters.
     * @param type the primary type
     * @param subtype the subtype
     * @param parameters the parameters, may be {@code null}
     * @throws IllegalArgumentException if any of the parameters contain illegal characters
     */
    public init?(type: String, subtype: String, params: [String: String]?, error: NSErrorPointer = nil)
    {
        // Init instance variables
        self.type = type.lowercased()
        self.subtype = subtype.lowercased()
        self.parameters = [String: String]()

        // Validate incoming params
        if (type.count < 1) || !checkToken(type, error: error) || (subtype.count < 1) || !checkToken(subtype, error: error) {
            return nil
        }

        // Init instance variables
        self.parameters = checkParameters(params)
    }

// MARK: - Properties

    /// Return the primary type.
    public let type: String

    /// Return the subtype.
    public let subtype: String

    /**
     * Return the character set, as indicated by a {@code charset} parameter, if any.
     * @return the character set; or {@code null} if not available
     */
    open var charset: Charset?
    {
        var charset: Charset?

        if let charsetName = parameter(name: MimeType.ParamCharset) {
            charset = Charset.forName(unquote(charsetName))
        }

        return charset
    }

    /**
     * Return all generic parameter values.
     * @return a read-only map, possibly empty, never {@code null}
     */
    open fileprivate(set) var parameters: [String: String]

// MARK: - Functions

    /**
     * Checks the given token string for illegal characters, as defined in RFC 2616,
     * section 2.2.
     * @throws IllegalArgumentException in case of illegal characters
     * @see <a href="http://tools.ietf.org/html/rfc2616#section-2.2">HTTP 1.1, section 2.2</a>
     */
    fileprivate func checkToken(_ token: String, error: NSErrorPointer = nil) -> Bool
    {
        var result = true

        for ch in token
        {
            if !Inner.Token.contains(ch)
            {
                error?.pointee = NSError(domain: "IllegalArgumentException", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid token character ‘\(ch)’ in token ‘\(token)’."])

                result = false
                break
            }
        }

        // Done
        return result
    }

    fileprivate func checkParameters(_ params: [String: String]?) -> [String: String]
    {
        var parameters = [String: String]()

        if let params = params
        {
            for (attribute, value) in params
            {
                if checkParameters(attribute, value) {
                    parameters[attribute] = value
                }
            }
        }

        return parameters
    }

    func checkParameters(_ attribute: String, _ value: String) -> Bool
    {
        var result = false

        if !attribute.isEmpty && !value.isEmpty && checkToken(attribute, error: nil)
        {
            if (attribute == MimeType.ParamCharset)
            {
                Charset.forName(unquote(value))
                result = true
            }
            else
            if !isQuotedString(value) {
                result = checkToken(value, error: nil)
            }
        }

        // Done
        return result
    }

    fileprivate func isQuotedString(_ str: String) -> Bool
    {
        if (str.count < 2) {
            return false
        }
        else {
            return ((str.hasPrefix("\"") && str.hasSuffix("\"")) || (str.hasPrefix("'") && str.hasSuffix("'")))
        }
    }

    func unquote(_ str: String) -> String {
        return isQuotedString(str) ? String(str.substring(with: 1..<(str.count - 1))) : str
    }

    /**
     * Indicates whether the {@linkplain #getType() type} is the wildcard character
     * {@code &#42;} or not.
     */
    public func isWildcardType() -> Bool {
        return (self.type == MimeType.WildcardType)
    }

    /**
     * Indicates whether the {@linkplain #getSubtype() subtype} is the wildcard character
     * {@code &#42;} or the wildcard character followed by a sufiix (e.g.
     * {@code &#42;+xml}), or not.
     * @return whether the subtype is {@code &#42;}
     */
    public func isWildcardSubtype() -> Bool {
        return (self.subtype == MimeType.WildcardType) || self.subtype.hasPrefix("*+")
    }

    /**
     * Indicates whether this media type is concrete, i.e. whether neither the type or
     * subtype is a wildcard character {@code &#42;}.
     * @return whether this media type is concrete
     */
    public func isConcrete() -> Bool {
        return !isWildcardType() && !isWildcardSubtype()
    }

    /**
     * Return a generic parameter value, given a parameter name.
     * @param name the parameter name
     * @return the parameter value; or {@code null} if not present
     */
    public func parameter(name: String) -> String? {
        return self.parameters[name]
    }

//    /**
//     * Indicate whether this {@code MediaType} includes the given media type.
//     * <p>For instance, {@code text/_*} includes {@code text/plain} and {@code text/html},
//     * and {@code application/_*+xml} includes {@code application/soap+xml}, etc. This
//     * method is <b>not</b> symmetric.
//     * @param other the reference media type with which to compare
//     * @return {@code true} if this media type includes the given media type;
//     * {@code false} otherwise
//     */
//    public boolean includes(MimeType other) {
//        if (other == null) {
//            return false;
//        }
//        if (this.isWildcardType()) {
//            // *_/_* includes anything
//            return true;
//        }
//        else if (getType().equals(other.getType())) {
//            if (getSubtype().equals(other.getSubtype())) {
//                return true;
//            }
//            if (this.isWildcardSubtype()) {
//                // wildcard with suffix, e.g. application/_*+xml
//                int thisPlusIdx = getSubtype().indexOf('+');
//                if (thisPlusIdx == -1) {
//                    return true;
//                }
//                else {
//                    // application/_*+xml includes application/soap+xml
//                    int otherPlusIdx = other.getSubtype().indexOf('+');
//                    if (otherPlusIdx != -1) {
//                        String thisSubtypeNoSuffix = getSubtype().substring(0, thisPlusIdx);
//                        String thisSubtypeSuffix = getSubtype().substring(thisPlusIdx + 1);
//                        String otherSubtypeSuffix = other.getSubtype().substring(otherPlusIdx + 1);
//                        if (thisSubtypeSuffix.equals(otherSubtypeSuffix) && WILDCARD_TYPE.equals(thisSubtypeNoSuffix)) {
//                            return true;
//                        }
//                    }
//                }
//            }
//        }
//        return false;
//    }

    /**
     * Indicate whether this {@code MediaType} is compatible with the given media type.
     * <p>For instance, {@code text/_*} is compatible with {@code text/plain},
     * {@code text/html}, and vice versa. In effect, this method is similar to
     * {@link #includes}, except that it <b>is</b> symmetric.
     * @param other the reference media type with which to compare
     * @return {@code true} if this media type is compatible with the given media type;
     * {@code false} otherwise
     */
    public func isCompatibleWith(_ other: MimeType) -> Bool
    {
        if isWildcardType() || other.isWildcardType() {
            return true
        }
        else
        if (self.type == other.type)
        {
            if (self.subtype == other.subtype) {
                return true
            }

            // Wildcard with suffix? e.g. application/_*+xml
            if isWildcardSubtype() || other.isWildcardSubtype()
            {
                let selfPlusRange = self.subtype.range(of: "+")
                let otherPlusRange = other.subtype.range(of: "+")

                if (selfPlusRange == nil && otherPlusRange == nil) {
                    return true
                }
                else
                if (selfPlusRange != nil && otherPlusRange != nil)
                {
                    let selfSubtypeNoSuffix  = String(self.subtype[..<selfPlusRange!.lowerBound])
                    let otherSubtypeNoSuffix = String(other.subtype[..<otherPlusRange!.lowerBound])

                    let selfSubtypeSuffix  = String(self.subtype[self.subtype.index(after: selfPlusRange!.lowerBound)...])
                    let otherSubtypeSuffix = String(other.subtype[other.subtype.index(after: otherPlusRange!.lowerBound)...])

                    if (selfSubtypeSuffix == otherSubtypeSuffix) && (selfSubtypeNoSuffix == MimeType.WildcardType || otherSubtypeNoSuffix == MimeType.WildcardType) {
                        return true
                    }
                }
            }
        }

        return false
    }

//    /**
//     * Compares this {@code MediaType} to another alphabetically.
//     * @param other media type to compare to
//     * @see MimeTypeUtils#sortBySpecificity(List)
//     */
//    @Override
//    public int compareTo(MimeType other) {
//        int comp = getType().compareToIgnoreCase(other.getType());
//        if (comp != 0) {
//            return comp;
//        }
//        comp = getSubtype().compareToIgnoreCase(other.getSubtype());
//        if (comp != 0) {
//            return comp;
//        }
//        comp = getParameters().size() - other.getParameters().size();
//        if (comp != 0) {
//            return comp;
//        }
//        TreeSet<String> thisAttributes = new TreeSet<String>(String.CASE_INSENSITIVE_ORDER);
//        thisAttributes.addAll(getParameters().keySet());
//        TreeSet<String> otherAttributes = new TreeSet<String>(String.CASE_INSENSITIVE_ORDER);
//        otherAttributes.addAll(other.getParameters().keySet());
//        Iterator<String> thisAttributesIterator = thisAttributes.iterator();
//        Iterator<String> otherAttributesIterator = otherAttributes.iterator();
//        while (thisAttributesIterator.hasNext()) {
//            String thisAttribute = thisAttributesIterator.next();
//            String otherAttribute = otherAttributesIterator.next();
//            comp = thisAttribute.compareToIgnoreCase(otherAttribute);
//            if (comp != 0) {
//                return comp;
//            }
//            String thisValue = getParameters().get(thisAttribute);
//            String otherValue = other.getParameters().get(otherAttribute);
//            if (otherValue == null) {
//                otherValue = "";
//            }
//            comp = thisValue.compareTo(otherValue);
//            if (comp != 0) {
//                return comp;
//            }
//        }
//        return 0;
//    }

//    @Override
//    public boolean equals(Object other) {
//        if (this == other) {
//            return true;
//        }
//        if (!(other instanceof MimeType)) {
//            return false;
//        }
//        MimeType otherType = (MimeType) other;
//        return (this.type.equalsIgnoreCase(otherType.type) &&
//                this.subtype.equalsIgnoreCase(otherType.subtype) &&
//                this.parameters.equals(otherType.parameters));
//    }

//    @Override
//    public int hashCode() {
//        int result = this.type.hashCode();
//        result = 31 * result + this.subtype.hashCode();
//        result = 31 * result + this.parameters.hashCode();
//        return result;
//    }

    /**
     * Parse the given String value into a {@code MimeType} object,
     * with this method name following the 'valueOf' naming convention
     * (as supported by {@link org.springframework.core.convert.ConversionService}.
     * @see MimeTypeUtils#parseMimeType(String)
     */
    public class func valueOf(_ value: String, error: NSErrorPointer = nil) -> MimeType? {
        return MimeTypeUtils.parseMimeType(value, error: error)
    }

//    public static class SpecificityComparator<T extends MimeType> implements Comparator<T>
//    {
//        @Override
//        public int compare(T mimeType1, T mimeType2) {
//            if (mimeType1.isWildcardType() && !mimeType2.isWildcardType()) { // */* < audio/*
//                return 1;
//            }
//            else if (mimeType2.isWildcardType() && !mimeType1.isWildcardType()) { // audio/* > */*
//                return -1;
//            }
//            else if (!mimeType1.getType().equals(mimeType2.getType())) { // audio/basic == text/html
//                return 0;
//            }
//            else { // mediaType1.getType().equals(mediaType2.getType())
//                if (mimeType1.isWildcardSubtype() && !mimeType2.isWildcardSubtype()) { // audio/* < audio/basic
//                    return 1;
//                }
//                else if (mimeType2.isWildcardSubtype() && !mimeType1.isWildcardSubtype()) { // audio/basic > audio/*
//                    return -1;
//                }
//                else if (!mimeType1.getSubtype().equals(mimeType2.getSubtype())) { // audio/basic == audio/wave
//                    return 0;
//                }
//                else { // mediaType2.getSubtype().equals(mediaType2.getSubtype())
//                    return compareParameters(mimeType1, mimeType2);
//                }
//            }
//        }
//
//        protected int compareParameters(T mimeType1, T mimeType2) {
//            int paramsSize1 = mimeType1.getParameters().size();
//            int paramsSize2 = mimeType2.getParameters().size();
//            return (paramsSize2 < paramsSize1 ? -1 : (paramsSize2 == paramsSize1 ? 0 : 1)); // audio/basic;level=1 < audio/basic
//        }
//    }

// MARK: - Private Functions

    fileprivate static func initToken() -> Set<Character>
    {
        var tokens = Set<Character>()
        for idx in 0...128 {
            tokens.insert(Character(UnicodeScalar(idx)!))
        }

        // NOTE: Variable names refer to RFC 2616, section 2.2
        for idx in 0...31 {
            tokens.remove(Character(UnicodeScalar(idx)!))
        }

        tokens.remove(Character(UnicodeScalar(127)))
        tokens.remove("(")
        tokens.remove(")")
        tokens.remove("<")
        tokens.remove(">")
        tokens.remove("@")
        tokens.remove(",")
        tokens.remove(";")
        tokens.remove(":")
        tokens.remove("\\")
        tokens.remove("\"")
        tokens.remove("/")
        tokens.remove("[")
        tokens.remove("]")
        tokens.remove("?")
        tokens.remove("=")
        tokens.remove("{")
        tokens.remove("}")
        tokens.remove(" ")
        tokens.remove("\t")

        // Done
        return tokens
    }

// MARK: - Constants

    fileprivate struct Inner {
        static let Token = MimeType.initToken()
    }

    public static let WildcardType = "*"

    public static let ParamCharset = "charset"

}

// ----------------------------------------------------------------------------
// MARK: - @protocol Printable, DebugPrintable
// ----------------------------------------------------------------------------

extension MimeType: CustomStringConvertible, CustomDebugStringConvertible
{
// MARK: - Properties

    public var description: String {
        return self.type + "/" + self.subtype + description(self.parameters)
    }

    public var debugDescription: String {
        return self.description
    }

// MARK: - Private Functions

    fileprivate func description(_ params: [String: String]) -> String
    {
        var result = ""

        for (key, value) in params {
            result += "; \(key)=\(value)"
        }

        return result
    }

}

// ----------------------------------------------------------------------------
