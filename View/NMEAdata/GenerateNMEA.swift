//
//  GenerateNMEA.swift
//  CityGNSS
//
//  Created by Tiago Maia on 19/06/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation
import CoreLocation

class NmeaStringForCLLocationDelegate {
    
    let timestampFormatter = DateFormatter()
    let nmeaDateFormatter = DateFormatter()

    init () {
        timestampFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        timestampFormatter.dateFormat = "HHmmss.SSS"
        
        nmeaDateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        nmeaDateFormatter.dateFormat = "ddMMyy"
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let latitude = convertCLLocationDegreesToNmea(degrees: location.coordinate.latitude)
            let longitude = convertCLLocationDegreesToNmea(degrees: location.coordinate.longitude)
            
            // GPGGA
            // http://www.gpsinformation.org/dale/nmea.htm#GGA
            var nmea0183GPGGA = "GPGGA," + timestampFormatter.string(from: location.timestamp)
            nmea0183GPGGA += String(format: ",%08.4f,", arguments: [abs(latitude)])
            nmea0183GPGGA += latitude > 0.0 ? "N" : "S"
            nmea0183GPGGA += String(format: ",%08.4f,", arguments: [abs(longitude)])
            nmea0183GPGGA += longitude > 0.0 ? "E" : "W"
            nmea0183GPGGA += ",1,08,1.0,"
            nmea0183GPGGA += String(format: "%1.1f,M,%1.1f,M,,,", arguments: [location.altitude, location.altitude])
            nmea0183GPGGA += String(format: "*%02lX", arguments: [nmeaSentenceChecksum(sentence: nmea0183GPGGA)])
            nmea0183GPGGA = "$" + nmea0183GPGGA
            
            // GPRMC
            // http://www.gpsinformation.org/dale/nmea.htm#RMC
            var nmea0183GPRMC = "GPRMC," + timestampFormatter.string(from: location.timestamp) + ",A,"
            nmea0183GPRMC += String(format: "%08.4f,", arguments: [abs(latitude)])
            nmea0183GPRMC += latitude > 0.0 ? "N" : "S"
            nmea0183GPRMC += String(format: ",%08.4f,", arguments: [abs(longitude)])
            nmea0183GPRMC += longitude > 0.0 ? "E" : "W"
            nmea0183GPRMC += String(format: ",%04.1f,", arguments: [(location.course > 0.0 ? location.speed * 3600.0 / 1000.0 * 0.54 : 0.0)])
            nmea0183GPRMC += String(format: "%04.1f,", arguments: [(location.course > 0.0 ? location.course : 0.0)])
            nmea0183GPRMC += nmeaDateFormatter.string(from: location.timestamp)
            nmea0183GPRMC += ",,,A"
            nmea0183GPRMC += String(format: "*%02lX", arguments: [nmeaSentenceChecksum(sentence: nmea0183GPRMC)])
            nmea0183GPRMC = "$" + nmea0183GPRMC
            
            // Log
            debugPrint(nmea0183GPGGA)
            debugPrint(nmea0183GPRMC)
        }
    }

    func convertCLLocationDegreesToNmea(degrees: CLLocationDegrees) -> Double {
        let degreeSign = ((degrees > 0.0) ? 1.0 : ((degrees < 0.0) ? -1.0 : 0));
        let degree = abs(degrees);
        let degreeDecimal = floor(degree);
        let degreeFraction = degree - degreeDecimal;
        let minutes = degreeFraction * 60.0;
        let nmea = degreeSign * (degreeDecimal * 100.0 + minutes);
        return nmea;
    }

    func nmeaSentenceChecksum(sentence: String) -> CLong {
        var checksum: unichar = 0;
        var stringUInt16 = [UInt16]()
        stringUInt16 += sentence.utf16
        for char in stringUInt16 {
            checksum ^= char
        }
        checksum &= 0x0ff
        return CLong(checksum)
    }

}
