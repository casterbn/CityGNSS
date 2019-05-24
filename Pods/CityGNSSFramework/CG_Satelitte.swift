//
//  CG_Satellite.swift
//  CityGNSSFramework
//
//  Created by Tiago Maia on 15/05/2019.
//

import UIKit

class CG_Satelitte: NSObject {
    
    var name: String?           //Constellation name
    var id: Int?                //id of satellite
    var hdop: Int?              //horizontal dilution of precision
    var vdop: Int?              //vertical dilution of precision
    var elevation: Float?       //elevation in degrees
    var azimuth: Float?         //azitmuth in degrees
    var carrier: Double?        //carrier in MHz
    var carrierToNoise: Float?  //noise in DB per MHz
    var pseudorange: Double?    //distance in km
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    
    
    
    
    
    override var description: String {
        return "(\(String(describing: name!)), \(id!))"
    }
    
    func info(){
        print(self.description)
    }
}
