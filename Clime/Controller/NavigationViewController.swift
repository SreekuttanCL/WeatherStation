//
//  NavigationViewController.swift
//  Clime
//
//  Created by Mostafizur Rahman on 2019-11-27.
//  Copyright © 2019 Sreekuttan C L. All rights reserved.
//

import UIKit
import CoreLocation         
import MapKit

class NavigationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var textFieldForAddress: UITextField!
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func getDirectionsTapped(_ sender: UIButton) {
        
        getAddress()
        
    }
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self

        
    }
    
    func getAddress() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(textFieldForAddress.text!) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    print("No Location Found")
                    return
            }
            print(location)
            self.mapThis(destinationCord: location.coordinate)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func mapThis(destinationCord : CLLocationCoordinate2D)
    {
        let latDelta : CLLocationDegrees = 0.05
        let lonDelta : CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let souceCordinate = (locationManager.location?.coordinate)!
        let region = MKCoordinateRegion(center: souceCordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "Hi"
        annotation.subtitle = "Here I Am"
        annotation.coordinate = souceCordinate
        
        self.mapView.addAnnotation(annotation)
        
        let soucePlaceMark = MKPlacemark(coordinate: souceCordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Something is wrong :(")
                }
                return
            }
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
    }
    
 }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
}
