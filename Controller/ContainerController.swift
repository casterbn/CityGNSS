//
//  ContainerController.swift
//  SNLocation
//
//  Created by Tiago Maia on 12/04/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit



protocol MenuControllerDelegate{
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
}


class ContainerController: UIViewController {
    
    // MARK: - Properties
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var menuController: MenuController!
    var homeController: HomeController!
    var currentViewController: UIViewController!
    var isMenuExpanded = false
    var isTrueAnimteStatusBar = true       //this setting can be edited here directly //
    var lastMenuOption: MenuOption!
   
   
   
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call function configureController to set all steps of navigationController
        
        configureHomeController()
    }
    
    
    //set background status bar color light (for dark backgrounds) of the iOS
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    //animation od status bar
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    override var prefersStatusBarHidden: Bool{
        return isMenuExpanded
    }
    
    // MARK: - Handlers
    
    
    func configureHomeController(){
        
        lastMenuOption = .MAP
        // current = HomeController()
        //to be embedded in a navigation controller
        //let = ...
        homeController = HomeController()
        //call homeController delegate to be have this as delegate
        homeController.delegate = self
        //call UI navigation controller and set that rootViewController
        currentViewController = UINavigationController(rootViewController: homeController)
        //appdelegate.window!.rootViewController = currentViewController /* teste navigation controller */
        //set view controller
         view.addSubview(currentViewController.view)
         addChild(currentViewController)
         currentViewController.didMove(toParent: self);
        
        //configure menu controller
        menuController = MenuController()
        menuController.delegate = self
    }
    
  
    
    func configureAboutController(){
        
        let aboutController = AboutController()

        aboutController.delegate = self
        
        
       // navController.viewControllers = [aboutController]
       // let  navController = UINavigationController(rootViewController: aboutController)
       // let _:UIStoryboard = UIStoryboard(name: "ContainerController",bundle: nil)
       // let dvc = mainStoreBoard.instantiateViewController(withIdentifier: "aboutController")
       
        
        // navigationController?.pushViewController(aboutController, animated: false)
        // navigationController?.popToViewController(aboutController, animated: false)
        // navigationController?.present(aboutController, animated: false, completion: nil)
        // navigationController?.willMove(toParent: aboutController)
       // navigationController?.pushViewController(aboutController, animated: true)
        
//        self.view.window!.rootViewController = navController
//        self.view.window?.makeKeyAndVisible()
        //aboutController.delegate = self
        //if(menuController == nil) {return}
        //aboutController.view.insertSubview(menuController.view, at: 0)
        //aboutController.addChild(menuController)
        //menuController.didMove(toParent: aboutController)
        //navController.setViewControllers([aboutController], animated: true)
       
       
   

//
        //currentViewController.navigationController?.replaceTopViewController(with: aboutController, animated: true)
        //currentViewController = aboutController
       /**/ // navigationController?.replaceTopViewController(with: aboutController, animated: false)
        //new.replaceTopViewController(with: aboutController, animated: false)
        
        
        
        present(aboutController, animated:true, completion:nil)
        
        
       
        
        setTransitionFromRight()
        
        print("pushViewController")
        //present(aboutController, animated: false)
//        self.navigationController?.pushViewController(navController, animated: false)
       
        //present(navController, animated: false)
        
        
//        aboutController.delegate = self
//
//        centerController = UINavigationController(rootViewController: aboutController)
//
//        view.addSubview(centerController.view)
//        addChild(centerController)
//        centerController.didMove(toParent: self);
        
        
       
    }
    
    
    //function to show the side menu
    func animateshowMenuPanel(shouldExpand: Bool, menuOption: MenuOption?){
        
        if(currentViewController == nil){return}
        
        if shouldExpand { //==true
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                //set width window of side menu, all width size minus some
                self.currentViewController.view.frame.origin.x = self.currentViewController.view.frame.width - 180
                
            }, completion: nil)
        }else{
            // hide menu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:  .curveEaseIn, animations: {
                //set width window = 0 i'll be hided

                self.currentViewController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                if(menuOption != self.lastMenuOption || menuOption == .SETTINGS){
                    
                    self.didSelectMenuOption(menuOption: menuOption)
                    if(menuOption != .SETTINGS){
                        self.lastMenuOption = menuOption
                    }
                   
                }else{
                    self.currentViewController.reloadInputViews()
                }
            }
        }
        
        if isTrueAnimteStatusBar{
            animateStatusBar()
        }
    }
    
    //method that invoke each view for each option of the menu
    func didSelectMenuOption(menuOption: MenuOption){
        
        if(currentViewController == nil){return}
        //self.centerController?.view.removeFromSuperview()
        //self.centerController = nil
       
        
        
        
        switch menuOption{
        case .MAP:
            print("Show Map as home")
            homeController = HomeController()
            homeController.delegate = self
            //homeController.delegate = self
            replaceViewController(forNextViewController: homeController)
            
        case .LOCATIONINFO:
            print("Show location info")
            let locationInfoStoryboard = UIStoryboard(name: "LocationInfo", bundle: nil)
            let controller = locationInfoStoryboard.instantiateViewController(withIdentifier: "LocationIfoStoryboard") as! LocationInfoViewController
            controller.delegate = self
            replaceViewController(forNextViewController: controller)
            //self.present(controller, animated: true, completion: nil)
        case .SATELLITELIST:
            print("Show satellite list")
        case .NMEADATA:
            print("Show nmeadata")
        case .SETTINGS:
            print("Show settings")
            //setTransitionFromRight()
            //let controller = SettingsController()
           // present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            
//            let viewController = TableViewController()
//            present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
            
            
          
            
            let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
           // if(settingsStoryboard == nil){ return }
            
            let controller = settingsStoryboard.instantiateInitialViewController() as! TableViewController
            controller.delegate = homeController.self
            
            self.present(UINavigationController(rootViewController: controller), animated: true)
            
        case .ABOUT:
            print("Show about")
            let controller = AboutController()
            controller.delegate = self
            replaceViewController(forNextViewController: controller)
            
        }
        
    }
    
    //animation status bar when menu is expanded
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    //shadow for container
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            currentViewController.view.layer.shadowOpacity = 0.8
            currentViewController.view.layer.shadowRadius = 4.0
            
            
        } else {
            currentViewController.view.layer.shadowOpacity = 0.0
            currentViewController.view.layer.shadowRadius = 0.0
            
            
        }
    }
    
 
    
}

extension ContainerController: MenuControllerDelegate{
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        //if side menu isn't expand set menuController
        if !isMenuExpanded {
            
            //if menuController == nil{
                //add menu controller here
                view.insertSubview(menuController.view, at: 0)
                addChild(menuController)
                menuController.didMove(toParent: self)
            
               
                print("Did menu controller was added?")
                view.backgroundColor = .gray
           // }
           
            
            print("about isMenuExpanded \(isMenuExpanded)")
        }
        
        //show shadow if menu is expanded
        showShadowForCenterViewController(!isMenuExpanded)
        //if side menu is expanded will be closed
        //else if side isn't expanded will be showed
        isMenuExpanded = !isMenuExpanded
        //call show menu method
        animateshowMenuPanel(shouldExpand: isMenuExpanded, menuOption: menuOption)
        
    }
    
    

    // MARK: - transition effect
    
    func setTransitionFromRight(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear)
        view.window!.layer.add(transition, forKey: kCATransition)
        //present(dashboardWorkout, animated: false, completion: nil)
    }
   
    
    // MARK: - change ViewController
    
    func replaceViewController(forNextViewController nextViewController:UIViewController){
        
        let newVC = UINavigationController(rootViewController: nextViewController)      // 1
        addChild(newVC)                                                                 // 2
        newVC.view.frame = view.bounds                                                  // 3
        view.addSubview(newVC.view)                                                     // 4
        newVC.didMove(toParent: self)                                                   // 5
        currentViewController.willMove(toParent: nil)                                   // 6
        currentViewController.view.removeFromSuperview()                                // 7
        currentViewController.removeFromParent()                                        // 8
        currentViewController = newVC
        setTransitionFromRight()
        
    }
    
}



