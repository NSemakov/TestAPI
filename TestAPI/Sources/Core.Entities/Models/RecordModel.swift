// ----------------------------------------------------------------------------
//
//  RecordModel.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

public final class RecordModel: ValidatableModel
{
// MARK: - Properties

    public private(set) var id: String!

    public private(set) var body: String?

    public private(set) var da: Date?

    public private(set) var dm: Date?

// MARK: - Methods

    public override func map(with map: Map) {
        super.map(with: map)

        // (De)serialize to/from json
        self.id   <~  map[JsonKeys.Id]
        self.body <~  map[JsonKeys.Body]
        self.da   <~ (map[JsonKeys.Da], TimeZoneFreeTimestampTransform.shared)
        self.dm   <~ (map[JsonKeys.Dm], TimeZoneFreeTimestampTransform.shared)
    }

    public override func validate() throws {
        try super.validate()

        // Validate instance
        // ...
    }
}

// ----------------------------------------------------------------------------
