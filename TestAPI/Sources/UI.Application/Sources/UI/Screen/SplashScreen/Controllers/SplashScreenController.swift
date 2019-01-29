// ----------------------------------------------------------------------------
//
//  SplashScreenController.swift
//
//  @author     Nik
//  @copyright  Copyright (c) 2019
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class SplashScreenController: BaseViewController
{
// MARK: - Construction

    class func controller() -> Self
    {
        let controller = mdc_controller(storyboardName: nil)!

        return controller
    }

// MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSession()
    }
    
    private func loadSession()
    {
        weak var weakSelf = self
        
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
                    weakSelf?.presentRecordsScreen()
                }
        },
            onFailure: { call, error, callback in
                callback(call, error)
        })
        
        let task = GetSessionTaskBuilder()
            .tag("TAG:AppDelegate")
            .requestEntity(entity)
            .build()
        
        TaskQueue.enqueue(task, callback: callback, callbackOnUiThread: true)
    }

    private func presentRecordsScreen()
    {
        let vc = RecordsListController.controller()
        let nc = UINavigationController(rootViewController: vc)
        let window = UIApplication.shared.delegate?.window
        window??.rootViewController = nc
        window??.makeKeyAndVisible()
    }
}

// ----------------------------------------------------------------------------
