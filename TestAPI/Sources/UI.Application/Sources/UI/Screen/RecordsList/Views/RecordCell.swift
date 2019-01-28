// ----------------------------------------------------------------------------
//
//  RecordCell.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class RecordCell: UITableViewCell
{
// MARK: - Construction

    // ...

// MARK: - Properties

    @IBOutlet private weak var changingDateContainerView: UIView!
    
    @IBOutlet private weak var creationDateLabel: UILabel!
    
    @IBOutlet private weak var changingDateLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
// MARK: - Methods

    func updateView(_ viewModel: RecordCellViewModel)
    {
        
    }

// MARK: - Variables

    private let ridePointsView = RidePointsView.loadFromNib()

}

// ----------------------------------------------------------------------------
