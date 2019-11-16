//
//  ChangeCityViewController.swift
//  Clime
//
//  Created by Sreekuttan C L on 2019-08-24.
//  Copyright © 2019 Sreekuttan C L. All rights reserved.
//

import UIKit

//protocol declaration
protocol changeCityDelegate {
    func userEnteredANewCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    
    //Declare Delegate variable
    var delegate: changeCityDelegate?
    
    @IBOutlet weak var changeCityTextLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func getWeathePressed(_ sender: Any) {
        
        let cityName = changeCityTextLabel.text!
        
        delegate?.userEnteredANewCityName(city: cityName)
        
        self.dismiss(animated: true, completion: nil)
    }
}
