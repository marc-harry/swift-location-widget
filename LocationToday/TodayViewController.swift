//
//  TodayViewController.swift
//  LocationToday
//
//  Created by Steffen on 19.06.14.
//  Copyright (c) 2014 Steffen. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import MapKit

class TodayViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var locationManager : CLLocationManager!
    var updateResult : NCUpdateResult!

    override func awakeFromNib()  {
        super.awakeFromNib()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()

        updateResult = NCUpdateResult.NoData
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(0, 200)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.startUpdatingLocation()
    }

    override func viewDidDisappear(animated: Bool)  {
        super.viewDidDisappear(animated)

        locationManager.stopUpdatingLocation()
    }
}

extension TodayViewController : NCWidgetProviding {

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(updateResult)
        updateResult = NCUpdateResult.NoData
    }

}

extension TodayViewController : CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations[locations.endIndex - 1] as CLLocation
        println("\(location.coordinate.latitude) : \(location.coordinate.longitude)")
        
        let position = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), 500, 500)
        mapView.setRegion(position, animated: true)
        
        updateResult = NCUpdateResult.NewData
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        var statusString : String!
        switch status {
            case .NotDetermined : statusString = "NotDetermined"
            case .Restricted : statusString = "Restricted"
            case .Denied : statusString = "Denied"
            case .Authorized : statusString = "Authorized"
            case .AuthorizedWhenInUse : statusString = "AuthorizedWhenInUse"
        }

        println(statusString)
        updateResult = NCUpdateResult.NewData
    }

    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!) {
            println(error.localizedDescription)
            updateResult = NCUpdateResult.Failed
    }

}
