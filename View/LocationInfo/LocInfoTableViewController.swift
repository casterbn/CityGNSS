//
//  LocInfoTableViewController.swift
//  CityGNSS
//
//  Created by Tiago Maia on 22/05/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit


class LocInfoTableViewController: UITableViewController {
    
    //static table
    let NUMBER_OF_ROWS = 7
    let NUMBER_OF_SECTIONS = 1
    @IBOutlet weak var lb_utctime: UILabel!
    @IBOutlet weak var lb_altitude: UILabel!
    @IBOutlet weak var lb_speed: UILabel!
    @IBOutlet weak var lb_Haccuracy: UILabel!
    @IBOutlet weak var lb_Vaccuracy: UILabel!
    @IBOutlet weak var lb_hdop: UILabel!
    @IBOutlet weak var lb_vdop: UILabel!
    
    @IBOutlet weak var lb_utctime_text: UILabel!
    @IBOutlet weak var lb_altitude_text: UILabel!
    @IBOutlet weak var lb_speed_text: UILabel!
    @IBOutlet weak var lb_Haccuracy_text: UILabel!
    @IBOutlet weak var lb_Vaccuracy_text: UILabel!
    
    
    

     let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self as? LocationManagerDelegate
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return NUMBER_OF_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NUMBER_OF_ROWS
    }
}
