// ----------------------------------------------------------------------------
//
//  UIViewController.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

extension UIViewController
{
// MARK: - Methods: Child controllers

    func addChildViewController(_ childController: UIViewController, toSubview subview: UIView)
    {
        addChild(childController)
        subview.addSubview(childController.view)
//        childController.view.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
        childController.didMove(toParent: self)
    }

    func removeChildViewController(_ childController: UIViewController, fromSubview subview: UIView)
    {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }

// MARK: - Methods: Lifecycle

    class func mdc_interfaceOrientationMask() -> UIInterfaceOrientationMask
    {
        if UIDevice.Model.isIdiomPhone {
            return UIInterfaceOrientationMask.portrait.union(.portraitUpsideDown)
        }
        else {
            return UIInterfaceOrientationMask.landscape
        }
    }

    func mdc_viewDidLoad()
    {
        // Hide title of "Back" button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func mdc_viewWillDisappear(_ animated: Bool)
    {
        // FIXME: Remove!
//        // Dismiss all active views
//        AlertViewManager.dismiss()
    }

}

// ----------------------------------------------------------------------------

extension UIViewController
{
// MARK: - Methods

    func firstViewControllerOfClass<V>(_ clazz: V.Type) -> V? {
        return (self as? V) ?? self.parent?.firstViewControllerOfClass(clazz)
    }

}

// ----------------------------------------------------------------------------

