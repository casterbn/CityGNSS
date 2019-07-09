//
//  MenuController.swift
//  SNLocation
//
//  Created by Tiago Maia on 12/04/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit

//FF4338 -> red
//607D8B -> gray


class MenuController: UIViewController {
    
   
    
    // MARK: - Properties
    static let reuseIdentifier = "MenuOptionCell"
    static let NUMBER_OF_ITEMS = 6
    var tableView: UITableView!
    var delegate: MenuControllerDelegate?
    var lastIndex:IndexPath!
    
    // MARK: - Init
   
    init() {
        super.init(nibName: nil, bundle: nil)
         lastIndex = NSIndexPath(row: 0, section: 0) as IndexPath
    }
  
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        configureTableView()
    }
    
    
    // MARK: - Handlers
    func configureTableView(){
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: MenuController.reuseIdentifier)
        
        //set background color side menu view
        tableView.backgroundColor = UIColor(hexString: "#f8f8f8");
        
        //set separator style
        tableView.separatorStyle = .none
        
        // set size height of each row
        tableView.rowHeight = 60
        
        let viewForlabel = UIView()
        //viewForlabel.backgroundColor = UIColor(hexString: "#FF4338")
        view.addSubview(viewForlabel)
        
        //add table view to configure cells os items of the menu
        view.addSubview(tableView)
        
        if let window = UIApplication.shared.keyWindow {
//            let safeAreaBottom = window.safeAreaInsets.bottom
//            let safeAreaLeft = window.safeAreaInsets.left
//            let safeAreaRight = window.safeAreaInsets.right
            let safeAreaTop = window.safeAreaInsets.top
            
            
            let labelCityGNSS = UILabel()
            
            //get app name
            labelCityGNSS.text = "CityGNSS"//Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        
            labelCityGNSS.textColor = .white
            labelCityGNSS.font = UIFont.boldSystemFont(ofSize: 26.0)
            labelCityGNSS.translatesAutoresizingMaskIntoConstraints = false
            viewForlabel.addSubview(labelCityGNSS)
            viewForlabel.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(safeAreaTop)-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view" : viewForlabel]))
             self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view" : viewForlabel]))
            
//            let horizontalConstraint = NSLayoutConstraint(item: labelCityGNSS, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//            let verticalConstraint = NSLayoutConstraint(item: labelCityGNSS, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
//            let widthConstraint = NSLayoutConstraint(item: labelCityGNSS, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
//            let heightConstraint = NSLayoutConstraint(item: labelCityGNSS, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
//            NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
           
            
            tableView.translatesAutoresizingMaskIntoConstraints = false;
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(safeAreaTop + 44)-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view" : tableView!]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view" : tableView!]))
        }
        
        
        //configuration os view table of side menu
        /*tableView.translatesAutoresizingMaskIntoConstraints = false;
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        
       //constraints superview
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: space).isActive = true;*/
        tableView.remembersLastFocusedIndexPath = false
        tableView.selectRow(at: lastIndex, animated: false, scrollPosition: .none)
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let indexPath = NSIndexPath(row: 0, section: 0)
        tableView.selectRow(at: lastIndex, animated: false, scrollPosition: .none)
        //add background after delay
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor (hexString: "#FF4338")
        }, completion:nil)
        

    }
}



extension MenuController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(MenuController.NUMBER_OF_ITEMS)
        return MenuController.NUMBER_OF_ITEMS
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuController.reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        //get value (icon and label) to put in side menu sorted
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        cell.iconImageView.image = menuOption?.image
       
        
        //background cell when selected
        //cell.selectionStyle = .none //if no style when selected
        let backgroundView = UIView()
        //backgroundView.backgroundColor = .init(red: 255/255, green: 59/255, blue: 48/255, alpha: 0.6)
        backgroundView.backgroundColor = UIColor(hexString: "#d4d4d4", alpha: 0.5)
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        if(menuOption.self == MenuOption.SETTINGS){
            //deselectSelectedRow(animated: false)
            tableView.selectRow(at: lastIndex, animated: false, scrollPosition: .none)
          //  print("Debug: MenuController() menuOption \(menuOption) lastindex \(lastIndex)")
        }else{
            lastIndex = indexPath
        }
        delegate?.handleMenuToggle(forMenuOption: menuOption)
        
    }
    
    func deselectSelectedRow(animated: Bool)
    {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow
        {
            
            tableView.deselectRow(at: indexPathForSelectedRow, animated: animated)
            
        }
    }
    
    public func selectRowLocationInfo(menuOption: MenuOption){
        lastIndex = IndexPath(item: 1, section: 0)
        if(tableView != nil)
        { tableView.selectRow(at: lastIndex, animated: false, scrollPosition: .none) }
    }
    
    
}

