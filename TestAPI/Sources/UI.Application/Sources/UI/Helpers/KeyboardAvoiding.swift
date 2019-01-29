// ----------------------------------------------------------------------------
//
//  KeyboardAvoiding.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
import UIKit

// ----------------------------------------------------------------------------

protocol KeyboardAvoidingDelegate: class
{
// MARK: - Methods

    func keyboardAvoidingWillShowKeyboard(_ keyboardAvoiding: KeyboardAvoiding, animationDuration: TimeInterval)

    func keyboardAvoidingWillHideKeyboard(_ keyboardAvoiding: KeyboardAvoiding, animationDuration: TimeInterval)
    
}

// ----------------------------------------------------------------------------

class KeyboardAvoiding
{
// MARK: - Construction

    init(view: UIView, constraint: NSLayoutConstraint)
    {
        // Init instance variables
        self.view = view
        self.constraint = constraint
        self.initialConstraintConstant = constraint.constant

        // Subscribe for keyboard notifications
        weak var weakSelf = self
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main,
                using: {
                    weakSelf?.handleKeyboardWillShow($0)
                })
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main,
                using: {
                    weakSelf?.handleKeyboardWillHide($0)
                })
    }

    deinit {
        // Unregister from notifications
        NotificationCenter.default.removeObserver(self)
    }

// MARK: - Properties

    private(set) var avoiding: Bool = false

    weak var delegate: KeyboardAvoidingDelegate?

// MARK: - Methods

    func startAvoiding()
    {
        self.avoiding = true

        if let keyboardFrame = self.keyboardFrame
        {
            // Update view frame
            updateConstraint(keyboardFrame)
        }
    }

    func endAvoiding()
    {
        self.avoiding = false

        // Update view frame
        updateConstraint(nil)
    }

// MARK: - Actions

    // ...

// MARK: - Private Methods

    private func handleKeyboardWillShow(_ notification: Notification)
    {
        if let userInfo = notification.userInfo,
           let keyboardFrameEnd = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            self.keyboardFrame = keyboardFrameEnd

            let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue

            self.delegate?.keyboardAvoidingWillShowKeyboard(self, animationDuration: animationDuration ?? Inner.DefaultAnimationTime)

            if self.avoiding
            {
                // Update view frame
                updateConstraint(keyboardFrameEnd, animationDuration: animationDuration)
            }
        }
    }

    private func handleKeyboardWillHide(_ notification: Notification)
    {
        self.keyboardFrame = nil

        let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue

        self.delegate?.keyboardAvoidingWillHideKeyboard(self, animationDuration: animationDuration ?? Inner.DefaultAnimationTime)

        if self.avoiding
        {
            // Update view frame
            updateConstraint(nil, animationDuration: animationDuration)
        }
    }

    private func updateConstraint(_ keyboardFrame: CGRect?, animationDuration: TimeInterval? = 0.0)
    {
        // Disable animation
        let state = UIView.areAnimationsEnabled
        UIView.setAnimationsEnabled(false)

        // Force to recalculate view frame if needed (without animation)
        self.view.superview?.layoutIfNeeded()

        // Restore previous animation state
        UIView.setAnimationsEnabled(state)

        if let keyboardFrame = keyboardFrame
        {
            // Decrease view frame
            self.constraint.constant = keyboardFrame.height
        }
        else {
            // Reset bottom constraint to initial value
            self.constraint.constant = self.initialConstraintConstant
        }

        // Layout superview
        UIView.animate(withDuration: animationDuration ?? 0.0, animations: {
            self.view.superview?.layoutIfNeeded()
//            if let keyboardAvoidingScrollView = self.view.firstViewOfClass(TPKeyboardAvoidingScrollView.self)
//            {
//                // Scroll to active text field if scroll view frame changed
//                keyboardAvoidingScrollView.scrollToActiveTextField()
//            }
        })
        
    }

// MARK: - Inner Types

    // ...

// MARK: - Constants

    private struct Inner
    {
        static let DefaultAnimationTime = Double(0.3)
    }

// MARK: - Variables

    private let view: UIView

    private let constraint: NSLayoutConstraint

    private let initialConstraintConstant: CGFloat

    private var keyboardFrame: CGRect?

}

// ----------------------------------------------------------------------------
