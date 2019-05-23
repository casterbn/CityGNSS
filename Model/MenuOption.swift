//
//  MenuOption.swift
//  SNLocation
//
//  Created by Tiago Maia on 15/04/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//
import UIKit

enum MenuOption: Int, CustomStringConvertible{
    //this is menu as sort
    case MAP
    case LOCATIONINFO
    case SATELLITELIST
    case NMEADATA
    case SETTINGS
    case ABOUT
    
    
    var description: String{
        switch self{
        case .MAP: return "Map"
        case .LOCATIONINFO: return "Location Info"
        case .NMEADATA: return "NMEA data"
        case .SATELLITELIST: return "Satellite List"
        case .SETTINGS: return "Settings"
        case .ABOUT: return "About"
        }
    }
    
    var image: UIImage{
        switch self{
        case .MAP: return UIImage(named: "map-marker-filled-50") ?? UIImage()
        case .LOCATIONINFO: return UIImage(named: "location-filled-50") ?? UIImage()
        case .NMEADATA: return UIImage(named: "nmea-filled-50") ?? UIImage()
        case .SATELLITELIST: return UIImage(named: "satellites-50") ?? UIImage()
        case .SETTINGS: return UIImage(named: "settings-filled-50") ?? UIImage()
        case .ABOUT: return UIImage(named: "info-filled-50") ?? UIImage()
        }
    }
    
}
