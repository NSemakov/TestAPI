// ----------------------------------------------------------------------------
//
//  RecordCellViewModel.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
import TaxiBookingCoreEntities

// ----------------------------------------------------------------------------

class RecordCellViewModel
{
// MARK: - Construction

    init(ride: RideModel)
    {
        // Init instance variables
        self.ride = ride
        self.dateTime = ride.booking.pickUpTime?.format(with: DateFormats.LongAbbreviationDayMonthTime)
        self.price = MoneyUtils.toString(ride.booking.price)
        self.routePoints = ride.route.points
        self.driverName = ride.taxicab?.driver.name
        self.driverImageLink = LinkCreator.createLink(from: ride.taxicab?.driver.imageLink)
    }

// MARK: - Properties

    let ride: RideModel

    let dateTime: String?

    let price: String

    let routePoints: [GeoPointModel]

    let driverName: String?

    let driverImageLink: URL?
    
}

// ----------------------------------------------------------------------------
