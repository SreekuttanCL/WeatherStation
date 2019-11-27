//
//  PlacesTableViewController.swift
//  Clime
//
//  Created by Mostafizur Rahman on 2019-11-27.
//  Copyright © 2019 Sreekuttan C L. All rights reserved.
//

import UIKit
var places = [Dictionary<String, String>()]
var activePlace = -1

class PlacesTableViewController: UITableViewController {

    @IBOutlet var tableShow: UITableView!
    var itemArray: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let tempPlace = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>]{
            
            places = tempPlace
        }
        
        
        if places.count == 1 && places[0].count == 0
        {
            places.remove(at: 0)
            places.append(["name": "Taj Mahal", "lat": "27.175277", "lon": "78.042128"])
            UserDefaults.standard.set(places, forKey: "places")
            
        }
        activePlace = -1
        tableShow.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        if places[indexPath.row]["name"] != nil         //checking the name is not nill
        {
            cell.textLabel?.text = places[indexPath.row]["name"]
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            activePlace = indexPath.row
            performSegue(withIdentifier: "toMap", sender: nil)
        }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            places.remove(at: indexPath.row)
            UserDefaults.standard.set(places, forKey: "places")
            tableView.reloadData()
        }
    }

}
