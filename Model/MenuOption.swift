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
    
    
    /*  option detail for any case of selected option  */
    
    var description: String{
        switch self{
        case .MAP: return NSLocalizedString("map.text", comment: "Map") //"Map"
        case .LOCATIONINFO: return NSLocalizedString("locationinfo.text", comment: "Location Info")
        case .NMEADATA: return NSLocalizedString("nmeadata.text", comment: "NMEA data")
        case .SATELLITELIST: return NSLocalizedString("satellitelist.text", comment: "Satellite List")
        case .SETTINGS: return NSLocalizedString("settings.text", comment: "Settings")
        case .ABOUT: return NSLocalizedString("about.text", comment: "About")
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
