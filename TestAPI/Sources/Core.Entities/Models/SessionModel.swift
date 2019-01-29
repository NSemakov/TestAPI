// ----------------------------------------------------------------------------
//
//  SessionModel.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

public final class SessionModel: ValidatableModel
{
// MARK: - Properties

    public private(set) var session: String!

// MARK: - Methods

    public override func map(with map: Map) {
        super.map(with: map)

        // (De)serialize to/from json
        self.session <~ map[JsonKeys.SessionData]
    }

    public override func validate() throws {
        try super.validate()

        // Validate instance
        // ...
    }
}

// ----------------------------------------------------------------------------
