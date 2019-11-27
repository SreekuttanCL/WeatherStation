//
//  AwareViewController.swift
//  Clime
//
//  Created by Mostafizur Rahman on 2019-11-27.
//  Copyright © 2019 Sreekuttan C L. All rights reserved.
//

import UIKit
import CoreLocation

class AwareViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var latituteText: UILabel!
    
    @IBOutlet weak var longituteText: UILabel!
    
    @IBOutlet weak var courseText: UILabel!
    
    
    @IBOutlet weak var speedText: UILabel!
    
    @IBOutlet weak var altituteText: UILabel!
    
    @IBOutlet weak var updatingLocation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        
        let latitute = userLocation.coordinate.latitude
        let longitute = userLocation.coordinate.longitude
        let course = userLocation.course
        let speed = userLocation.speed
        let altitute =  userLocation.altitude
        
        
        
        
        latituteText.text = String(latitute)
        longituteText.text = String(longitute)
        courseText.text = String(course)
        speedText.text = String(speed)
        altituteText.text = String(altitute)
        
        //CLGeocoder() is used to convert address to location(i,e Latitute, Longitute). we user reverseGeocoderLoation to reverse the process. placemarks is used to store address details
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placeMaker, error) in
            
            if error != nil
            {
                print(error!)
            }
            else
            {
                if let placemark = placeMaker?[0]           //we use optional because we don't know the value of placemark.it could be in the middle of the desert or somewhere else. placemark is an special object. not just an array
                {
                    var address = ""
                    if placemark.subThoroughfare != nil
                    {
                        address += placemark.subThoroughfare! + " "
                    }
                    
                    if placemark.thoroughfare != nil
                    {
                        address += placemark.thoroughfare! + "\n"
                    }
                    
                    if placemark.subLocality != nil
                    {
                        address += placemark.subLocality! + "\n"
                    }
                    
                    if placemark.subAdministrativeArea != nil
                    {
                        address += placemark.subAdministrativeArea! + "\n"
                    }
                    
                    if placemark.country != nil
                    {
                        address += placemark.country! + "\n"
                    }
                   
                    if placemark.postalCode != nil
                    {
                        address += placemark.postalCode!
                    }
                    
                    self.updatingLocation.text = address
                    
                }
            }
        }
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
