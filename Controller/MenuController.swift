//
//  MenuController.swift
//  SNLocation
//
//  Created by Tiago Maia on 12/04/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit




class MenuController: UIViewController {
    
   
    
    // MARK: - Properties
    static let reuseIdentifier = "MenuOptionCell"
    static let NUMBER_OF_ITEMS = 6
    var tableView: UITableView!
    var delegate: MenuControllerDelegate?
    var lastIndex:IndexPath!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    
    // MARK: - Handlers
    func configureTableView(){
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: MenuController.reuseIdentifier)
        
        //set background color side menu view
        tableView.backgroundColor = .gray
        
        //set separator style
        tableView.separatorStyle = .none
        
        // set size height of each row
        tableView.rowHeight = 60
        
        //add table view to configure cells os items of the menu
        view.addSubview(tableView)
        
        if let window = UIApplication.shared.keyWindow {
//            let safeAreaBottom = window.safeAreaInsets.bottom
//            let safeAreaLeft = window.safeAreaInsets.left
//            let safeAreaRight = window.safeAreaInsets.right
            let safeAreaTop = window.safeAreaInsets.top
            
            
            
            tableView.translatesAutoresizingMaskIntoConstraints = false; self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(safeAreaTop + 44)-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view" : tableView!]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view" : tableView!]))
        }
        
        //configuration os view table of side menu
        /*tableView.translatesAutoresizingMaskIntoConstraints = false;
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        
       //constraints superview
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: space).isActive = true;*/
        tableView.remembersLastFocusedIndexPath = true
        
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath as IndexPath, animated: false, scrollPosition: .none)
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
        backgroundView.backgroundColor = .init(red: 255/255, green: 59/255, blue: 48/255, alpha: 0.6) 
        //backgroundView.backgroundColor = .darkGray
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        if(menuOption.self == MenuOption.SETTINGS){
            //deselectSelectedRow(animated: false)
            tableView.selectRow(at: lastIndex, animated: false, scrollPosition: .none)
        }
        delegate?.handleMenuToggle(forMenuOption: menuOption)
        lastIndex = indexPath
    }
    
    func deselectSelectedRow(animated: Bool)
    {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow
        {
            
            tableView.deselectRow(at: indexPathForSelectedRow, animated: animated)
            
        }
    }
    
    
}

