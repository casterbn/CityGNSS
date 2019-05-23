//
//  SettingsController.swift
//  SNLocation
//
//  Created by Tiago Maia on 15/04/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit

class SettingsController: UIViewController{
    
    //MARK: - properties
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("settings")
        //configure layout of the view
        configureUI()
        
    }
    
    //set background status bar color light (for dark backgrounds) of the iOS
    override var preferredStatusBarStyle: UIStatusBarStyle{
        print("is called")
        return  UIStatusBarStyle.default
    }
    
    
    //MARK: - selectors
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - helper functions
    
    func configureUI(){
        
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = .lightGray
   
        //navigationController?.navigationBar.barTintColor = .white
        //navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Settings"
        //navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleDismiss))
        //

    }
    
    
    open var hidesNavigationBarWhenPushed = false
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(hidesNavigationBarWhenPushed, animated: animated)
    }
    
}
