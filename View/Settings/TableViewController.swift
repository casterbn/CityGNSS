//
//  TableViewController.swift
//  SNLocation
//
//  Created by Tiago Maia on 30/04/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit





//setttignsview
class TableViewController: UITableViewController {


    var delegate: DataSettingsDelegate?
    
    //vars for UserDefault
    let udSwithMapTypeConstant = "SwithMapTypeConstant"
    let udConstellationsChoosen = "Constellation"
    
    @IBOutlet weak var switchMapType: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("hello tableviewController settings")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //load saved user default
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: udSwithMapTypeConstant)) {
            switchMapType.isOn = true
        } else {
            switchMapType.isOn = false
        }
        
        
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        setNeedsStatusBarAppearanceUpdate()
        
        
    }
    
    //MARK: - Handles
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swichMapType(_ sender: Any) {
        if(switchMapType.isOn){
            delegate?.userChangedMapType(data: true)
        }else{
            delegate?.userChangedMapType(data: false)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(switchMapType.isOn, forKey: udSwithMapTypeConstant)
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath)")
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            
            //set size text on title section
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
            //set color on title section
            header.textLabel?.textColor = UIColor.darkGray
             //center text
            //header.textLabel?.textAlignment = NSTextAlignment.center
            
            
           
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
////        if let header = view as? UITableViewHeaderFooterView{
////            // footerView.backgroundColor = header.backgroundColor
////        }
//
//
//        return footerView
//
//    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


