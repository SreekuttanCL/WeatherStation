//
//  WeatherDataModel.swift
//  Clime
//
//  Created by Sreekuttan C L on 2019-08-24.
//  Copyright © 2019 Sreekuttan C L. All rights reserved.
//

import UIKit

class WeatherDataModel {
    var temperature : Int = 0
    var condition : Int = 0
    var city : String = ""
    var weatherIconName : String = ""
    var sunrise: NSDate!
    
    
    func updateWeatherIcon(condition : Int) -> String {
        
        switch (condition) {
        case 0...300:
            return "tstorm1"
        case 301...500:
            return "light_rain"
        case 501...600:
            return "shower3"
        case 601...700:
            return "snow"
        case 701...771:
            return " fog"
        case 772...800:
            return "tstorm1"
        case 800:
            return "8x8FT-Sunshine-Blue-Sky-Sea-Wave-Sand-Shore-Beach-Summer-Tide-Custom-Photography-Studio-Backgrounds-Backdrops.jpg_640x640"
        case 801...804:
            return "cloudy4"
        case 900...903, 905...1000:
            return "tstorm1"
        case 903:
            return "snow"
        case 904:
            return "8x8FT-Sunshine-Blue-Sky-Sea-Wave-Sand-Shore-Beach-Summer-Tide-Custom-Photography-Studio-Backgrounds-Backdrops.jpg_640x640"
        
        default:
            return "nothing"
        }
    }
}
