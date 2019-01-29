// ----------------------------------------------------------------------------
//
//  Result.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

public enum BasicEnumResult<T,E>
{
// MARK: - Construction

    case success(T)
    case failure(E)

}

// ----------------------------------------------------------------------------

public protocol EnumResultType
{
// MARK: - Functions

    func map(_ type: Self) -> BasicEnumResult<SuccessValue, FailureValue>

// MARK: - Inner Types

    associatedtype SuccessValue

    associatedtype FailureValue

}

// ----------------------------------------------------------------------------

extension BasicEnumResult: EnumResultType
{
// MARK: - Functions

    public func map(_ type: BasicEnumResult) -> BasicEnumResult<SuccessValue, FailureValue>
    {
        switch self
        {
            case .success(let str):
                return .success(str)

            case .failure(let err):
                return .failure(err)
        }
    }

// MARK: - Inner Types

    public typealias SuccessValue = T

    public typealias FailureValue = E

}

// ----------------------------------------------------------------------------

extension EnumResultType
{
// MARK: - Properties

    public var value: SuccessValue? {
        switch map(self) {
            case .success(let box): return box
            case .failure: return nil
        }
    }

    public var error: FailureValue? {
        switch map(self) {
            case .success: return nil
            case .failure(let err): return err
        }
    }

    public var isSuccess: Bool {
        switch map(self) {
            case .success: return true
            case .failure: return false
        }
    }

}

// ----------------------------------------------------------------------------
