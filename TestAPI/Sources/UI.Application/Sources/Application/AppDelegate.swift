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
// MARK: - Private Methods
    
    // ...
    
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

        #if DEBUG
        // Init Logger
        Logger.shared
            .logLevel(level: .verbose)
            .logger(logger: StdoutLogger())
        #endif
        

        
        // Done
        return true
    }


}

// ----------------------------------------------------------------------------
