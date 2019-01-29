// ----------------------------------------------------------------------------
//
//  AlertManager.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import MBProgressHUD
import UIKit

// ----------------------------------------------------------------------------

class AlertManager
{
// MARK: - Construction

    static let shared = AlertManager()

    private init() {
        // Do nothing ..
    }

    deinit {
        // Dismiss all active views
        replaceAlertController(nil)
        replaceProgressView(nil)
    }

// MARK: - Methods

    class func showAlert(_ title: String? = nil, message: String? = nil, cancelButtonTitle: String? = nil, cancelButtonAction: ActionBlock? = nil, priority: AlertPriorityType = .low, onDismiss: ActionBlock? = nil, onCompletion: ActionBlock? = nil)
    {
        guard self.shared.shouldPresentAlertWithPriority(priority) else { return }

        if title.isEmpty && message.isEmpty {
            Roxie.fatalError("Illegal arguments.")
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let cancelTitle = (cancelButtonTitle == nil) ? "Закрыть" : cancelButtonTitle
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
            cancelButtonAction?()
        }

        alert.addAction(cancelAction)

        self.shared.replaceAlertController(alert, priority: priority, onClientDismiss: onDismiss, onClientCompletion: onCompletion)
    }

    class func showErrorAlert(_ message: String? = nil, cancelButtonTitle: String? = nil, cancelButtonAction: ActionBlock? = nil, priority: AlertPriorityType = .low, onDismiss: ActionBlock? = nil, onCompletion: ActionBlock? = nil)
    {
        guard self.shared.shouldPresentAlertWithPriority(priority) else { return }

        let cancelTitle = (cancelButtonTitle == nil) ? "Закрыть" : cancelButtonTitle

        showAlert("Ошибка", message: message, cancelButtonTitle: cancelTitle, cancelButtonAction: cancelButtonAction, priority: priority, onDismiss: onDismiss, onCompletion: onCompletion)
    }

    class func showNotImplementedAlert(_ cancelButtonTitle: String? = nil, cancelButtonAction: ActionBlock? = nil, priority: AlertPriorityType = .low, onDismiss: ActionBlock? = nil, onCompletion: ActionBlock? = nil)
    {
        guard self.shared.shouldPresentAlertWithPriority(priority) else { return }

        let cancelTitle = (cancelButtonTitle == nil) ? "Закрыть" : cancelButtonTitle

        showAlert("Функция будет доступна в следующих версиях", cancelButtonTitle: cancelTitle, cancelButtonAction: cancelButtonAction, priority: priority, onDismiss: onDismiss, onCompletion: onCompletion)
    }

    class func showYesNoAlert(_ title: String? = nil, message: String? = nil, yesButtonAction: ActionBlock? = nil, noButtonAction: ActionBlock? = nil, priority: AlertPriorityType = .low, onDismiss: ActionBlock? = nil, onCompletion: ActionBlock? = nil)
    {
        guard self.shared.shouldPresentAlertWithPriority(priority) else { return }

        if title.isEmpty && message.isEmpty {
            Roxie.fatalError("Illegal arguments.")
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "Да", style: .default) { action in
            yesButtonAction?()
        }
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { action in
            noButtonAction?()
        }

        alert.addAction(yesAction)
        alert.addAction(noAction)

        self.shared.replaceAlertController(alert, priority: priority, onClientDismiss: onDismiss, onClientCompletion: onCompletion)
    }

    class func showProgressView(_ message: String, actionHandler: ProgressHUDActionHandler? = nil, priority: AlertPriorityType = .low)
    {
        guard self.shared.shouldPresentAlertWithPriority(priority) else { return }

        let progressView = MBProgressHUD(frame: UIScreen.main.bounds)

        // Init HUD view
        progressView.delegate = actionHandler
        progressView.minShowTime = 0.2
        progressView.removeFromSuperViewOnHide = true

        progressView.backgroundView.style = .solidColor
        progressView.backgroundView.color = Inner.ProgressViewBackgroundColor
        progressView.label.font = UIFont.boldSystemFont(ofSize: 14.0)
        progressView.label.text = message
        progressView.margin  = 12.0
        progressView.bezelView.layer.opacity = 0.75

        // Show new ProgressHUD view
        self.shared.replaceProgressView(progressView, actionHandler: actionHandler, priority: priority)
    }

    class func showCustomAlert(_ alertController: UIViewController, animated: Bool? = false, priority: AlertPriorityType = .low, onDismiss: ActionBlock? = nil, onCompletion: ActionBlock? = nil)
    {
        guard self.shared.shouldPresentAlertWithPriority(priority) else { return }

        self.shared.replaceAlertController(alertController, animated: animated, priority: priority, onClientDismiss: onDismiss, onClientCompletion: onCompletion)
    }

// --

    class func dismissAlertController(_ animated: Bool = true, onDismiss: ActionBlock? = nil) {
        self.shared.dismiss(animated, viewType: .alertController, onInnerDismiss: onDismiss)
    }

    class func dismissProgressView(_ animated: Bool = true) {
        self.shared.dismiss(animated, viewType: .progressView)
    }

    class func dismiss(_ animated: Bool = true, onDismiss: ActionBlock? = nil) {
        self.shared.dismiss(animated, onInnerDismiss: onDismiss)
    }

// MARK: - Private Methods

    private func replaceAlertController(_ newAlertController: UIViewController?, animated: Bool? = false, priority: AlertPriorityType = .low, onClientDismiss: ActionBlock? = nil, onClientCompletion: ActionBlock? = nil)
    {
        weak var weakSelf = self

        if let newController = newAlertController {

            // Dismiss active controller
            if self.controllerHolder != nil {
                dismiss(false, viewType: .alertController, onInnerDismiss: {
                    weakSelf?.showAlertController(newController: newController, animated: animated, priority: priority, onClientDismiss: onClientDismiss, onClientCompletion: onClientCompletion)
                })
            }
            else if self.viewHolder != nil {
                dismiss(false, viewType: .progressView, onInnerDismiss: {
                    weakSelf?.showAlertController(newController: newController, animated: animated, priority: priority, onClientDismiss: onClientDismiss, onClientCompletion: onClientCompletion)
                })
            }
            else {
                showAlertController(newController: newController, animated: animated, priority: priority, onClientDismiss: onClientDismiss, onClientCompletion: onClientCompletion)
            }
        }
        // Dismiss all active views
        else {
            weakSelf?.dismiss(true)
        }
    }

    private func showAlertController(newController: UIViewController, animated: Bool? = false, priority: AlertPriorityType, onClientDismiss: ActionBlock?, onClientCompletion: ActionBlock? = nil) {
        let controller = UIAlertControllerHolder(alertController: newController)

        // Save AlertController with onDismiss block
        self.controllerHolder = ControllerHolder(controller: controller)

        weak var weakSelf = self

        // Show new AlertController
        controller.show(animated: animated,
            onDismiss: {
                weakSelf?.controllerHolder = nil
                weakSelf?.setAlertOnScreenPriority(.low)
                onClientDismiss?()
            },
            onCompletion: {
                onClientCompletion?()
                weakSelf?.setAlertOnScreenPriority(priority)
        })
    }

    private func replaceProgressView(_ newProgressView: MBProgressHUD?, actionHandler: ProgressHUDActionHandler? = nil, priority: AlertPriorityType = .low)
    {
        if let newProgress = newProgressView {
            if let progressView = (self.viewHolder?.view as? MBProgressHUD), (progressView.superview != nil)
            {
                // Send message to the delegate
                progressView.delegate?.hudWasHidden?(progressView)
                progressView.completionBlock = nil
                self.dismissInProgress = false
                // Use default handler if user handler is not exists
                let actionHandler = actionHandler ?? ProgressHUDActionHandler()

                // Save ProgressHUD with action handler
                self.viewHolder = ProgressViewHolder(view: progressView, actionHandler: actionHandler)

                // Replace message and delegate
                progressView.label.text = newProgress.label.text
                progressView.delegate = actionHandler

                // Show ProgressHUD again, if hide action was delayed
                progressView.show(animated: false)
                setAlertOnScreenPriority(priority)
            }
            else
            {
                weak var weakSelf = self

                // Dismiss active view
                if self.controllerHolder != nil {
                    dismiss(false, viewType: .alertController, withDelay: false) {
                        weakSelf?.showProgressView(newProgressView: newProgressView, actionHandler: actionHandler, priority: priority)
                    }
                }
                else if self.viewHolder != nil {
                    dismiss(false, viewType: .progressView, withDelay: false, onInnerDismiss: {
                        weakSelf?.showProgressView(newProgressView: newProgressView, actionHandler: actionHandler, priority: priority)
                    })
                }
                else {
                    self.showProgressView(newProgressView: newProgressView, actionHandler: actionHandler, priority: priority)
                }
            }
        }
    }

    private func showProgressView(newProgressView: MBProgressHUD?, actionHandler: ProgressHUDActionHandler? = nil, priority: AlertPriorityType)
    {
        // Search for window to add a subview
        guard let appDelegate = UIApplication.shared.delegate,
              let windowForSubview = appDelegate.window else { return }

        // Use default handler if user handler is not exists
        let actionHandler = actionHandler ?? ProgressHUDActionHandler()

        // Save ProgressHUD with action handler
        self.viewHolder = ProgressViewHolder(view: newProgressView, actionHandler: actionHandler)

        if let progressView = newProgressView {

            // Set delegate to alert view
            progressView.delegate = actionHandler

            // Show new ProgressHUD view
            if let window = windowForSubview {
                window.addSubview(progressView)
                progressView.show(animated: true)
                setAlertOnScreenPriority(priority)
            }
        }
    }

    private func shouldPresentAlertWithPriority(_ priority: AlertPriorityType) -> Bool {
        return self.onScreenAlertPriority.rawValue <= priority.rawValue
    }

    private func setAlertOnScreenPriority(_ priority: AlertPriorityType) {
        self.onScreenAlertPriority = priority
    }

// --

    private func dismiss(_ animated: Bool, viewType: ViewType? = nil, withDelay: Bool = true, onInnerDismiss: ActionBlock? = nil)
    {
        weak var weakSelf = self
        Dispatch.sync(Queue.main)
        {
            // Dismiss active AlertController
            if (viewType == nil) || (viewType == .alertController) {
                weakSelf?.dismissAlertController(animated: animated, onAdditionalDismiss: onInnerDismiss)
            }

            // Dismiss active ProgressHUD view
            if (viewType == nil) || (viewType == .progressView) {
                weakSelf?.dismissProgressView(animated, withDelay: withDelay, onInnerDismiss: onInnerDismiss)
            }
        }
    }

    private func dismissAlertController(animated: Bool, onAdditionalDismiss: ActionBlock? = nil)
    {
        let alertController = self.controllerHolder?.controller

        // Dismiss alert controller
        alertController?.dismiss(animated: animated, onAdditionalDismiss: onAdditionalDismiss)
    }

    private func dismissProgressView(_ animated: Bool, withDelay: Bool, onInnerDismiss: ActionBlock?)
    {
        if let progressView = (self.viewHolder?.view as? MBProgressHUD), !self.dismissInProgress
        {
            self.dismissInProgress = true
            if (progressView.superview != nil)
            {
                // Send message to the delegate
                let actionHandler = progressView.delegate as? ProgressHUDActionHandler
                progressView.completionBlock = { [weak self] in
                    actionHandler?.hudWasHidden(progressView)
                    onInnerDismiss?()

                    // Release resources
                    if (self?.viewHolder?.view === progressView) {
                        self?.viewHolder = nil
                    }
                    self?.dismissInProgress = false
                }

                // Hide ProgressHUD view
                progressView.removeFromSuperViewOnHide = true

                Dispatch.async {
                    if withDelay {
                        progressView.hide(animated: animated, afterDelay: Inner.ProgressViewHideDelay)
                    } else {
                        progressView.hide(animated: animated)
                    }
                }

                setAlertOnScreenPriority(.low)
            }
        }
    }

// MARK: - Inner Types

    enum AlertPriorityType: Int {
        case low, medium, high
    }

    struct AlertViewParams
    {
        let title: String?
        let message: String?
    }

    typealias ActionBlock = () -> Void

// MARK: - Constants

    private struct Inner
    {
        static let ProgressViewBackgroundColor = UIColor(white: 0.0, alpha: 0.2)
        static let ProgressViewHideDelay: TimeInterval = 0.5
    }

    private struct ProgressViewHolder {
        let view: UIView?
        let actionHandler: ProgressHUDActionHandler?
    }

    private struct ControllerHolder {
        let controller: UIAlertControllerHolder?
    }

    private enum ViewType {
        case alertController
        case progressView
    }

// MARK: - Variables

    private var controllerHolder: ControllerHolder?
    private var viewHolder: ProgressViewHolder?
    private var onScreenAlertPriority: AlertPriorityType = .low
    private var dismissInProgress = false
}

// ----------------------------------------------------------------------------
