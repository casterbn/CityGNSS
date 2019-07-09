//
//  UIViewControllerConfigureNavBar.swift
//  CityGNSS
//
//  Created by Tiago Maia on 12/06/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation
import UIKit

// this extension is commum for all ViewController for this project
// this set the color of navbar

extension UIViewController {
    
    func configureNavigationBar(with navigationBar: UINavigationBar? ) {
        
        navigationBar?.barStyle = .black
        navigationBar?.barTintColor = UIColor(hexString: "#FF4338")
        navigationBar?.isTranslucent = false
        navigationBar?.prefersLargeTitles = false
        
    }
    
}
