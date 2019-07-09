//
//  CG_Interface.swift
//  CityGNSS
//
//  Created by Tiago Maia on 15/05/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit

protocol CG_Interface {

    var listSatellite: Array<CG_Satelitte> { set get }
    
    
    
    func getSatelliteCount() -> Int                     // Gets the total number of satellites in satellite list.
    func getConstellationType(satIndex: Int) -> Int     // Retrieves the constellation type of the satellite at the specified index.
    func getConstellationName(satIndex: Int) -> String  // Retrieves the constellation name of the satellite at the specified index.
    func getSvid(satIndex: Int) -> Int                  // Gets the identification number for the satellite at the specific index.
    func getAzimuthDegrees(satIndex: Int)->Float        // Retrieves the azimuth the satellite at the specified index.
    func getElevationDegrees(satIndex: Int)->Float      // Retrieves the elevation of the satellite at the specified index.
    func getCarrierFrequencyHz(satIndex: Int)->Float    // Gets the carrier frequency of the signal tracked.
    func getCn0DbHz(satIndex: Int)->Float               // Retrieves the carrier-to-noise density at the antenna of the satellite at the specified index in dB-Hz.
    
    
    func getPseudoDistance()-> Double
    func getCoordinates()->Double
    func getLatitude()->Double      //Positive values indicate latitudes north of the equator. Negative values indicate latitudes south of the equator.
    func getLongitude()->Double     //Measurements are relative to the zero meridian, with positive values extending east of the meridian and negative values extending west of the meridian.
    
    
}


public enum ConstellationType: Int, CustomStringConvertible{
    //this is menu as sort
    case GPS
    case GLONASS
    case GALILEO
    case UNKNOW
    
    
    public var description: String{
        switch self{
        case .GALILEO: return "Galileo"
        case .GLONASS: return "GLONASS"
        case .GPS: return "GPS"
        case .UNKNOW: return "UNKNOW"
        }
    }
    
    
    public var value: Int{
        switch self{
        case .GALILEO: return 6
        case .GLONASS: return 3
        case .GPS: return 1
        case .UNKNOW: return 0
        }
    }
   
    
}


/*
 __Arrays in swift________________
 var mSet = Set<Country>()
 var aBucket : Country = Country()
 ...
 mSet.insert(aBucket)
 
 */
