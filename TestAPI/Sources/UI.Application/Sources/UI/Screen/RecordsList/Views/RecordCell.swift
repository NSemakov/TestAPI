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
    
    @IBOutlet weak var recordTextLabel: UILabel!
    
// MARK: - Methods

    func updateView(_ viewModel: RecordModel)
    {
        self.creationDateLabel.text = stringFromTimestamp(viewModel.da)
        
        if viewModel.da != viewModel.dm {
            self.changingDateLabel.text = stringFromTimestamp(viewModel.dm)
            self.changingDateContainerView.isHidden = false
        }
        else {
            self.changingDateContainerView.isHidden = true
        }
        
        var textResult: String?
        if let text = viewModel.body {
            textResult = text.substring(upto: text.count > 200 ? 200 : text.count)
        }
        self.recordTextLabel.text = textResult
    }

// MARK: - Private Methods

    func stringFromTimestamp(_ timestamp: Double?) -> String?
    {
        var result: String?
        
        if let timestamp = timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = TimeZone.current
            
            result = dateFormatter.string(from: date)
        }
        
        return result
    }

// MARK: - Variables

    // ...
}

// ----------------------------------------------------------------------------
