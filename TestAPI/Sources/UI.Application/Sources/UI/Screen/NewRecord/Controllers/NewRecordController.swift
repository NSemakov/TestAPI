// ----------------------------------------------------------------------------
//
//  NewRecordController.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class NewRecordController: BaseViewController
{
// MARK: - Construction

    class func controller(title: String) -> Self
    {
        let controller = mdc_controller(storyboardName: nil)!

        controller.title = title

        return controller
    }

// MARK: - Properties

    @IBOutlet weak var messageTextView: UITextView!

    @IBOutlet private weak var contentView: UIView!

    @IBOutlet private weak var contentViewBottomConstraint: NSLayoutConstraint!
    
// MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Avoid keyboard
        self.keyboardAvoiding = KeyboardAvoiding(view: self.contentView, constraint: self.contentViewBottomConstraint)

        self.messageTextView.textContainerInset = Inner.Insets
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.keyboardAvoiding.startAvoiding()
        self.messageTextView.becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.keyboardAvoiding.endAvoiding()
    }

// MARK: - Actions

    @IBAction
    func touchSaveMessage(_ sender: AnyObject)
    {
        self.view.endEditing(true)
        addNewRecord(self.messageTextView.text)
    }
    
    @IBAction
    func touchCancel(_ sender: AnyObject)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

// MARK: - Private Methods
    
    private func addNewRecord(_ record: String?)
    {
        guard let record = record, record.isNotEmpty else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        guard let session = AuthManager.defaultManager.session else {
            AlertManager.showErrorAlert("Нет сессии")
            return
        }
        
        let body = FormBodyBuilder()
            .add(JsonKeys.Session, value: session)
            .add(JsonKeys.A, value: "add_entry")
            .add(JsonKeys.Body, value: record)
            .build()
        
        let entity = BasicRequestEntityBuilder<FormBody>()
            .url(EndpointManager.defaultManager.baseURL)
            .headers(DefaultHttpHeaders.headers(AuthManager.defaultManager.token))
            .body(body)
            .build()
        
        let callback = BasicRestApiCallback<FormBody, Void>()
        callback.then(
            onSuccess: { call, entity, callback in
                callback(call, entity)
                
                // Handle response
                self.navigationController?.popViewController(animated: true)
        },
            onFailure: { call, error, callback in
                callback(call, error)
                
                // Show error
        })
        
        let task = AddRecordTaskBuilder()
            .tag(self.customTag)
            .requestEntity(entity)
            .build()
        
        TaskQueue.enqueue(task, callback: callback, callbackOnUiThread: true)
    }
    
// MARK: - Constants

    private struct Inner
    {
        static let Insets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

// MARK: - Variables

    private var keyboardAvoiding: KeyboardAvoiding!

}

// ----------------------------------------------------------------------------
