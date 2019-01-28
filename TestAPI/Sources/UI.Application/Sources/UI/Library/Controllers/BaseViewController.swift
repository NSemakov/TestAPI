// ----------------------------------------------------------------------------
//
//  BaseViewController.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

// Lock Screen Rotation in iOS 8
// @link http://koreyhinton.com/blog/lock-screen-rotation-in-ios8.html

// ----------------------------------------------------------------------------

import RxSwift
import UIKit

// ----------------------------------------------------------------------------

class BaseViewController: UIViewController
{
// MARK: - Construction

    init()
    {
        // Init instance variables
        self.customTag = Roxie.newTag(for: type(of: self))

        // Parent processing
        super.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        // Init instance variables
        self.customTag = Roxie.newTag(for: type(of: self))

        // Parent processing
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder)
    {
        // Init instance variables
        self.customTag = Roxie.newTag(for: type(of: self))

        // Parent processing
        super.init(coder: aDecoder)
    }

// MARK: - Properties

    let customTag: String

    let disposeBag = DisposeBag()

// MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Common custom behaviour
        mdc_viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Common custom behaviour
        mdc_viewWillDisappear(animated)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }

// MARK: - Methods: Autorotation

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIViewController.mdc_interfaceOrientationMask()
    }

    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        let orientation = UIApplication.shared.statusBarOrientation

        if UIDevice.Model.isIdiomPhone {
            return (orientation.isPortrait ? orientation : UIInterfaceOrientation.portrait)
        }
        else {
            return (orientation.isLandscape ? orientation : UIInterfaceOrientation.landscapeLeft)
        }
    }

// MARK: - Actions

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // Hide keyboard
        self.view.endEditing(true)
    }
}

// ----------------------------------------------------------------------------
