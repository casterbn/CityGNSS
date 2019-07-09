//
//  CG_ListSamplesSatellites.swift
//  CGFramework
//
//  Created by Tiago Maia on 28/06/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation

public class CG_ListSamplesSatellites: CG_Interface{
    
    
    
   var listSatellite: Array<CG_Satelitte> = []
    
    
    var timer : Timer!
    let newsample: CG_GenerateListSatellite
    
    
    
    public func getSatelliteBy(satIndex:  Int) -> CG_Satelitte? {
        if newsample.listSatellite.isEmpty{
            return nil
        }
        return newsample.listSatellite[satIndex]
    }
    
    public func getSatelliteCount() -> Int {
        if newsample.listSatellite.isEmpty{
            return 0
        }
        return newsample.listSatellite.count
    }
    
    
    public func getConstellationType(satIndex: Int) -> Int {
        
        if newsample.listSatellite.isEmpty{
            return 0
        }

        var constellation: Int
        switch newsample.listSatellite[satIndex].name  {
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
    
    public func getConstellationName(satIndex: Int) -> String {
        if newsample.listSatellite.isEmpty{
            return ""
        }

        return newsample.listSatellite[satIndex].name!
    }
    
    public func getSvid(satIndex: Int) -> Int {
        if newsample.listSatellite.isEmpty{
            return 0
        }

        return newsample.listSatellite[satIndex].id!
    }
    
    public func getAzimuthDegrees(satIndex: Int) -> Float {
        if newsample.listSatellite.isEmpty{
            return 0
        }
        return newsample.listSatellite[satIndex].azimuth!
    }
    
    public func getElevationDegrees(satIndex: Int) -> Float {
        if newsample.listSatellite.isEmpty{
            return 0
        }
        return newsample.listSatellite[satIndex].elevation!
    }
    
    public func getCarrierFrequencyHz(satIndex: Int) -> Float {
        if newsample.listSatellite.isEmpty{
            return 0
        }

        return newsample.listSatellite[satIndex].carrierToNoise!
    }
    
    public func getCn0DbHz(satIndex: Int) -> Float {
        if newsample.listSatellite.isEmpty{
            return 0
        }
        return newsample.listSatellite[satIndex].carrierToNoise!
    }
    
    public func getPseudoDistance() -> Double {
        return 0
    }
    
    public func getCoordinates() -> Double {
        return 0
    }
    
    public func getLatitude() -> Double {
        return 0
    }
    
    public func getLongitude() -> Double {
        return 0
    }
    
    
   public init() {
        newsample = CG_GenerateListSatellite()
        listSatCallback()
        setupNotificationCenter()
    }
    
    public func reloadSample() {
        newsample.createOneDayGNSSOrbit()
        
    }

    
    
    public func getNGPS() -> Int{
        return newsample.getNGPS()
    }
    
    public func getNGLONASS() -> Int{
        return newsample.getNGLONASS()
    }
    
    public func getNGALILEO() -> Int{
        return newsample.getNGALILEO()
    }
    
    //share by notification this class for all APP
    func setupNotificationCenter(){
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(listSatCallback), userInfo: nil, repeats: true)
       
    }
    @objc func listSatCallback(){
        // generate first
        reloadSample()
        // notificate after
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listSat"), object: nil, userInfo: ["listSat": self])
       // debugPrint("CG_ListSamplesSatellites: update notification listCallBack")
       // debugPrint("CG_ListSamplesSatellites: listSatellite.count= \(newsample.listSatellite.count)")
    }
    
    
    //stop the Timer Schedule thread that was configured in SetupNotificationCenter()
    public func stopRotineNotication(){
        if timer.isValid {
            timer.invalidate()
        }
    }
}



//thread to do in few time
//        DispatchQueue.main.asyncAfter(deadline: when){
//
//        }
