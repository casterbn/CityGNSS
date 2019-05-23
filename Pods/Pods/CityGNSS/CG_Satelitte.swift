//
//  CG_Satelite.swift
//  SNLocation
//
//  Created by Tiago Maia on 29/04/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation

class CG_Satelitte{
    
    var name: String
    var id: NSInteger
    
    init(name: String, id: NSInteger) {
        self.name = name
        self.id = id
    }
    
    var description: String {
        return "(\(name), \(id))"
    }
}
