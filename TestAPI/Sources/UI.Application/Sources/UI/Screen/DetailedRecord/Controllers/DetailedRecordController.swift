// ----------------------------------------------------------------------------
//
//  DetailedRecordController.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class DetailedRecordController: BaseViewController
{
// MARK: - Construction

    class func controller(record: String?) -> Self
    {
        let controller = mdc_controller(storyboardName: nil)!

        controller.title = "Запись"
        controller.detailedText = record

        return controller
    }

// MARK: - Properties

    @IBOutlet private weak var detailedRecordLabel: UILabel!

// MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailedRecordLabel.text = self.detailedText
    }

// MARK: - Private Methods
    
    
// MARK: - Constants



// MARK: - Variables

    private var detailedText: String?

}

// ----------------------------------------------------------------------------
