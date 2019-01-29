// ----------------------------------------------------------------------------
//
//  ValidatableModelConverter.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------


open class ValidatableModelConverter<T: ValidatableModel>: AbstractValidatableModelConverter<T>
{
// MARK: - Construction

    public override init() {
        super.init()
    }

// MARK: - Methods

    open override func supportedMediaTypes() -> [MediaType] {
        return [
            MediaType.All
        ]
    }
}

// ----------------------------------------------------------------------------
