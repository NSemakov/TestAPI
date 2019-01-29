// ----------------------------------------------------------------------------
//
//  HttpHeaders.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public struct HttpHeaders
{
// MARK: - Construction

    /// Constructs a new, empty instance of the {@code HttpHeaders} object.
    public init() {
        self.init([String: String]())
    }

    /// Constructor that can create read-only {@code HttpHeader} instances.
    public init(_ headers: [String: String])
    {
        // Init instance variables
        self.headers = headers
    }

// MARK: - Properties

    public var allHeaderFields: [String: String] {
        return self.headers
    }

// MARK: - Constants

    public struct Header
    {
        public static let Accept = "Accept"
        public static let AcceptCharset = "Accept-Charset"
        public static let Allow = "Allow"
        public static let Authorization = "Authorization"
        public static let CacheControl = "Cache-Control"
        public static let ContentDisposition = "Content-Disposition"
        public static let ContentLength = "Content-Length"
        public static let ContentType = "Content-Type"
        public static let Date = "Date"
        public static let ETag = "ETag"
        public static let Expires = "Expires"
        public static let IfModifiedSince = "If-Modified-Since"
        public static let IfNoneMatch = "If-None-Match"
        public static let LastModified = "Last-Modified"
        public static let Location = "Location"
        public static let Pragma = "Pragma"
        public static let UserAgent = "User-Agent"
    }

// MARK: - Variables

    fileprivate var headers: [String: String]

}

// ----------------------------------------------------------------------------

extension HttpHeaders
{
// MARK: - Functions

    // Single string methods

//    /**
//     * Return the first header value for the given header name, if any.
//     * @param headerName the header name
//     * @return the first header value; or {@code null}
//     */
//    public String getFirst(String headerName) {
//        List<String> headerValues = headers.get(headerName);
//        return headerValues != null ? headerValues.get(0) : null;
//    }

//    /**
//     * Add the given, single header value under the given name.
//     * @param headerName  the header name
//     * @param headerValue the header value
//     * @throws UnsupportedOperationException if adding headers is not supported
//     * @see #put(String, List)
//     * @see #set(String, String)
//     */
//    public void add(String headerName, String headerValue) {
//        List<String> headerValues = headers.get(headerName);
//        if (headerValues == null) {
//            headerValues = new LinkedList<String>();
//            this.headers.put(headerName, headerValues);
//        }
//        headerValues.add(headerValue);
//    }

    /**
     * Set the given, single header value under the given name.
     * @param headerName  the header name
     * @param headerValue the header value
     * @throws UnsupportedOperationException if adding headers is not supported
     * @see #put(String, List)
     * @see #add(String, String)
     */
    public mutating func set(_ name: String, value: String?) {
        self.headers[name] = value
    }

//    public void setAll(Map<String, String> values) {
//        for (Entry<String, String> entry : values.entrySet()) {
//            set(entry.getKey(), entry.getValue());
//        }
//    }

//    public Map<String, String> toSingleValueMap() {
//        LinkedHashMap<String, String> singleValueMap = new LinkedHashMap<String,String>(this.headers.size());
//        for (Entry<String, List<String>> entry : headers.entrySet()) {
//            singleValueMap.put(entry.getKey(), entry.getValue().get(0));
//        }
//        return singleValueMap;
//    }

}

// ----------------------------------------------------------------------------

extension HttpHeaders
{
// MARK: - Functions

    // Map implementation

    public func size() -> Int {
        return self.headers.count
    }

    public func isEmpty() -> Bool {
        return self.headers.isEmpty
    }

    public func containsKey(_ name: String) -> Bool {
        return self.headers.keys.contains(name)
    }

    public func containsValue(_ value: String) -> Bool {
        return self.headers.values.contains(value)
    }

    public func get(_ name: String) -> String? {
        return self.headers[name]
    }

    public mutating func put(_ name: String, value: String) {
        set(name, value: value)
    }

    public mutating func remove(_ name: String) {
        set(name, value: nil)
    }

    public mutating func putAll(_ m: [String: String]) {
        for (name, value) in m {
            set(name, value: value)
        }
    }

//    public void clear() {
//        this.headers.clear();
//    }

//    public Set<String> keySet() {
//        return this.headers.keySet();
//    }

//    public Collection<List<String>> values() {
//        return this.headers.values();
//    }

//    public Set<Entry<String, List<String>>> entrySet() {
//        return this.headers.entrySet();
//    }

//    @Override
//    public boolean equals(Object other) {
//        if (this == other) {
//            return true;
//        }
//        if (!(other instanceof HttpHeaders)) {
//            return false;
//        }
//        HttpHeaders otherHeaders = (HttpHeaders) other;
//        return this.headers.equals(otherHeaders.headers);
//    }

//    @Override
//    public int hashCode() {
//        return this.headers.hashCode();
//    }

//    @Override
//    public String toString() {
//        return this.headers.toString();
//    }

}

// ----------------------------------------------------------------------------

extension HttpHeaders
{
// MARK: - Properties

    public var accept: [MediaType]
    {
        /**
         * Set the list of acceptable {@linkplain MediaType media types}, as specified by the {@code Accept} header.
         * @param acceptableMediaTypes the acceptable media types
         */
        set {
            set(Header.Accept, value: MediaType.toString(mediaTypes: newValue))
        }

        /**
         * Return the list of acceptable {@linkplain MediaType media types}, as specified by the {@code Accept} header.
         * <p>Returns an empty list when the acceptable media types are unspecified.
         * @return the acceptable media types
         */
        get {
            let value = get(Header.Accept)
            return (value != nil) ? MediaType.parseMediaTypes(value!) : []
        }
    }

//    /**
//     * Set the list of acceptable {@linkplain Charset charsets}, as specified by the {@code Accept-Charset} header.
//     * @param acceptableCharsets the acceptable charsets
//     */
//    public void setAcceptCharset(List<Charset> acceptableCharsets) {
//        StringBuilder builder = new StringBuilder();
//        for (Iterator<Charset> iterator = acceptableCharsets.iterator(); iterator.hasNext();) {
//            Charset charset = iterator.next();
//            builder.append(charset.name().toLowerCase(Locale.ENGLISH));
//            if (iterator.hasNext()) {
//                builder.append(", ");
//            }
//        }
//        set(ACCEPT_CHARSET, builder.toString());
//    }

//    /**
//     * Return the list of acceptable {@linkplain Charset charsets}, as specified by the {@code Accept-Charset}
//     * header.
//     * @return the acceptable charsets
//     */
//    public List<Charset> getAcceptCharset() {
//        List<Charset> result = new ArrayList<Charset>();
//        String value = getFirst(ACCEPT_CHARSET);
//        if (value != null) {
//            String[] tokens = value.split(",\\s*");
//            for (String token : tokens) {
//                int paramIdx = token.indexOf(';');
//                String charsetName;
//                if (paramIdx == -1) {
//                    charsetName = token;
//                }
//                else {
//                    charsetName = token.substring(0, paramIdx);
//                }
//                if (!charsetName.equals("*")) {
//                    result.add(Charset.forName(charsetName));
//                }
//            }
//        }
//        return result;
//    }

//    /**
//     * Set the set of allowed {@link HttpMethod HTTP methods}, as specified by the {@code Allow} header.
//     * @param allowedMethods the allowed methods
//     */
//    public void setAllow(Set<HttpMethod> allowedMethods) {
//        set(ALLOW, StringUtils.collectionToCommaDelimitedString(allowedMethods));
//    }

//    /**
//     * Return the set of allowed {@link HttpMethod HTTP methods}, as specified by the {@code Allow} header.
//     * <p>Returns an empty set when the allowed methods are unspecified.
//     * @return the allowed methods
//     */
//    public Set<HttpMethod> getAllow() {
//        String value = getFirst(ALLOW);
//        if (value != null) {
//            List<HttpMethod> allowedMethod = new ArrayList<HttpMethod>(5);
//            String[] tokens = value.split(",\\s*");
//            for (String token : tokens) {
//                allowedMethod.add(HttpMethod.valueOf(token));
//            }
//            return EnumSet.copyOf(allowedMethod);
//        }
//        else {
//            return EnumSet.noneOf(HttpMethod.class);
//        }
//    }

    /**
     * Sets a value for the {@code Authorization} header.
     * @param httpAuthentication an http-based authentication representation
     */
    public mutating func setAuthorization(_ httpAuthentication: HttpAuthentication?) {
        set(Header.Authorization, value: httpAuthentication?.getHeaderValue())
    }

    /**
     * Returns the value of the {@code Authorization} header.
     * @return the Authorization header value
     */
    public func getAuthorization() -> String? {
        return get(Header.Authorization)
    }

//    /**
//     * Sets the (new) value of the {@code Cache-Control} header.
//     * @param cacheControl the value of the header
//     */
//    public void setCacheControl(String cacheControl) {
//        set(CACHE_CONTROL, cacheControl);
//    }

//    /**
//     * Returns the value of the {@code Cache-Control} header.
//     * @return the value of the header
//     */
//    public String getCacheControl() {
//        return getFirst(CACHE_CONTROL);
//    }

//    /**
//     * Sets the (new) value of the {@code Content-Disposition} header for {@code form-data}.
//     * @param name the control name
//     * @param filename the filename, may be {@code null}
//     */
//    public void setContentDispositionFormData(String name, String filename) {
//        Assert.notNull(name, "'name' must not be null");
//        StringBuilder builder = new StringBuilder("form-data; name=\"");
//        builder.append(name).append('\"');
//        if (filename != null) {
//            builder.append("; filename=\"");
//            builder.append(filename).append('\"');
//        }
//        set(CONTENT_DISPOSITION, builder.toString());
//    }

//    /**
//     * Set the length of the body in bytes, as specified by the {@code Content-Length} header.
//     * @param contentLength the content length
//     */
//    public void setContentLength(long contentLength) {
//        set(CONTENT_LENGTH, Long.toString(contentLength));
//    }

//    /**
//     * Return the length of the body in bytes, as specified by the {@code Content-Length} header.
//     * <p>Returns -1 when the content-length is unknown.
//     * @return the content length
//     */
//    public long getContentLength() {
//        String value = getFirst(CONTENT_LENGTH);
//        return (value != null ? Long.parseLong(value) : -1);
//    }

    public var contentType: MediaType?
    {
        /**
         * Set the {@linkplain MediaType media type} of the body, as specified by the {@code Content-Type} header.
         * @param mediaType the media type
         */
        set {
            if let mediaType = newValue
            {
                assert(mediaType.isWildcardType(), "‘Content-Type’ cannot contain wildcard type ‘*’")
                assert(mediaType.isWildcardSubtype(), "‘Content-Type’ cannot contain wildcard subtype ‘*’")
                set(Header.ContentType, value: mediaType.description)
            }
            else {
                set(Header.ContentType, value: nil)
            }
        }

        /**
         * Return the {@linkplain MediaType media type} of the body, as specified by the {@code Content-Type} header.
         * <p>Returns {@code null} when the content-type is unknown.
         * @return the content type
         */
        get {
            let value = get(Header.ContentType)
            return (value != nil) ? MediaType.parseMediaType(value!) : nil
        }
    }

//    /**
//     * Sets the date and time at which the message was created, as specified by the {@code Date} header.
//     * <p>The date should be specified as the number of milliseconds since January 1, 1970 GMT.
//     * @param date the date
//     */
//    public void setDate(long date) {
//        setDate(DATE, date);
//    }

//    /**
//     * Returns the date and time at which the message was created, as specified by the {@code Date} header.
//     * <p>The date is returned as the number of milliseconds since January 1, 1970 GMT. Returns -1 when the date is unknown.
//     * @return the creation date/time
//     * @throws IllegalArgumentException if the value can't be converted to a date
//     */
//    public long getDate() {
//        return getFirstDate(DATE);
//    }

//    /**
//     * Sets the (new) entity tag of the body, as specified by the {@code ETag} header.
//     * @param eTag the new entity tag
//     */
//    public void setETag(String eTag) {
//        if (eTag != null) {
//            Assert.isTrue(eTag.startsWith("\"") || eTag.startsWith("W/"), "Invalid eTag, does not start with W/ or \"");
//            Assert.isTrue(eTag.endsWith("\""), "Invalid eTag, does not end with \"");
//        }
//        set(ETAG, eTag);
//    }

//    /**
//     * Returns the entity tag of the body, as specified by the {@code ETag} header.
//     * @return the entity tag
//     */
//    public String getETag() {
//        return getFirst(ETAG);
//    }

//    /**
//     * Sets the date and time at which the message is no longer valid, as specified by the {@code Expires} header.
//     * <p>The date should be specified as the number of milliseconds since January 1, 1970 GMT.
//     * @param expires the new expires header value
//     */
//    public void setExpires(long expires) {
//        setDate(EXPIRES, expires);
//    }

//    /**
//     * Returns the date and time at which the message is no longer valid, as specified by the {@code Expires} header.
//     * <p>The date is returned as the number of milliseconds since January 1, 1970 GMT. Returns -1 when the date is unknown.
//     * @return the expires value
//     */
//    public long getExpires() {
//        return getFirstDate(EXPIRES);
//    }

//    /**
//     * Sets the (new) value of the {@code If-Modified-Since} header.
//     * <p>The date should be specified as the number of milliseconds since January 1, 1970 GMT.
//     * @param ifModifiedSince the new value of the header
//     */
//    public void setIfModifiedSince(long ifModifiedSince) {
//        setDate(IF_MODIFIED_SINCE, ifModifiedSince);
//    }

//    /**
//     * Returns the value of the {@code IfModifiedSince} header.
//     * <p>The date is returned as the number of milliseconds since January 1, 1970 GMT. Returns -1 when the date is unknown.
//     * @return the header value
//     */
//    public long getIfNotModifiedSince() {
//        return getFirstDate(IF_MODIFIED_SINCE);
//    }

//    /**
//     * Sets the (new) value of the {@code If-None-Match} header.
//     * @param ifNoneMatch the new value of the header
//     */
//    public void setIfNoneMatch(String ifNoneMatch) {
//        set(IF_NONE_MATCH, ifNoneMatch);
//    }

//    /**
//     * Sets the (new) values of the {@code If-None-Match} header.
//     * @param ifNoneMatchList the new value of the header
//     */
//    public void setIfNoneMatch(List<String> ifNoneMatchList) {
//        StringBuilder builder = new StringBuilder();
//        for (Iterator<String> iterator = ifNoneMatchList.iterator(); iterator.hasNext();) {
//            String ifNoneMatch = iterator.next();
//            builder.append(ifNoneMatch);
//            if (iterator.hasNext()) {
//                builder.append(", ");
//            }
//        }
//        set(IF_NONE_MATCH, builder.toString());
//    }

//    /**
//     * Returns the value of the {@code If-None-Match} header.
//     * @return the header value
//     */
//    public List<String> getIfNoneMatch() {
//        List<String> result = new ArrayList<String>();
//
//        String value = getFirst(IF_NONE_MATCH);
//        if (value != null) {
//            String[] tokens = value.split(",\\s*");
//            for (String token : tokens) {
//                result.add(token);
//            }
//        }
//        return result;
//    }

//    /**
//     * Sets the time the resource was last changed, as specified by the {@code Last-Modified} header.
//     * <p>The date should be specified as the number of milliseconds since January 1, 1970 GMT.
//     * @param lastModified the last modified date
//     */
//    public void setLastModified(long lastModified) {
//        setDate(LAST_MODIFIED, lastModified);
//    }

//    /**
//     * Returns the time the resource was last changed, as specified by the {@code Last-Modified} header.
//     * <p>The date is returned as the number of milliseconds since January 1, 1970 GMT. Returns -1 when the date is unknown.
//     * @return the last modified date
//     */
//    public long getLastModified() {
//        return getFirstDate(LAST_MODIFIED);
//    }

//    /**
//     * Set the (new) location of a resource, as specified by the {@code Location} header.
//     * @param location the location
//     */
//    public void setLocation(URI location) {
//        set(LOCATION, location.toASCIIString());
//    }

//    /**
//     * Return the (new) location of a resource, as specified by the {@code Location} header.
//     * <p>Returns {@code null} when the location is unknown.
//     * @return the location
//     */
//    public URI getLocation() {
//        String value = getFirst(LOCATION);
//        return (value != null ? URI.create(value) : null);
//    }

//    /**
//     * Sets the (new) value of the {@code Pragma} header.
//     * @param pragma the value of the header
//     */
//    public void setPragma(String pragma) {
//        set(PRAGMA, pragma);
//    }

//    /**
//     * Returns the value of the {@code Pragma} header.
//     * @return the value of the header
//     */
//    public String getPragma() {
//        return getFirst(PRAGMA);
//    }

    // Utility methods

//    private long getFirstDate(String headerName) {
//        String headerValue = getFirst(headerName);
//        if (headerValue == null) {
//            return -1;
//        }
//        for (String dateFormat : DATE_FORMATS) {
//            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(dateFormat, Locale.US);
//            simpleDateFormat.setTimeZone(GMT);
//            try {
//                return simpleDateFormat.parse(headerValue).getTime();
//            }
//            catch (ParseException e) {
//                // ignore
//            }
//        }
//        throw new IllegalArgumentException("Cannot parse date value \"" + headerValue +
//                "\" for \"" + headerName + "\" header");
//    }

//    private void setDate(String headerName, long date) {
//        SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMATS[0], Locale.US);
//        dateFormat.setTimeZone(GMT);
//        set(headerName, dateFormat.format(new Date(date)));
//    }

// MARK: - Constants

//    private static final String[] DATE_FORMATS = new String[] {
//        "EEE, dd MMM yyyy HH:mm:ss zzz",
//        "EEE, dd-MMM-yy HH:mm:ss zzz",
//        "EEE MMM dd HH:mm:ss yyyy"
//    };

//    private static TimeZone GMT = TimeZone.getTimeZone("GMT");

}

// ----------------------------------------------------------------------------
