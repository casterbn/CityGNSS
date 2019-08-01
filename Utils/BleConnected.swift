//
//  BleConnected.swift
//  CityGNSS
//
//  Created by Tiago Maia on 12/07/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation
import CoreBluetooth


// this class is global singleton, variable global, shared for entire project,


let sharedBleConnected = BleConnected()

class BleConnected {

    var centralManager: CBCentralManager?
    var peripheralConnected: CBPeripheral?
    var hasDeviceConnected: Bool
    
    
    init() {
        hasDeviceConnected = false
    }
    
    
    //check first if has any device
    func getPeripheralConnected()->CBPeripheral{
      return peripheralConnected!
    }
    
    func setPeripheralConnected(ble: CBPeripheral){
        peripheralConnected = ble
        hasDeviceConnected = true
    }
    func setCentralManager(centralManager: CBCentralManager){
        self.centralManager = centralManager
    }
    func getCentralManager()->CBCentralManager{
        return centralManager!
    }
    
    
    //stop
    func stopConnection(){
        if(hasDeviceConnected){
            if(peripheralConnected != nil){
                centralManager?.cancelPeripheralConnection(peripheralConnected!)
            }
        }
    }
    
    
}

