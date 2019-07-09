//
//  SatelliteTableViewController.swift
//  CityGNSS
//
//  Created by Tiago Maia on 27/06/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit
import CGFramework


class SatelliteTableViewController: UITableViewController {
    
    var listSat: CG_ListSamplesSatellites?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //tableviewcell, init and register cell
        let satellite_cellNib = UINib(nibName: "SatelliteTableViewCell", bundle: nil)
        self.tableView.register(satellite_cellNib, forCellReuseIdentifier: "cell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotListSat(notification:)), name: NSNotification.Name(rawValue: "listSat"), object: nil)
        
    }
    
    // MARK: - Handle Notification Center
    @objc func gotListSat(notification: Notification){
        //updates
        //debugPrint("SatelliteTableView:  bump notification")
        listSat = notification.userInfo!["listSat"] as? CG_ListSamplesSatellites
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       // one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       // total number of satellites in the list
        return listSat?.getSatelliteCount() ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SatelliteTableViewCell

        
        
        // Configure the cell...
        cell.lb_sat_id.text = String(format: "%d", listSat?.getSvid(satIndex: indexPath.row) ?? 0)
        var flag : String
        switch listSat?.getConstellationName(satIndex: indexPath.row) {
        case ConstellationType.GALILEO.description:
            flag = "🇪🇺"
        case ConstellationType.GPS.description:
            flag = "🇺🇸"
        case ConstellationType.GLONASS.description:
            flag = "🇷🇺"
        default:
            flag = ""
        }
        cell.lb_sat_name.text = "\(flag) \(listSat?.getConstellationName(satIndex: indexPath.row) ?? flag)"
        cell.lb_sat_elevation.text = String(format: "%.2f", (listSat?.getElevationDegrees(satIndex: indexPath.row) ?? 0))
        cell.lb_sat_azimuth.text = String(format: "%.2f", (listSat?.getAzimuthDegrees(satIndex: indexPath.row) ?? 0))

 //String(format: "%.3f m", location.verticalAccuracy)
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showPopupSatInfo", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showPopupSatInfo" {
            let indexPathRow = self.tableView.indexPathForSelectedRow?.row
            let vc = segue.destination as! PopupSatelliteViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            
            if(indexPathRow == nil) {return}
            var flag : String
            switch listSat?.getConstellationName(satIndex: indexPathRow ?? 0) {
            case ConstellationType.GALILEO.description:
                flag = "🇪🇺"
            case ConstellationType.GPS.description:
                flag = "🇺🇸"
            case ConstellationType.GLONASS.description:
                flag = "🇷🇺"
            default:
                flag = ""
            }
            if(listSat == nil){
                segue.destination.dismiss(animated: true, completion: nil)
            }
            //let str = "\(flag) \(listSat?.getConstellationName(satIndex: indexPathRow ?? 0) ?? flag)"
            vc.satellite = listSat?.getSatelliteBy(satIndex: indexPathRow ?? 0)
            vc.satellite?.name = "\(flag) \(vc.satellite?.name ?? ConstellationType.UNKNOW.description)"
            
        }
    }
    

}
