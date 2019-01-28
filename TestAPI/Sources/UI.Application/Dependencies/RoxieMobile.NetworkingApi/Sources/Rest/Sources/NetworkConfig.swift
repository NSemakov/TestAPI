// ----------------------------------------------------------------------------
//
//  NetworkConfig.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

public class NetworkConfig: NonCreatable
{
// MARK: - Constants

    public struct Timeout
    {
        public static let Connection: TimeInterval = 60
        public static let Request: TimeInterval = 60
    }

}

// ----------------------------------------------------------------------------
