// ----------------------------------------------------------------------------
//
//  UIView+AutoLayoutHide.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

extension UIView
{
// MARK: - Properties

    @IBOutlet var dependentConstraintsForHide: [NSLayoutConstraint]! {
        get {
            return objc_getAssociatedObject(self, &Inner.DependentConstraintsAssociatedKey) as? [NSLayoutConstraint]
        }
        set {
            objc_setAssociatedObject(self, &Inner.DependentConstraintsAssociatedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var hiddenWithDependentConstraints: Bool {
        get {
            // check view is hidden and all depended constraint are enabled
            return self.isHidden && self.dependentConstraintsForHide.reduce(true) { $0 && $1.priority == Inner.DependentConstraintPriorityEnabled }
        }
        set {
            self.isHidden = newValue

            for constraint in self.dependentConstraintsForHide {
                constraint.priority = newValue ? Inner.DependentConstraintPriorityEnabled : Inner.DependentConstraintPriorityDisabled
            }

            setNeedsUpdateConstraints()
        }
    }

// MARK: @constants

    private struct Inner
    {
        static let DependentConstraintPriorityEnabled: UILayoutPriority = UILayoutPriority(rawValue: 750)
        static let DependentConstraintPriorityDisabled: UILayoutPriority = UILayoutPriority(rawValue: 250)
        static var DependentConstraintsAssociatedKey = "DependentConstraintsAssociatedKey"
    }
}

// ----------------------------------------------------------------------------
