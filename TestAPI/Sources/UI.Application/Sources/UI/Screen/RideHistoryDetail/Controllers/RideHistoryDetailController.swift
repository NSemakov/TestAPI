// ----------------------------------------------------------------------------
//
//  RideHistoryDetailController.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import GoogleMaps
import NetworkingApiRest
import TaxiBookingCoreEntities
import TaxiBookingCoreNet
import UIKit

// ----------------------------------------------------------------------------

class RideHistoryDetailController: BaseTableViewController
{
// MARK: - Construction

    class func controller(_ ride: RideModel, userContext: UserProfileContext) -> Self
    {
        let vc = mdc_controller(storyboardName: nil)!

        // Init instance variables
        vc.ride = ride
        vc.userContext = userContext

        // Init UI
        vc.title = ride.booking.pickUpTime?.format(with: DateFormats.LongAbbreviationDayMonthTime)

        // Done
        return vc
    }

// MARK: - Properties

    @IBOutlet private weak var routePointsContainerView: UIView!
    
    @IBOutlet private weak var mapView: GMSMapView!

    @IBOutlet private weak var statusLabel: UILabel!

    @IBOutlet private weak var priceLabel: UILabel!

    @IBOutlet private weak var cardIconImageView: UIImageView!

    @IBOutlet private weak var cardInfoLabel: UILabel!

    @IBOutlet private weak var driverPhotoImageView: UIImageView!

    @IBOutlet private weak var driverNameLabel: UILabel!

    @IBOutlet private weak var starsRating: RatingView!

    @IBOutlet private weak var repeatButton: UIButton!

    @IBOutlet private weak var paymentCell: UITableViewCell!

    @IBOutlet private weak var driverCell: UITableViewCell!

    @IBOutlet private weak var ratingCell: UITableViewCell!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ConfigurationManager.shared.ui.preferredStatusBarStyle
    }
    
// MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Init UI
        self.tableView.estimatedRowHeight = Inner.EstimatedRowHeight
        self.tableView.rowHeight = UITableView.automaticDimension

        self.repeatButton.setTitleColor(ConfigurationManager.shared.color.primary, for: UIControl.State())

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.localizationButton.remove(), style: .plain, target: self, action: Actions.touchDeleteRide)

        // Configure map view
        self.mapView.delegate = self
        self.mapView.isUserInteractionEnabled = false
        self.mapView.setMinZoom(Constants.MinMapZoom, maxZoom: Constants.MaxMapZoom)
        self.mapView.paddingAdjustmentBehavior = .never

        // Update UI
        updateInterface()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        focusMapToShowAllMarkers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        AuthorizedTaskQueue.shared.cancel(self.customTag)
    }

// MARK: - Actions

    @IBAction
    func touchRepeatRide(withSender sender: Any) {
        ApplicationRouter.sharedRouter.presentCreateRide(self.ride)
    }

    @IBAction
    func touchDeleteRide(_ sender: AnyObject)
    {
        weak var weakSelf = self

        AlertManager.showYesNoAlert(R.string.localizationAlert.titleRemoving(), message: R.string.localizationAlert.areYouWantToDeleteRide(), yesButtonAction: {
            if let instance = weakSelf {
                instance.deleteRide(instance.ride)
            }
        })
    }

// MARK: - Methods

    // ...

// MARK: - Private Methods

    private func updateInterface()
    {
        // TODO: rating info, driver photo

        self.ridePointsView.updateView(RecordCellViewModel(ride: self.ride))
        self.routePointsContainerView.addSubview(self.ridePointsView)

        // Update state label
        switch self.ride.state
        {
            case .completed:
                self.statusLabel.text = R.string.localizationLabel.rideStatusCompleted()

            case .cancelled:
                self.statusLabel.text = R.string.localizationLabel.rideStatusCancelled()
                self.ratingCell.isHidden = true
                self.driverCell.isHidden = true
                self.paymentCell.separatorInset = Inner.LastCellInset

            default:
                self.statusLabel.text = nil
        }

        self.priceLabel.text = MoneyUtils.toString(self.ride.booking.price)
        self.driverNameLabel.text = self.ride.taxicab?.driver.name
        self.driverPhotoImageView.setImageURL(LinkCreator.createLink(from: self.ride.taxicab?.driver.imageLink), placeholderImage: R.image.__rm_driver_photo_placeholder())

        configurePaymentCell()

        // Add route markers
        var routeMarkers: [GMSMarker] = []
        for (idx, geoPoint) in self.ride.route.points.enumerated()
        {
            let marker = GMSMarker(position: geoPoint.location.toCLLocationCoordinate2D())
            let icon = (idx == 0) ? R.image.ic_pin_medium_start() : R.image.ic_pin_medium_finish()
            // FIXME: ...
            marker.icon = icon?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0))
            marker.map = self.mapView
            routeMarkers.append(marker)
        }
        self.routeMarkers = routeMarkers

        self.starsRating.rating = Float(self.ride.rating ?? 0)
    }

    private func configurePaymentCell()
    {
        let paymentMethod = PaymentMethodViewModel(paymentMethod: self.ride.booking.paymentMethod)
        self.cardInfoLabel.text = paymentMethod.text
        self.cardIconImageView.image = paymentMethod.image
    }

    private func focusMapToShowAllMarkers()
    {
        let bounds = self.ride.route.points.reduce(GMSCoordinateBounds()) { bounds, geoPoint in
            return bounds.includingCoordinate(geoPoint.location.toCLLocationCoordinate2D())
        }

        let cameraUpdate = GMSCameraUpdate.fit(bounds, with: Inner.BoundsInsets)
        self.mapView.moveCamera(cameraUpdate)
    }

    private func drawPolylineOnMap()
    {
        let routePoints = self.ride.route.points

        let path = GMSMutablePath()
        routePoints?.forEach()
        {
            let coordinate = $0.location.toCLLocationCoordinate2D()
            path.add(coordinate)
        }

        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = Inner.PolylineWidth
        polyline.strokeColor = Inner.PolylineColor

        polyline.map = self.mapView
    }

    private func deleteRide(_ ride: RideModel)
    {
        let entity = BasicRequestEntityBuilder<VoidBody>()
            .url(EndpointManager.defaultManager.baseURL)
            .headers(DefaultHttpHeaders.headers())
            .build()

        let callback = BasicRestApiCallback<VoidBody, Void>()
        callback.then(
            onSuccess: { [weak self] call, entity, callback in
                callback(call, entity)
                self?.deleteRideFromManager(ride)
            },
            onFailure: { [weak self] call, error, callback in
                if let responseError = (error.cause as? ResponseError), (responseError.entity.status?.code == .notFound)
                {
                    self?.deleteRideFromManager(ride)
                }
                else {
                    callback(call, error)
                }
            })

        let task = DeleteRideTaskBuilder()
            .tag(self.customTag)
            .httpClientConfig(ApplicationHttpClientConfig.SharedConfig)
            .requestEntity(entity)
            .id(ride.id)
            .build()

        AuthorizedTaskQueue.shared.enqueue(task, callback: callback, callbackOnUiThread: true)
    }

    private func deleteRideFromManager(_ ride: RideModel)
    {
        self.userContext.rideHistoryManager.deleteRide(ride.id)
        _ = self.navigationController?.popViewController(animated: true)
    }

// MARK: - Inner Types

    private struct Inner
    {
        static let EstimatedRowHeight: CGFloat = 100.0 // 100 pt
        static let BoundsInsets: UIEdgeInsets = UIEdgeInsets(top: 55, left: 25, bottom: 10, right: 35)
        static let LastCellInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let PolylineWidth: CGFloat = 5.0
        static let PolylineColor: UIColor = ConfigurationManager.shared.color.routeSecondary
    }

    private struct Actions {
        static let touchDeleteRide = #selector(RideHistoryDetailController.touchDeleteRide(_:))
    }

// MARK: - Constants

    // ...

// MARK: - Variables

    private var ride: RideModel!

    private let ridePointsView = RidePointsView.loadFromNib()

    private var routeMarkers = [GMSMarker]()

    private var userContext: UserProfileContext!

}

// ----------------------------------------------------------------------------

extension RideHistoryDetailController
{
// MARK: - Methods

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// ----------------------------------------------------------------------------

extension RideHistoryDetailController: GMSMapViewDelegate
{
// MARK: - Methods

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        drawPolylineOnMap()
    }

}

// ----------------------------------------------------------------------------
