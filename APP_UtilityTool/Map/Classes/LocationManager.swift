//
//  LocationManager.swift
//  CarKit
//
//  Created by Alex Cheng on 2019/8/3.
//  Copyright © 2019 Chien-Tai Cheng. All rights reserved.
//

import UIKit
import CoreLocation

public struct LocationManagerError: Error {
    public var reason: String?

    public init(reason: String?) {
        self.reason = reason
    }
}

extension LocationManagerError: CustomStringConvertible {
    public var description: String {
        let info: [(String, Any?)] = [
            ("- reason", reason),
        ]
        let infoString = info.map { "\($0.0): \($0.1 ?? "nil")" }.joined(separator: "\n")
        return "Got an error while LocationManager.\n\(infoString)"
    }
}

public class LocationManager: NSObject {

    public typealias CurrentLocation = CLLocationCoordinate2D
    public typealias CompletionHandler = ((CurrentLocation?, Error?) -> Void)

    public static let shared = LocationManager()
    public var locationManager: CLLocationManager?
    private var completionHandler: CompletionHandler?
    private var didUpdate: Bool!

    public func setupManager() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    public func startLocationService(completionHandler: @escaping (CurrentLocation?, Error?) -> Void) {
        if locationManager == nil {
            setupManager()
        }
        self.completionHandler = completionHandler
        didUpdate = false
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager!.startUpdatingLocation()
        } else {
            locationManager!.requestWhenInUseAuthorization()
            completionHandler(nil, LocationManagerError(reason: "Authorization"))
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {

    // MARK: CLLocationManagerDelegate

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        guard let completionHandler = self.completionHandler else { return }
        completionHandler(nil, error)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.first
        guard let center = currentLocation?.coordinate, let completionHandler = self.completionHandler else { return }
        if !didUpdate {
            didUpdate = true
            completionHandler(center, nil)
        }
    }

}

