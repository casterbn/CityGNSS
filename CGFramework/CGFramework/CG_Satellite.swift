//
//  CG_Satellite.swift
//  CityGNSSFramework
//
//  Created by Tiago Maia on 15/05/2019.
//

import UIKit

public class CG_Satelitte: NSObject {
    
   
    
    public var name: String?           //Constellation name
    public var id: Int?                //id of satellite
    public var hdop: Float?            //horizontal dilution of precision
    public var vdop: Float?            //vertical dilution of precision
    public var elevation: Float?       //elevation in degrees
    public var azimuth: Float?         //azitmuth in degrees
    public var carrier: Double?        //carrier in MHz
    public var carrierToNoise: Float?  //noise in DB per MHz
    public var pseudorange: Double?    //distance in km The pseudorange is the pseudo distance between a satellite and a navigation satellite receiver —for instance Global Positioning System receivers.
    
   public init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    
    
    
    
    
   public override var description: String {
        return "(\(String(describing: name!)), \(id!))"
    }
    
   public func info(){
        print(self.description)
    }
    
    
    
}
