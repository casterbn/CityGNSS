//
//  ChooseBLETableViewController.swift
//  CityGNSS
//
//  Created by Tiago Maia on 11/07/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit
import CoreBluetooth

class ChooseBLETableViewController: UITableViewController, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager?
    var peripherals = Array<CBPeripheral>()
    var flagBLEisOff:Bool = false
    var peripheralConnected: CBPeripheral?
    var str:String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Initialise CoreBluetooth Central Manager
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        str = ""
        
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        debugPrint("peripherals.count = \(peripherals.count)")
        return peripherals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        
        let cellImg : UIImageView = UIImageView(frame: CGRect(x: 4, y: 15, width: 12, height: 12))
        cellImg.image = UIImage(named: "bluetooth-51")
        cell.addSubview(cellImg)

        cell.layoutIfNeeded()
        
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ble = peripherals[indexPath.row]
        debugPrint(ble)
        connectToDevice(blePeripheral: ble)
        
        
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //scanning for devices and add new to the list
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //peripheral with no name will be not added
        if let p = peripheral.name {
            if(!p.isEmpty){
                if !peripherals.contains(peripheral){
                    peripherals.append(peripheral)
                    tableView.reloadData()
                }
            }
        }
    }
    //connect to a device
    func connectToDevice (blePeripheral: CBPeripheral) {
        centralManager?.connect(blePeripheral, options: nil)
        debugPrint(blePeripheral)
        
    }
    //get information of the device connected:  centralManager(_:didConnect) delegate function to provide incoming information about the newly connected peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("*****************************")
        print("Connection complete")
        print("Peripheral info: \(peripheral)")
        
        if(peripheral.state == .connected){
            peripheralConnected = peripheral
        }
        
        //Stop Scan- We don't need to scan once we've connected to a peripheral. We got what we came for.
        centralManager?.stopScan()
        print("Scan Stopped")
        
        //Erase data that we might have
        //data.length = 0
        
        //Discovery callback
        //peripheralConnected?.delegate = self  //need to get callback functions
        //Only look for services that matches transmit uuid
        
        //debugPrint(peripheral.description)
        
        //peripheral.discoverServices(nil)  //need to get services to notify
        
        ////////
        //set sharedBleConnected and go back
        sharedBleConnected.centralManager = self.centralManager
        if(peripheralConnected != nil){
            sharedBleConnected.setPeripheralConnected(ble: peripheralConnected!)
            sharedBleConnected.hasDeviceConnected = true
        }
        
        //if is done go back
        navigationController?.popViewController(animated: true)
    }
    //discovering services for connected device: didDiscoverService() handles and filters services, so that we can use whichever service we are interested in right away
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("*****************************************")
        print("didDiscoverServices")
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        //We need to discover the all characteristic
        for service in services {
            
            peripheral.discoverCharacteristics(nil, for: service)
        }
        print("Discovered Services: \(services)")
    }
    //discoverCharacteristics(_:) function, the central manager will call the didDiscoverCharacteristicsFor() delegate function and provide the discovered characteristics of the specified service.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("*******************************************************")
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        print("Found \(characteristics.count) characteristics!")
        
        for characteristic in characteristics {
            //looks for the right characteristic
            //BLE_Characteristic_uuid_Rx
//            if characteristic.uuid.isEqual(peripheral.charac)  {
//                rxCharacteristic = characteristic
//
//                //Once found, subscribe to the this particular characteristic...
//                peripheral.setNotifyValue(true, for: rxCharacteristic!)
//                // We can return after calling CBPeripheral.setNotifyValue because CBPeripheralDelegate's
//                // didUpdateNotificationStateForCharacteristic method will be called automatically
//                peripheral.readValue(for: characteristic)
//                print("Rx Characteristic: \(characteristic.uuid)")
//            }
//            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Tx){
//                txCharacteristic = characteristic
//                print("Tx Characteristic: \(characteristic.uuid)")
//            }
            peripheral.discoverDescriptors(for: characteristic)
            debugPrint(characteristic)
            
            print("peripheral:\(peripheral) and service:\(service)")
            for characteristic in service.characteristics!
            {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        print("didUpdateValue : \(peripheral)")
        print("characteristic changed:\(characteristic)")
        print("error \(String(describing: error))")
        
        //value to ascii
        print("characteristics properties \(characteristic.properties)")
        print("characteristics value \(String(describing: String(bytes: characteristic.value!, encoding: String.Encoding.utf8)))")
        
        
        
        debugPrint("----------------------------------------------------------")
        let s = String(bytes: characteristic.value!, encoding: String.Encoding.utf8)
        if(s != nil){
            if( !(s?.contains("\n"))! ){
                str.append(s!)
            }else{
                str.append(s!)
                debugPrint("String value: \(String(describing: str))")
                str = ""
            }
        }
        debugPrint("----------------------------------------------------------")
        
    }
    
    //error connecting, show alert with error
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
    
        let alert = UIAlertController(title:"Failed connecting to device", message: "Failed to connect \(peripheral) cause of \(String(describing: error))", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler:{ action in
            switch action.style{
            case .default:
                self.dismiss(animated: true, completion: nil)
                break;
            case .cancel:
                break
            case .destructive:
                break
            @unknown default:
                fatalError()
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    

}



// check if have connection tto a device bluetooth
extension ChooseBLETableViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch (central.state) {
        case .poweredOff:
            // do something like alert the user that ble is not on
            debugPrint("centralManager Bluetooth is off")
            flagBLEisOff = true
            
            let alert = UIAlertController(title:"Turn on Bluetooth", message: "Need to turn ON bluetooth to scan BLE devices", preferredStyle: .alert)
            alert.addAction(.init(title: "Try again", style: .default, handler:{ action in
                switch action.style{
                case .default:
                    //after bluetooth is on, try get CoreBluetoothCentralManager for scanning devices
                    self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
                    
                case .cancel:
                    break
                case .destructive:
                    break
                @unknown default:
                    fatalError()
                }}))
            self.present(alert, animated: true, completion: nil)
            
            
            
        case .unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            debugPrint("bluetooth is unauthorized")
            
            
        case .unknown:
            // Wait for another event
            debugPrint("bluetooth is unknow")
            
            
        case .poweredOn:
            
            debugPrint("bluetooth is on")
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            
        case .resetting:
            debugPrint("bluetooth is resetting")
            
            
        case .unsupported: break
            
        @unknown default:
            debugPrint("centralManager Bluetooth fatal and unknow error")
        }
    }
}


/*
 this way Open Settings in any action
 //            if let url = URL(string:"App-Prefs:root=Bluetooth") {
 //                if UIApplication.shared.canOpenURL(url) {
 //                    if #available(iOS 10.0, *) {
 //                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
 //                    } else {
 //                        UIApplication.shared.openURL(url)
 //                    }
 //                }
 //            }
 */
