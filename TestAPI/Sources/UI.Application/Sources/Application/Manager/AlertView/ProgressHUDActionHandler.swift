// ----------------------------------------------------------------------------
//
//  ProgressHUDActionHandler.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2015, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import MBProgressHUD

// ----------------------------------------------------------------------------

class ProgressHUDActionHandler: NSObject
{
// MARK: - Construction

    init(onDismiss onDismissBlock: OnDismissBlock? = nil) {
        self.onDismissBlock = onDismissBlock
    }

// MARK: - Inner Types

    typealias OnDismissBlock = () -> Void

// MARK: - Variables

    private var onDismissBlock: OnDismissBlock?

}

// ----------------------------------------------------------------------------
// MARK: - @protocol UIAlertViewDelegate
// ----------------------------------------------------------------------------

extension ProgressHUDActionHandler: MBProgressHUDDelegate
{
// MARK: - Methods

    func hudWasHidden(_ hud: MBProgressHUD)
    {
        if let dismissBlock = self.onDismissBlock {
            dismissBlock()
        }
    }

}

// ----------------------------------------------------------------------------
