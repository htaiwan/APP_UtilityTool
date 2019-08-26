//
//  MapManager.swift
//  WhereIsCar
//
//  Created by Alex Cheng on 2019/8/4.
//  Copyright © 2019 Chien-Tai Cheng. All rights reserved.
//

import UIKit
import MapKit

public class MapManager: NSObject {

    public typealias Distance = String
    public typealias Minute = String
    public typealias Route = MKRoute
    public typealias DidFinishRenderingHandler = (() -> Void)

    public static let shared = MapManager()
    public var didFinishRenderingHandler: DidFinishRenderingHandler?
    private var mapView: MKMapView?

    public func setRegion(mapView: MKMapView?, center: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 100) {
        if self.mapView == nil {
            self.mapView = mapView
            self.mapView!.delegate = self
        }
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView!.setRegion(region, animated: true)
    }

    public func addAnnotations(annotations: [MapAnnotation]) {
        self.mapView?.addAnnotations(annotations)
    }

    public func clearMap() {
        guard let mapView = mapView else { return }
        mapView.removeAnnotations(mapView.annotations)
        mapView.overlays.forEach {
            if !($0 is MKUserLocation) {
                mapView.removeOverlay($0)
            }
        }
    }

    public func finishRenderingMap(completionHandler: @escaping (() -> Void)) {
        self.didFinishRenderingHandler = completionHandler
    }

    public func loadDirections(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, completionHandler: @escaping ((Route, Distance, Minute)?, Error?) -> Void) {
        let request = MKDirections.Request()
        let startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: start))
        let endMapItem = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.source = startMapItem
        request.destination = endMapItem
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        var distance: CLLocationDistance = 0
        var miuntes = 0
        var currentRoute = MKRoute()
        let directions = MKDirections(request: request)
        directions.calculate() { [weak self] (response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let route = response?.routes.first {
                self?.mapView?.addOverlay(route.polyline)
                currentRoute = route
                for step in route.steps {
                    distance = distance + step.distance
                }
                // 平均步行速率約 5km/hr
                miuntes = Int((distance / 5000) * 60)
            }
            completionHandler((currentRoute, String(Int(distance)), String(miuntes)), error)
        }
    }
}

extension MapManager: MKMapViewDelegate {

    // MARK: MKMapViewDelegate

    public func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        print("rendering ...")
    }

    public func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("mapViewDidFinishRenderingMap ...")
        guard let didFinishRenderingHandler = self.didFinishRenderingHandler else { return }
        didFinishRenderingHandler()
    }

    public func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("mapViewDidFinishLoadingMap ...")
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Car") as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Car")
        } else {
            annotationView?.annotation = annotation
        }

        if annotation.title == "Car" {
            annotationView?.glyphText = "🚘"
        } else {
            annotationView?.glyphText = "👀"
        }

        annotationView?.markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)

        if let placeAnnotation = annotation as? MapAnnotation {
            let image = UIImage(named: placeAnnotation.imageName)
            let imageView = UIImageView(image: image)
            annotationView?.detailCalloutAccessoryView = imageView
        }

        return annotationView
    }

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLine = MKPolylineRenderer(overlay: overlay)
        polyLine.strokeColor = UIColor.red
        return polyLine
    }


}
