//
//  LocationInfoViewController.swift
//  CityGNSS
//
//  Created by Tiago Maia on 22/05/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit




class LocationInfoViewController: UIViewController {

    var delegate: MenuControllerDelegate?
    
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lb_latitude: UILabel!
    @IBOutlet weak var lb_longitude: UILabel!
    
    //
    var  container : LocInfoTableViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //init configureation of navigationbar
        configureNavigationBar()
        
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
    
    //MARK: - Setups configurations
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        
        navigationItem.title = "Location Info"
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home-filled-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-filled-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        print("debug: \(navigationItem.leftBarButtonItem)")
        
    }
    
    
    
    //MARK: - setup values of containers
    func setupContainer(){
        
        //container.
        
    }
    
    //change values between switch
    @IBAction func switchAPI(_ sender: Any) {
        if(segmentSwitch.selectedSegmentIndex == 0){
            print("sender is 0")
        }else{
            print("sender is \(segmentSwitch.selectedSegmentIndex)")
        }
        
    }
    
    

}
