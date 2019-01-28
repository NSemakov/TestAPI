// ----------------------------------------------------------------------------
//
//  RidePointsView.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class RidePointsView: UIView
{
// MARK: - Properties

    @IBOutlet private weak var stackView: StackView!

// MARK: - Methods

    func updateView(_ viewModel: RecordCellViewModel)
    {
        self.stackView.removeSubviews()

        for (idx, point) in viewModel.routePoints.enumerated() {
            let ridePointsRowView = RidePointsRowView.loadFromNib()

            let isFirstAddress = (idx == 0)

            ridePointsRowView.updateView(point, isFirstAddress: isFirstAddress)
            self.stackView.addSubview(ridePointsRowView)
        }
    }

}

// ----------------------------------------------------------------------------
