//
//  HTMapDemoViewController.swift
//  APP_UtilityTool_Example
//
//  Created by Alex Cheng on 2019/8/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MapKit
import APP_UtilityTool

class HTMapDemoViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func lock(_ sender: Any) {
        // 清空地圖
        MapManager.shared.clearMap()
        // 開始定位
        LocationManager.shared.startLocationService { [weak self] (carLocation, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let carLocation = carLocation else {
                print("Unable to confirm current car position")
                return
            }

            // 設置地圖中心
            MapManager.shared.setRegion(mapView: self?.mapView, center: carLocation)
            let carAnnotation = MapAnnotation(latitude: carLocation.latitude, longitude: carLocation.longitude, name: "Car", imageName: "")
            MapManager.shared.addAnnotations(annotations: [carAnnotation])
        }

    }


    @IBAction func find(_ sender: Any) {
        MapManager.shared.clearMap()

        // 車子位置
        let carLocation = CLLocationCoordinate2D(latitude: 25.072619, longitude: 121.607544)

        // 使用者位置
        let userLocation = CLLocationCoordinate2D(latitude: 25.068731, longitude: 121.614131)

        // 設置地圖中心
        let distance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude).distance(from: CLLocation(latitude: carLocation.latitude, longitude: carLocation.longitude))
        MapManager.shared.setRegion(mapView: self.mapView, center: userLocation, regionRadius: 1.5 * distance)

        // 置放Annotation
        let carAnnotation = MapAnnotation(latitude: carLocation.latitude, longitude: carLocation.longitude, name: "Car", imageName: "")
        let userAnnotation = MapAnnotation(latitude: userLocation.latitude, longitude: userLocation.longitude, name: "User", imageName: "")
        MapManager.shared.addAnnotations(annotations: [carAnnotation, userAnnotation])

        // 計算距離
        MapManager.shared.loadDirections(start: userLocation, end: carLocation, completionHandler: { (direction, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let direction = direction else {
                print("There is a problem with the calculation distance, please try again")
                return
            }
            print("Find Path Success \(direction.1) \(direction.2)")
        })

    }

}
