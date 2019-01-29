// ----------------------------------------------------------------------------
//
//  AppDelegate.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------


import UIKit

// ----------------------------------------------------------------------------

@UIApplicationMain
class AppDelegate: UIResponder
{
// MARK: - Properties

    var window: UIWindow?

}

// ----------------------------------------------------------------------------
// MARK: - @protocol UIApplicationDelegate
// ----------------------------------------------------------------------------

extension AppDelegate: UIApplicationDelegate
{
// MARK: - Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = RecordsListController.controller()
        self.window?.makeKeyAndVisible()
        
        // Done
        return true
    }


}

// ----------------------------------------------------------------------------
