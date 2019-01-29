// ----------------------------------------------------------------------------
//
//  UIAlertControllerHolder.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2018, Roxie Mobile Ltd. All rights reserved.
//  @link       http://www.roxiemobile.ru/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

public class UIAlertControllerHolder
{
// MARK: - Construction
    
    init(alertController: UIViewController) {
        self.alertController = alertController
    }

// MARK: - Methods

    public func show(animated: Bool? = true, onDismiss: (() -> Void)? = nil, onCompletion: @escaping () -> Void) {
        let window = defineAlertWindow()
        self.window = window
        if let rootViewController = window.rootViewController as? EmptyViewController, let animated = animated {
            window.makeKeyAndVisible()
            rootViewController.present(self.alertController, animated: animated, completion: { onCompletion() })
            rootViewController.onDismissBlock = onDismiss
        }
    }

    public func dismiss(animated: Bool, onAdditionalDismiss: (() -> Void)? = nil) {
        if let rootViewController = window?.rootViewController as? EmptyViewController {
            rootViewController.onAdditionalDismissBlock = onAdditionalDismiss
        }

        self.alertController.dismiss(animated: animated, completion: nil)
    }

// MARK: - Private Methods

    private func defineAlertWindow() -> UIWindow {
        /// The UIWindow that will be at the top of the window hierarchy. The UIAlertController instance is presented on the rootViewController of this window.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = EmptyViewController()
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.alert

        return window
    }

// MARK: - Variables

    private let alertController: UIViewController
    private weak var window: UIWindow?

}

// ----------------------------------------------------------------------------

// In the case of view controller-based status bar style, make sure we use the same style for our view controller
private class EmptyViewController: UIViewController
{
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if !blocksExecuted {
            executeFinalBlocks()
        }
    }

//Previously declared in viewDidDisappear but viewDidDisappear isn't called in iOS 8-9 when you try to present alert while another is on screen
    deinit {
        if !blocksExecuted {
            executeFinalBlocks()
        }
    }

// FIXME: Attention! HACK! Because of different and weird viewDidDisappear calling logic on various iOS versions
    private func executeFinalBlocks()
    {
        self.onDismissBlock?()
        self.onAdditionalDismissBlock?()
        blocksExecuted = !blocksExecuted
    }

// MARK: - Properties

    fileprivate override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }

    fileprivate override var prefersStatusBarHidden : Bool {
        return UIApplication.shared.isStatusBarHidden
    }

// MARK: - Variables

    fileprivate var onDismissBlock: (() -> Void)?
    fileprivate var onAdditionalDismissBlock: (() -> Void)?
    private var blocksExecuted = false
}
