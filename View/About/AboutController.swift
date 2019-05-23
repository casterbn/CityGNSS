//
//  AboutController.swift
//  SNLocation
//
//  Created by Tiago Maia on 16/04/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit


class AboutController: UIViewController {

    var delegate: MenuControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AboutController - viewDidLoad()")
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        //configure navigattionbar
        configureNavigationBar()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func handleMenuToggle(){
        
        print("--- handlemenutoggle ---")
        
        delegate?.handleMenuToggle(forMenuOption: .none)
        //dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        //print("MenuToggle: delegate is nil: \(delegate == nil)")
        //print("---/ handlemenutoggle ---")
        
    }
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        
        navigationItem.title = "About"
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home-filled-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleMenuToggle))
         navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-filled-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        print("debug: \(navigationItem.leftBarButtonItem)")
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
//        
//        let transition = CATransition()
//        transition.duration = 0.1
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear)
//        view.window!.layer.add(transition, forKey: kCATransition)
        
        super.viewWillDisappear(animated)
    }
    
}
