//
//  LocationInfoViewController.swift
//  CityGNSS
//
//  Created by Tiago Maia on 22/05/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit
import CoreLocation



class LocationInfoViewController: UIViewController {

    var delegate: MenuControllerDelegate?
    
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lb_latitude: UILabel!
    @IBOutlet weak var lb_longitude: UILabel!
    @IBOutlet weak var viewCoordinates: UIView!
    @IBOutlet weak var viewInfoTable: UIView!
    @IBOutlet weak var lb_warning: UILabel!
    
    
    //accessing a info table view <- uitableview
    var  container : LocInfoTableViewController!
    
    //accessing location data source
    var location = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //init configureation of navigationbar
        configureNavigationBar(with: self.navigationController?.navigationBar)
        navigationItem.title = NSLocalizedString("locationinfo.text", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-filled-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        //navigationItem.leftBarButtonItem?.tintColor = .white
        
        //set delegate for location
        location.delegate = self
        
        //init tableview
        container = self.children[0] as? LocInfoTableViewController
        
        setupContainer()
    }
    
    //MARK: - Handles
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleMenuToggle(){
        
        print("--- handlemenutoggle ---")
        
        delegate?.handleMenuToggle(forMenuOption: .none)
        //dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        //print("MenuToggle: delegate is nil: \(delegate == nil)")
        //print("---/ handlemenutoggle ---")
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    //MARK: - setup values of containers
    func setupContainer(){
        
        //container.
        container.lb_altitude_text.text  = NSLocalizedString("altitude.text", comment: "");
        container.lb_utctime_text.text = NSLocalizedString("utc.text", comment: "");
        container.lb_speed_text.text = NSLocalizedString("speed.text", comment: "");
        container.lb_Haccuracy_text.text = NSLocalizedString("haccuracy.text", comment: "");
        container.lb_Vaccuracy_text.text = NSLocalizedString("vaccuracy.text", comment: "");
        
    }
    
    //change values between switch
    @IBAction func switchAPI(_ sender: Any) {
        if(segmentSwitch.selectedSegmentIndex == 0){
           if !lb_warning.isHidden
           {
            lb_warning.isHidden = true
            viewInfoTable.isHidden = false
            viewCoordinates.isHidden = false
            }
        }else{
            if lb_warning.isHidden
            {
                lb_warning.isHidden = false
                viewInfoTable.isHidden = true
                viewCoordinates.isHidden = true
            }
            
        }
        
    }
    
    
    func updateDataInfo(location: CLLocation ){
        
        lb_latitude.text = String(format: "%f", location.coordinate.latitude)
        lb_longitude.text =  String(format: "%f", location.coordinate.longitude)
        container.lb_utctime.text =  "\(location.timestamp)"
        container.lb_altitude.text = String(format: "%f m",location.altitude)
        container.lb_speed.text = String(format: "%.3f m/s",(location.speed < 0 ? "" : location.speed))
        container.lb_Haccuracy.text = String(format: "%.3f m", location.horizontalAccuracy)
        container.lb_Vaccuracy.text = String(format: "%.3f m", location.verticalAccuracy)
        container.lb_hdop.text = "-"
        container.lb_vdop.text = "-"
        print("other information")
        print("direction -> \(location.course)")
    }

}

extension LocationInfoViewController : LocationManagerDelegate {
    func locationDidUpdate(with location: CLLocation) {
        print("update")
        updateDataInfo(location: location)
    }
}
