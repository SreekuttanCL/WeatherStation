//
//  WeatherViewController.swift
//  Clime
//
//  Created by Sreekuttan C L on 2019-08-24.
//  Copyright © 2019 Sreekuttan C L. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, changeCityDelegate {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var sunriseTime: UILabel!
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "7cd42e3d6f458dfebd68c0c4b5614731"
    
    //Instance variables
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup loccation manager
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    //Mark: - Networking
    /*****************************************************/
    
    //getWeatherData here
    
    func getWeatherData(url : String, parameters : [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                print(weatherJSON)
            }
            else {
                print("error")   //make a error alert for user
            }
        }
    }
    
    
    //Mark: - JSON Parsing
    /*****************************************************/
    
    //updateWeatherData here
    
    func updateWeatherData(json : JSON) {
        
        if let tempResult = json["main"]["temp"].double {
        
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            let sunRise = json["sys"]["sunrise"].doubleValue
            let sunRiseTime = NSDate(timeIntervalSince1970: sunRise)
            print("\(sunRiseTime)")
            weatherDataModel.sunrise = sunRiseTime
            
            updateUIwithWeatherData()
        }
//        else if let time = json["sys"]["sunrise"].int {
//            weatherDataModel.sunrise = json["sunrise"].stringValue
//            updateUIwithWeatherData()
//        }
        else {
            //make alert to user for know weather not available
        }
    }
    
    
    
    
    //Mark: - UI Updates
    /*****************************************************/
    
    // updateUIWithWeatherData here
    func updateUIwithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature) + "° "
       // sunriseTime.text = String(weatherDataModel.sunrise)
       // weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    //Mark: - Location Manager Delegate Method
    /*****************************************************/
    
    //didLocationUpdate method here
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //didFailWithError method here
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "location Unavailable" // make a error alert
    }
    
    
    
    
    //Mark: - Change City Delegate Methods
    /*****************************************************/
    
    
    // userEnteredNewCityName Delegate Method here
    func userEnteredANewCityName(city: String) {
        
        cityLabel.text = city
    }
    
    //prepareForSegue here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName"{
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
}

