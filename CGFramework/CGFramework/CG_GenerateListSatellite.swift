//
//  CG_GenerateListSatellite.swift
//  CGFramework
//
//  Created by Tiago Maia on 28/06/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation

class CG_GenerateListSatellite{
 
    
    
    var listSatellite: Array<CG_Satelitte> = []
    var auxlistSatellite: Array<CG_Satelitte> = []
    static var maxSat = 31
    var nGPS : Int = 0
    var nGlonass : Int = 0
    var nGalileo : Int = 0
    
    init() {
       //createOneDayGNSSOrbit()
        
    }
    
    func createOneDayGNSSOrbit(){
        
        nGalileo = Int.random(in: 0..<9)
        nGlonass = Int.random(in: 0..<11)
        nGPS =  Int.random(in: 3..<11)
        var lastID: Int = 0
        auxlistSatellite.removeAll()
        
        if(nGalileo != 0){
            for _ in 0 ... nGalileo - 1{
                let id = Int.random(in: 1..<36)
                let sat = CG_Satelitte(name: ConstellationType.GALILEO.description, id: (id == lastID ? Int.random(in: 1..<36) : id))
                lastID = id
                sat.azimuth = Float.random(in: 0..<360)
                sat.elevation = Float.random(in: 0..<90)
                sat.carrierToNoise = Float.random(in: 0..<20)
                sat.hdop = Float.random(in: 0..<5)
                sat.vdop = Float.random(in: 0..<5)
                sat.pseudorange = Double.random(in: 23000..<23222)
                sat.carrier = Double.random(in: 1400..<1599)
                //add sample satellite
                auxlistSatellite.append(sat)
            }
        }
        if(nGlonass != 0) {
            for _ in 0 ... nGlonass - 1{
                let id = Int.random(in: 700..<799)
                let sat = CG_Satelitte(name: ConstellationType.GLONASS.description, id: (id == lastID ? Int.random(in: 700..<799) : id))
                lastID = id
                sat.azimuth = Float.random(in: 0..<360)
                sat.elevation = Float.random(in: 0..<90)
                sat.carrierToNoise = Float.random(in: 0..<20)
                sat.hdop = Float.random(in: 0..<5)
                sat.vdop = Float.random(in: 0..<5)
                sat.pseudorange = Double.random(in: 19000..<19500)
                sat.carrier = Double.random(in: 1600..<1799)
                //add sample satellite
                auxlistSatellite.append(sat)
            }
        }
        
        if(nGPS != 0){
            for _ in 0 ... nGPS - 1 {
                let id = Int.random(in: 1..<64)
                let sat = CG_Satelitte(name: ConstellationType.GPS.description, id: (id == lastID ? Int.random(in: 1..<64) : id))
                lastID = id
                sat.azimuth = Float.random(in: 0..<360)
                sat.elevation = Float.random(in: 0..<90)
                sat.carrierToNoise = Float.random(in: 0..<20)
                sat.hdop = Float.random(in: 0..<5)
                sat.vdop = Float.random(in: 0..<5)
                sat.pseudorange = Double.random(in: 35990..<36100)
                sat.carrier = Double.random(in: 1600..<1799)
                //add sample satellite
                auxlistSatellite.append(sat)
            }
        }
      
        
        listSatellite = auxlistSatellite
        //debugPrint("CG_GenerateListSatellite: createOneDayGNSSOrbit()")
        //debugPrint("CG_GenerateListSatellite: listSatellite.count= \(listSatellite.count)")
    }
    
    public func getNGPS() -> Int{
        return nGPS
    }
    
    public func getNGLONASS() -> Int{
        return nGlonass
    }
    
    public func getNGALILEO() -> Int{
        return nGalileo
    }
}


/*
 
 let randomInt = Int.random(in: 0..<6)
 let randomDouble = Double.random(in: 2.71828...3.14159)
 let randomBool = Bool.random()
 
 
 func getConstellationType(satIndex: Int) -> Int {
 var constellation: Int
 switch listSatellite[satIndex].name  {
 case ConstellationType.GALILEO.description:
 constellation = ConstellationType.GALILEO.value
 case ConstellationType.GLONASS.description:
 constellation = ConstellationType.GLONASS.value
 case ConstellationType.GPS.description:
 constellation = ConstellationType.GPS.value
 default:
 constellation = ConstellationType.UNKNOW.value
 }
 return constellation
 }
 */
