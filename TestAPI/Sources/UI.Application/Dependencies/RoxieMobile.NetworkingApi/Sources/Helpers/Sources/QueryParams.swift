// ----------------------------------------------------------------------------
//
//  QueryParams.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

open class QueryParams: ExpressibleByDictionaryLiteral
{
// MARK: - Construction

    public required init(dictionaryLiteral elements: (String, String)...)
    {
        for (key, value) in elements {
            add(key, value)
        }
    }

// MARK: - Properties

    public private(set) var items: [String: [String]] = [:]

    open var isEmpty: Bool {
        return self.items.isEmpty
    }

// MARK: - Functions

    open func add(_ key: String, _ value: String) {
        self.items[key] = ((self.items[key] ?? []) + [value])
    }

    open func get(_ key: String) -> [String]? {
        return self.items[key]
    }

    open func remove(_ key: String) {
        self.items[key] = nil
    }

// MARK: - Inner Types

    public typealias Key = String

    public typealias Value = String
}

// ----------------------------------------------------------------------------
