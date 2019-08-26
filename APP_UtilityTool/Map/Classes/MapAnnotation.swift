//
//  MapAnnotation.swift
//  whereismycar
//
//  Created by Alex Cheng on 2019/7/24.
//  Copyright © 2019 Alex Cheng. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

public class MapAnnotation: NSObject {

    public let location: CLLocation
    public let name: String
    public let imageName: String

    public init(latitude: Double, longitude: Double, name: String, imageName: String) {

        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.name = name
        self.imageName = imageName
    }
    
}

extension MapAnnotation: MKAnnotation {

    public var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }

    public var title: String? {
        get {
            return name
        }
    }

}

