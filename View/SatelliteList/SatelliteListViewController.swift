//
//  SatelliteListViewController.swift
//  CityGNSS
//
//  Created by Tiago Maia on 26/06/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit
import CGFramework


class SatelliteListViewController: UIViewController {

     var delegate: MenuControllerDelegate?
    
    @IBOutlet weak var lb_NtotalSat: UILabel!
    @IBOutlet weak var lb_NusingSat: UILabel!
    @IBOutlet weak var NtotalGPS: UILabel!
    @IBOutlet weak var NtotalGLONASS: UILabel!
    @IBOutlet weak var NtotalGalileo: UILabel!
    
    @IBOutlet weak var containerTV: UIView!
    
    var container : SatelliteTableViewController!
   
    var listSat : CG_ListSamplesSatellites!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //init configureation of navigationbar
        configureNavigationBar(with: self.navigationController?.navigationBar)
        navigationItem.title = NSLocalizedString("satellitelist.text", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-filled-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        //init tableview
        container = self.children[0] as? SatelliteTableViewController
        
        checkIfConnectedToGNSS()
        //if not connected To GNSS preview samples
        
        //receive object list from notifications of cg_framework
        setupNotificationCenter()
        
        
        
        
       
    }
    
    @objc func handleMenuToggle(){
        
        print("--- handlemenutoggle ---")
        
        delegate?.handleMenuToggle(forMenuOption: .none)
        //dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        //print("MenuToggle: delegate is nil: \(delegate == nil)")
        //print("---/ handlemenutoggle ---")
    }
    
    
    func checkIfConnectedToGNSS(){
    
        let alert = UIAlertController(title: NSLocalizedString("satellitelist.text", comment: ""), message: NSLocalizedString("stListMessage.text", comment: ""), preferredStyle: .alert)
       alert.addAction(.init(title: "Ok", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
        
    }
    
     // MARK: - Setup Notification Center From CGFramework
    func setupNotificationCenter(){
       // listSat = CG_ListSamplesSatellites()
        listSat = CG_ListSamplesSatellites()
        gotListSat(notification: .init(name: .init("")))
        NotificationCenter.default.addObserver(self, selector: #selector(gotListSat(notification:)), name: NSNotification.Name(rawValue: "listSat"), object: nil)
        
        
    }
     // MARK: - Handle Notification Center
    @objc func gotListSat(notification: Notification){
        //updates
        
        if notification.userInfo?["listSat"] != nil{
            listSat = notification.userInfo!["listSat"] as? CG_ListSamplesSatellites
        }
        NtotalGPS.text = String(format: "%d", listSat.getNGPS())
        NtotalGalileo.text = String(format: "%d", listSat.getNGALILEO())
        NtotalGLONASS.text = String(format: "%d", listSat.getNGLONASS())
        let totalGNSSFromSample = listSat.getNGPS() + listSat.getNGALILEO() + listSat.getNGLONASS()
        lb_NtotalSat.text = String(format: "%d", totalGNSSFromSample)
        lb_NusingSat.text = "> 4"
        
        print("update notification gotListSat")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func viewDidDisappear(_ animated: Bool) {
        //stop callback listSat
        listSat.stopRotineNotication()
    }
}
