// ----------------------------------------------------------------------------
//
//  RecordsListController.swift
//
//  @author     Nik
//  @copyright  Copyright (c) 2019
//
// ----------------------------------------------------------------------------

import Alamofire
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// ----------------------------------------------------------------------------

class RecordsListController: BaseViewController
{
// MARK: - Construction

    class func controller() -> Self
    {
        let controller = mdc_controller(storyboardName: nil)!

        controller.title = "Список записей"

        return controller
    }

// MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var noHistoryView: UIView!

    @IBOutlet private weak var ridesWillAppearLabel: UILabel!

// MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Init UI
        self.tableView.registerCellClass(RecordCell.self)

        self.tableView.estimatedRowHeight = Inner.EstimatedRowHeight
        self.tableView.rowHeight = UITableView.automaticDimension

        // Setup "Edit" button for navigation bar
        self.addRecordButton =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: Actions.addRecord)
        self.navigationItem.rightBarButtonItem = self.addRecordButton

        // Create bindings for table view
        bindTableViewDataSource()
        bindTableViewDelegate()

        // Init the refresh control
        self.refreshControl.addTarget(self, action: Actions.updateData, for: .valueChanged)
        self.tableView.insertSubview(self.refreshControl, at: 0)
        
        // Handle lack of internet connection
        let reachabilityManager = NetworkReachabilityManager()
        
        weak var weakSelf = self
        
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { _ in
            if let isNetworkReachable = reachabilityManager?.isReachable,
                isNetworkReachable == true {
                // Do nothing
            } else {
                //Internet Not Available"
                weakSelf?.showCustomAlert()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update data
        updateData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        TaskQueue.cancel(self.customTag)
    }

// MARK: - Actions

    @IBAction
    func touchAddRecord(_ sender: AnyObject) {
        let vc = NewRecordController.controller(title: "Новая запись")
        self.navigationController?.pushViewController(vc, animated: true)
    }

// MARK: - Private Methods
    
    private func showCustomAlert()
    {
        weak var weakSelf = self
        
        let alertCtrl = UIAlertController(title: "Ошибка", message: "Проверьте соединение с сетью", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        let repeatAction = UIAlertAction(
            title: "Повторить",
            style: .default,
            handler: { action in
                weakSelf?.updateData()
        })
        
        alertCtrl.addAction(repeatAction)
        
        alertCtrl.addAction(cancelAction)
        
        AlertManager.showCustomAlert(alertCtrl, animated: true)
    }

    private func bindTableViewDataSource()
    {
        self.dataSource.configureCell = { dataSource, tableView, indexPath, element in
            let cell = tableView.dequeueReusableCellOfClass(RecordCell.self, forIndexPath: indexPath)
            cell.updateView(element)

            return cell
        }

        self.dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return false
        }

        self.dataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
            return false
        }

        let viewModels = createViewModelsDriver()

        viewModels
            .drive(self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    private func bindTableViewDelegate()
    {
        weak var weakSelf = self

        // Handle row selection
        self.tableView.rx.modelSelected(RecordModel.self)
            .subscribe(onNext: { record in
                guard let instance = weakSelf else { return }

                instance.showDetailRecord(record)
            })
            .disposed(by: self.disposeBag)

        // Set delegate
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }

    private func createViewModelsDriver() -> Driver<[TableSection]>
    {
        return self.data
            .asObservable()
            .map { items in
                return [TableSection(model: (), items: items)]
            }
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] sections in
                let rides = (sections.first?.items ?? [])
                self?.noHistoryView.isHidden = (rides.count > 0)
            })
            .asDriver(onErrorJustReturn: [])
    }

    private func showDetailRecord(_ record: RecordModel)
    {
        let vc = DetailedRecordController.controller(record: record.body)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func updateData()
    {
        guard let session = AuthManager.defaultManager.session else {
            AlertManager.showErrorAlert("Нет сессии")
            return
        }
        
        weak var weakSelf = self
               
        let body = FormBodyBuilder()
            .add(JsonKeys.Session, value: session)
            .add(JsonKeys.A, value: "get_entries")
            .build()
        
        let entity = BasicRequestEntityBuilder<FormBody>()
            .url(EndpointManager.defaultManager.baseURL)
            .headers(DefaultHttpHeaders.headers(AuthManager.defaultManager.token))
            .body(body)
            .build()
        
        let callback = BasicRestApiCallback<FormBody, [RecordModel]>()
        callback.then(
            onSuccess: { call, entity, callback in
                callback(call, entity)
                
                // Handle response
                if let records = entity.body
                {
                    weakSelf?.data.value = records
                }
        },
            onFailure: { call, error, callback in
                callback(call, error)
                
                self.refreshControl.endRefreshing()
        })
        
        callback.thenUI(
            initInterface: { call, callback in
                callback(call)
        },
            finalize: { call, entity, callback in
                self.refreshControl.endRefreshing()
        })
        
        let task = GetRecordsTaskBuilder()
            .tag(self.customTag)
            .requestEntity(entity)
            .build()
        
        TaskQueue.enqueue(task, callback: callback, callbackOnUiThread: true)
    }

// MARK: - Inner Types

    typealias TableSection = SectionModel<Void, RecordModel>

// MARK: - Constants

    private struct Inner
    {
        static let EstimatedRowHeight: CGFloat = 100.0 // 100 pt
        static let MinDelayForAnimationComplete: TimeInterval = 1.5 // 1.5 seconds
    }

    private struct Actions
    {
        static let updateData = #selector(RecordsListController.updateData)
        static let addRecord = #selector(RecordsListController.touchAddRecord(_:))
    }

// MARK: - Variables

    private var addRecordButton: UIBarButtonItem!
    
    private let dataSource = RxTableViewSectionedReloadDataSource<TableSection>(configureCell: { dataSource, tableView, indexPath, element in
        return UITableViewCell()
    })

    private let refreshControl = UIRefreshControl()
    
    private var data = Variable<[RecordModel]>([])

}

// ----------------------------------------------------------------------------

extension RecordsListController: UITableViewDelegate
{
// MARK: - Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// ----------------------------------------------------------------------------

