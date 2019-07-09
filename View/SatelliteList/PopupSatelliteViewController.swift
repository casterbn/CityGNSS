//
//  PopupSatelliteViewController.swift
//  CityGNSS
//
//  Created by Tiago Maia on 03/07/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit
import CGFramework
class PopupSatelliteViewController: UIViewController {

    var satellite : CG_Satelitte?
    var str : String = ""
    @IBOutlet weak var satName: UILabel!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lb_id: UILabel!
    @IBOutlet weak var lb_azimuth: UILabel!
    @IBOutlet weak var lb_elevation: UILabel!
    @IBOutlet weak var lb_carrierfreq: UILabel!
    @IBOutlet weak var lb_carrierNoiseDB: UILabel!
    @IBOutlet weak var lb_pseudodistance: UILabel!
    @IBOutlet weak var lb_hdop: UILabel!
    @IBOutlet weak var lb_vdop: UILabel!
    
    override func viewDidLoad() {
       //satellite = CG_Satelitte(name: "", id:0)
        super.viewDidLoad()
        self.view.backgroundColor = .init(white: 0.3, alpha: 0.4)
        self.preferredContentSize = CGSize(width: viewPopup.frame.width, height: viewPopup.frame.height)
        
        
        // Do any additional setup after loading the view.
        satName.text = satellite?.name
        lb_id.text = "\(satellite?.id ?? 0)"
        lb_azimuth.text = "\(satellite?.azimuth ?? 0)"
        lb_elevation.text = "\(satellite?.elevation ?? 0)"
        lb_carrierfreq.text = "\(satellite?.carrier ?? 0)"
        lb_carrierNoiseDB.text = "\(satellite?.carrierToNoise ?? 0)"
        lb_pseudodistance.text = "\(satellite?.pseudorange ?? 0)"
        lb_vdop.text = "\(satellite?.vdop ?? 0)"
        lb_hdop.text = "\(satellite?.hdop ?? 0)"
        

        
    }
    
    @IBAction func buttonOK(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("popup satellite information")
     //  satellite?.info()
        //print("popup satellite: str=\(str)")
        
        
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
