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
    
    @objc private func loadSession()
    {
        let body = FormBodyBuilder()
            .add(JsonKeys.A, value: "new_session")
            .build()
        
        let entity = BasicRequestEntityBuilder<FormBody>()
            .url(EndpointManager.defaultManager.baseURL)
            .headers(DefaultHttpHeaders.headers(AuthManager.defaultManager.token))
            .body(body)
            .build()
        
        let callback = BasicRestApiCallback<FormBody, SessionModel>()
        callback.then(
            onSuccess: { call, entity, callback in
                callback(call, entity)
                
                // Handle response
                if let session = entity.body
                {
                    AuthManager.defaultManager.session = session.session
                }
        },
            onFailure: { call, error, callback in
                callback(call, error)
                
                print(error)
                let a = 2
        })
        
        let task = GetSessionTaskBuilder()
            .tag("TAG:AppDelegate")
            //.httpClientConfig(ApplicationHttpClientConfig.SharedConfig)
            .requestEntity(entity)
            .build()
        
        TaskQueue.enqueue(task, callback: callback, callbackOnUiThread: true)
    }
    
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
        
        loadSession()
        
        // Done
        return true
    }


}

// ----------------------------------------------------------------------------
