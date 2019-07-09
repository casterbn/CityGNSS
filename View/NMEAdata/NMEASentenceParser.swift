//
//  NMEASentenceParser.swift
//  CityGNSS
//
//  Created by Tiago Maia on 05/06/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation

typealias Byte = UInt8

extension UInt8 {
    var hexValue:String {
        return (self < 16 ? "0":"") + String(self, radix:16, uppercase:true)
    }
}

/*
 Allows to test against nil multiple variables aton once.
 */
extension Collection where Element == Optional<Any> {
    func allNotNil() -> Bool {
        return self.compactMap { $0 }.count > self.count
    }
    
    func atleastOneNotNil() -> Bool {
        return self.compactMap { $0 }.count > 0
    }
    
    func allNil() -> Bool {
        return self.compactMap { $0 }.count == 0
    }
    
    func atleastOneIsNil() -> Bool {
        return self.contains { $0 == nil }
    }
}

class NMEASentenceParser {
    static let shared = NMEASentenceParser()
    
    private init() {}
    
    func parse(_ nmeaSentence:String) -> Any? {
        if nmeaSentence.isEmpty {
            return nil
        }
        
        if nmeaSentence.hasPrefix("$GPGGA") {
            return GPGGA(nmeaSentence)
        } else if nmeaSentence.hasPrefix("$GPGSA") {
            return GPGSA(nmeaSentence)
        }
        
        return nil
    }
    
    //Generic class
    class NMEASentence {
        private var sentence:String
        var trimmedSentence:String
        
        var isValid:Bool {
            get {
                return sentence.suffix(2) == checksum().hexValue
            }
        }
        
        func checksum() -> UInt8 {
            var xor:UInt8 = 0
            for i in 0..<trimmedSentence.utf8.count {
                xor = xor ^ Array(trimmedSentence.utf8)[i]
            }
            return xor
        }
        
        init?(_ nmeaSentence:String) {
            sentence = nmeaSentence
            
            //duplicate sentence trimmed from its "$" and checksum
            let start = sentence.index(sentence.startIndex, offsetBy: 1)
            let end = sentence.index(sentence.endIndex, offsetBy: -3)
            trimmedSentence = String(sentence[start..<end])
            
            if isValid == false {
                return nil
            }
            
        }
        
    }
    
    /*
     Source: https://www.gpsinformation.org/dale/nmea.htm
     GGA - essential fix data which provide 3D location and accuracy data.
     
     $GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47
     
     Where:
     GGA          Global Positioning System Fix Data
     123519       Fix taken at 12:35:19 UTC
     4807.038,N   Latitude 48 deg 07.038' N
     01131.000,E  Longitude 11 deg 31.000' E
     1            Fix quality:
     0 = invalid
     1 = GPS fix (SPS)
     2 = DGPS fix
     3 = PPS fix
     4 = Real Time Kinematic
     5 = Float RTK
     6 = estimated (dead reckoning) (2.3 feature)
     7 = Manual input mode
     8 = Simulation mode
     08           Number of satellites being tracked
     0.9          Horizontal dilution of position
     545.4,M      Altitude, Meters, above mean sea level
     46.9,M       Height of geoid (mean sea level) above WGS84
     ellipsoid
     (empty field) time in seconds since last DGPS update
     (empty field) DGPS station ID number
     *47          the checksum data, always begins with *
     */
    class GPGGA:NMEASentence {
        override init?(_ nmeaSentence:String) {
            //init will fail if
            super.init(nmeaSentence)
            
            let splittedSentence = trimmedSentence.split(separator: ",", maxSplits: Int.max, omittingEmptySubsequences: false)
            
            utcTime = Float(splittedSentence[1])
            latitude = Coordinate(splittedSentence[2], splittedSentence[3])
            longitude = Coordinate(splittedSentence[4], splittedSentence[5])
            fixQuality = FixQuality(rawValue: Int(splittedSentence[6]) ?? -1)
            numberOfSatellites = Int(splittedSentence[7])
            horizontalDilutionOfPosition = Float(splittedSentence[8])
            mslAltitude = Float(splittedSentence[9])
            mslAltitudeUnit = String(splittedSentence[10])
            heightOfGeoid = Float(splittedSentence[11])
            heightOfGeoidUnit = String(splittedSentence[10])
            
            if [utcTime,latitude,longitude,fixQuality,numberOfSatellites,horizontalDilutionOfPosition,mslAltitude,mslAltitudeUnit,heightOfGeoid,heightOfGeoidUnit].atleastOneIsNil() == true {
                return nil
            }
        }
        var utcTime:Float?
        var latitude:Coordinate?
        var longitude:Coordinate?
        var fixQuality:FixQuality?
        var numberOfSatellites:Int?
        var horizontalDilutionOfPosition:Float?
        var mslAltitude:Float?
        var mslAltitudeUnit:String?
        var heightOfGeoid:Float?
        var heightOfGeoidUnit:String?
    }
    
    /*
     $GPGSA,A,3,04,05,,09,12,,,24,,,,,2.5,1.3,2.1*39
     
     Where:
     GSA      Satellite status
     A        Auto selection of 2D or 3D fix (M = manual)
     3        3D fix - values include: 1 = no fix
     2 = 2D fix
     3 = 3D fix
     04,05... PRNs of satellites used for fix (space for 12)
     2.5      PDOP (dilution of precision)
     1.3      Horizontal dilution of precision (HDOP)
     2.1      Vertical dilution of precision (VDOP)
     *39      the checksum data, always begins with *
     */
    class GPGSA:NMEASentence {
        override init?(_ nmeaSentence:String) {
            super.init(nmeaSentence)
            
            let splittedSentence = trimmedSentence.split(separator: ",", maxSplits: Int.max, omittingEmptySubsequences: false)
            
            fixSelectionMode = FixSelectionMode(rawValue: Character(String(splittedSentence[1])))
            threeDFixMode = FixMode(rawValue: Int(splittedSentence[2]) ?? 0)
            for i in 0..<12 {
                prn.append(Int(splittedSentence[3+i]))
            }
            pdop = Float(splittedSentence[15])
            hdop = Float(splittedSentence[16])
            vdop = Float(splittedSentence[17])
            
            //prn can definitely contail nil values, as less than 12 GPS can be in sight
            if [fixSelectionMode, threeDFixMode, hdop, vdop, pdop].atleastOneIsNil() == true {
                return nil
            }
        }
        
        var fixSelectionMode:FixSelectionMode?
        var threeDFixMode:FixMode?
        var prn = [Int?]()
        var pdop:Float?
        var hdop:Float?
        var vdop:Float?
    }
    
    
    
    struct Coordinate {
        var coordinate:Float?
        var direction:Direction?
        
        init?(_ coordinate:Substring, _ direction:Substring) {
            self.coordinate = Float(coordinate)
            guard self.coordinate != nil else {
                return nil
            }
            self.direction = Direction(String(direction))
            guard self.direction != nil else {
                return nil
            }
        }
    }
    
    enum FixSelectionMode:Character {
        case manual = "M"
        case auto = "A"
    }
    
    enum FixMode:Int {
        case nofix = 1
        case twod = 2
        case threed = 3
    }
    
    enum Direction:Character {
        case north = "N"
        case south = "S"
        case east = "E"
        case west = "W"
        
        init?(_ direction:String) {
            switch String(direction) {
            case "N":
                self = .north
            case "S":
                self = .south
            case "E":
                self = .east
            case "W":
                self = .west
            default:
                return nil
            }
        }
    }
    
    enum FixQuality:Int {
        case Invalid = 0
        case GPSFixSPS = 1
        case DGPSFix = 2
        case PPSFix = 3
        case RealTimeKinematic = 4
        case FloatRTK = 5
        case Estimated = 6
        case ManualInputMode = 7
        case SimulationMode = 8
    }
}
