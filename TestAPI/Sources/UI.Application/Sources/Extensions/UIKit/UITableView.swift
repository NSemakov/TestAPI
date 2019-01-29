// ----------------------------------------------------------------------------
//
//  UITableView.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

extension UITableView
{
// MARK: - Methods

    func registerCellClass<T: UITableViewCell>(_ aClass: T.Type)
    {
        let nib = UINib(nibName: aClass.defaultResourceName, bundle: nil)
        register(nib, forCellReuseIdentifier: aClass.defaultReusableIdentifier)
    }

    func registerHeaderFooterClass<T: UITableViewHeaderFooterView>(_ aClass: T.Type)
    {
        let nib = UINib(nibName: aClass.defaultResourceName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: aClass.defaultReusableIdentifier)
    }

    func dequeueReusableCellOfClass<T: UITableViewCell>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: aClass.defaultReusableIdentifier, for: indexPath) as! T
    }

    func dequeueReusableHeaderFooterViewOfClass<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: aClass.defaultReusableIdentifier) as! T
    }

// MARK: - Methods: Header View / Footer View + AutoLayout

    func sizeHeaderToFit()
    {
        if let headerView = self.tableHeaderView
        {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()

            let size = headerView.systemLayoutSizeFitting(CGSize(width: self.frame.width, height: 0.0), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
            headerView.frame.size.height = ceil(size.height)

            self.tableHeaderView = headerView
        }
    }

    func sizeFooterToFit()
    {
        if let footerView = self.tableFooterView
        {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()

            let size = footerView.systemLayoutSizeFitting(CGSize(width: self.frame.width, height: 0.0), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
            footerView.frame.size.height = size.height

            self.tableFooterView = footerView
        }
    }

}

// ----------------------------------------------------------------------------
