// ----------------------------------------------------------------------------
//
//  RecordsListController.swift
//
//  @author     Nik
//  @copyright  Copyright (c) 2019
//
// ----------------------------------------------------------------------------

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
//        self.editAdressesButton =  UIBarButtonItem(title: R.string.localizationButton.edit(), style: .plain, target: self, action: Actions.touchEditAddresses)
//
//        self.navigationItem.rightBarButtonItem = self.editAdressesButton

        // Create bindings for table view
        bindTableViewDataSource()
        bindTableViewDelegate()

        // Init the refresh control
        self.refreshControl.addTarget(self, action: Actions.updateData, for: .valueChanged)
        self.tableView.insertSubview(self.refreshControl, at: 0)
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

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        self.tableView.setEditing(editing, animated: animated)

//        let rightBarButtonItem = editing ? self.saveAdressesButton : (self.showEditButton ? self.editAdressesButton : nil)
//        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: animated)
    }

// MARK: - Actions

    @IBAction
    func touchEditAddresses(_ sender: AnyObject) {
        setEditing(true, animated: true)
    }

// MARK: - Private Methods

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

        viewModels
            .drive(onNext: { [weak self] viewModels in
                let isEmpty = (viewModels.first?.items ?? []).isEmpty
                self?.setShowEditButton(!(isEmpty), animated: true)
            })
            .disposed(by: self.disposeBag)
    }

    private func bindTableViewDelegate()
    {
        weak var weakSelf = self

        // Handle row selection
        self.tableView.rx.modelSelected(RecordModel.self)
            .subscribe(onNext: { ride in
                guard let instance = weakSelf else { return }

                instance.showDetailRideHistory(ride)
            })
            .disposed(by: self.disposeBag)

        // Set delegate
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }

    private func createViewModelsDriver() -> Driver<[TableSection]>
    {
        return self.data
            .asObservable()
            .map { [weak self] items in
                guard let instance = self else { return [] }
                return [TableSection(model: (), items: items)]
            }
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] sections in
                let rides = (sections.first?.items ?? [])
                self?.noHistoryView.isHidden = (rides.count > 0)
            })
            .asDriver(onErrorJustReturn: [])
    }

    private func showDetailRideHistory(_ ride: RecordModel)
    {
//        let vc =
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func setShowEditButton(_ showEditButton: Bool, animated: Bool)
    {
        self.showEditButton = showEditButton

        if showEditButton
        {
            if !(self.isEditing) {
                self.navigationItem.rightBarButtonItem = self.editAdressesButton
            }
        }
        else {
            setEditing(false, animated: animated)
        }
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
                

        })
        
        let task = GetRecordsTaskBuilder()
            .tag(self.customTag)
            //.httpClientConfig(ApplicationHttpClientConfig.SharedConfig)
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
//        static let touchEditAddresses = #selector(RecordsListController.updateData)
        static let updateData = #selector(RecordsListController.updateData)
    }

// MARK: - Variables

    private var editAdressesButton: UIBarButtonItem!
    
    private var showEditButton: Bool = true

    private let dataSource = RxTableViewSectionedReloadDataSource<TableSection>(configureCell: { dataSource, tableView, indexPath, element in
        return UITableViewCell()
    })

    private let refreshControl = UIRefreshControl()

    private var canUpdateDataInPast: Bool = true
    
    private var data = Variable<[RecordModel]>([])

}

// ----------------------------------------------------------------------------

extension RecordsListController: UITableViewDelegate
{
// MARK: - Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }

}

// ----------------------------------------------------------------------------

