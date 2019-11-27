//
//  SavedPlaceViewController.swift
//  Clime
//
//  Created by Mostafizur Rahman on 2019-11-27.
//  Copyright © 2019 Sreekuttan C L. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SavedPlaceViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var showMap: MKMapView!
    var locationManager = CLLocationManager()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uiLongPressgestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SavedPlaceViewController.longpress(gestureRecognizer:)))
                uiLongPressgestureRecognizer.minimumPressDuration = 2
                showMap.addGestureRecognizer(uiLongPressgestureRecognizer)
                

                
                
                if activePlace == -1
                {
                    
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.startUpdatingLocation()
                    
                }else  //we do have active place
                {
                    //Get place details to display on the map
                    if places.count > activePlace
                    {
                        if let name = places[activePlace]["name"]
                        {
                            if let lat = places[activePlace]["lat"]
                            {
                                if let lon = places[activePlace]["lon"]
                                {
                                    if let latitude = Double(lat)
                                    {
                                        if let longitude = Double(lon)
                                        {
                                            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                            let region = MKCoordinateRegion(center: coordinate, span: span)
                                            
                                            self.showMap.setRegion(region, animated: true)
                                            
                                            let anotation = MKPointAnnotation()
                                            anotation.title = name
                                            anotation.coordinate = coordinate
                                            self.showMap.addAnnotation(anotation)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            
            let region = MKCoordinateRegion(center: location, span: span)
            
            self.showMap.setRegion(region, animated: true)
            
        }
    @objc func longpress(gestureRecognizer: UIGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizer.State.began
        {
            let touchPoint = gestureRecognizer.location(in: self.showMap)
            let coordinate = showMap.convert(touchPoint, toCoordinateFrom: showMap)
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location) { (placeMarks, error) in
                if error != nil
                {
                    print(error!)
                }else
                {
                    if let placemark = placeMarks?[0]
                    {
                        if placemark.subThoroughfare != nil
                        {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil
                        {
                            title += placemark.thoroughfare!
                        }
                    }
                }
                if title == ""
                {
                    title = "Added \(NSDate())"
                }
                
                let anotation = MKPointAnnotation()
                anotation.title = title
                anotation.coordinate = coordinate
                
                self.showMap.addAnnotation(anotation)
                
                
                places.append(["name": title, "lat":
                    String(coordinate.latitude), "lon": String(coordinate.longitude)])
                
                UserDefaults.standard.set(places, forKey: "places")
                
            }
            
            
        }
        
    }
    
    

    

}
