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

//        controller.title = R.string.localizationTitle.recordsList()

        return controller
    }

// MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var noHistoryView: UIView!

    @IBOutlet private weak var ridesWillAppearLabel: UILabel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ConfigurationManager.shared.ui.preferredStatusBarStyle
    }

// MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Init UI
        self.tableView.registerCellClass(RecordCell.self)

        self.tableView.estimatedRowHeight = Inner.EstimatedRowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView = self.tableFooterView

        self.tableView.sizeFooterToFit()

        // Setup "Edit" button for navigation bar
        self.editAdressesButton =  UIBarButtonItem(title: R.string.localizationButton.edit(), style: .plain, target: self, action: Actions.touchEditAddresses)

        // Setup "Save" button for navigation bar
        self.saveAdressesButton = UIBarButtonItem(title: R.string.localizationButton.done(), style: .plain, target: self, action: Actions.touchSaveAddresses)

        self.navigationItem.rightBarButtonItem = self.editAdressesButton

        // Create bindings for table view
        bindTableViewDataSource()
        bindTableViewDelegate()

        // Update data
        updateData(for: .future)

        // Init the refresh control
        self.refreshControl.addTarget(self, action: Actions.requestNextPage, for: .valueChanged)
        self.tableView.insertSubview(self.refreshControl, at: 0)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        AuthorizedTaskQueue.shared.cancel(self.customTag)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        self.tableView.setEditing(editing, animated: animated)

        let rightBarButtonItem = editing ? self.saveAdressesButton : (self.showEditButton ? self.editAdressesButton : nil)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: animated)
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
            cell.updateView(RecordCellViewModel(ride: element))

            return cell
        }

        self.dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
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
        self.tableView.rx.modelSelected(RideModel.self)
            .subscribe(onNext: { ride in
                guard let instance = weakSelf else { return }

                instance.showDetailRideHistory(ride)
            })
            .disposed(by: self.disposeBag)

        // Handle row deletion
        self.tableView.rx.itemDeleted
            .subscribe(onNext: { indexPath in
                guard let instance = weakSelf else { return }

                if let ride: RideModel = try? instance.tableView.rx.model(at: indexPath) {
                    instance.deleteRide(ride)
                }
            })
            .disposed(by: self.disposeBag)

        // Set delegate
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }

    private func createViewModelsDriver() -> Driver<[TableSection]>
    {
        return self.userContext.rideHistoryManager
            .rx_rides()
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

    private func showDetailRideHistory(_ ride: RideModel)
    {
        let vc = RideHistoryDetailController.controller(ride, userContext: self.userContext)
        self.navigationController?.pushViewController(vc, animated: true)
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

    private func updateData()
    {
        
    }

    @objc private func requestNextPage() {
        updateData(for: .future)
    }

    private func updateData(for direction: DirectionType = .invalidOptionValue)
    {
        switch direction
        {
            case .future:
                self.userContext.rideHistoryManager.paginatedCollectionLoader.flush()

            default:
                break
        }

        self.userContext.rideHistoryManager.paginatedCollectionLoader.requestNextPage(for: direction)
    }

    private func setLoading(isLoading: LoadForDirection)
    {
        let loading = isLoading.loading
        let direction = isLoading.direction

        switch direction
        {
            case .future:
                if loading {
                    // Do nothing.. All is done automatically
                }
                else {
                    self.refreshControl.endRefreshing()
                }

            case .past:
                if loading {
                    self.tableFooterView.hiddenWithDependentConstraints = false
                    self.tableFooterView.startAnimating()
                    self.tableView.sizeFooterToFit()
                }
                else {
                    // Let give animation a second to be appeared on screen.
                    Dispatch.after(Inner.MinDelayForAnimationComplete, queue: Queue.main)
                    {
                        self.tableFooterView.hiddenWithDependentConstraints = true
                        self.tableFooterView.stopAnimating()
                        self.refreshControl.endRefreshing()
                        self.tableView.sizeFooterToFit()
                    }
                }

            default:
                if !loading {
                    // Force turn off refreshControl because it's start automatically even if we don't need. Can't prevent from this.
                    self.refreshControl.endRefreshing()
                }
                break
        }
    }

// MARK: - Inner Types

    typealias TableSection = SectionModel<Void, RideModel>

// MARK: - Constants

    private struct Inner
    {
        static let EstimatedRowHeight: CGFloat = 100.0 // 100 pt
        static let MinDelayForAnimationComplete: TimeInterval = 1.5 // 1.5 seconds
    }

    private struct Actions
    {
        static let touchEditAddresses = #selector(RecordsListController.touchEditAddresses(_:))
        static let requestNextPage = #selector(RecordsListController.requestNextPage)
    }

// MARK: - Variables

    private var editAdressesButton: UIBarButtonItem!
    
    private var showEditButton: Bool = true

    private let dataSource = RxTableViewSectionedReloadDataSource<TableSection>(configureCell: { dataSource, tableView, indexPath, element in
        return UITableViewCell()
    })

    private let refreshControl = UIRefreshControl()

    private var canUpdateDataInPast: Bool = true

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

