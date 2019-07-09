//
//  NMEATableViewController.swift
//  CityGNSS
//
//  Created by Tiago Maia on 29/05/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit
import CoreLocation

class NMEATableViewController: UITableViewController {
    
    
    
    //accessing location data source
    var location = LocationManager()
    var delegate: MenuControllerDelegate?
    
    let timestampFormatter = DateFormatter()
    let nmeaDateFormatter = DateFormatter()
    var isStartedNMEA: Bool = true
    var nmeaDataString = [String](repeating: "waiting...", count: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureNavigationBar(with: self.navigationController?.navigationBar)
        navigationItem.title = NSLocalizedString("nmeadata.text", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-filled-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(exportData(sender:)))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        //set delegate for location
        location.delegate = self
       
        timestampFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        timestampFormatter.dateFormat = "HHmmss.SSS"
        
        nmeaDateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        nmeaDateFormatter.dateFormat = "ddMMyy"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.rowHeight = UITableView.automaticDimension
    }

    @objc func handleMenuToggle(){
        delegate?.handleMenuToggle(forMenuOption: .none)
    }

    @objc func exportData(sender: UIButton){
        print("save data")
        
       
        let date = Date()
        let currentDateTime =  nmeaDateFormatter.string(from: date)
        
        let strFileName = "CityGNSS-\(currentDateTime).nmea"
        let filename = getDocumentsDirectory().appendingPathComponent(strFileName)
      
        let array : NSArray = nmeaDataString as NSArray
        DispatchQueue.main.async {
        
                let fileURL = NSURL(fileURLWithPath: filename)

            do{
                try array.write(to: fileURL as URL)
            }catch{ }//(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                
            
                let objectsToShare = [fileURL] //objectsToShare
            
             
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            // exclude some activity types from the list (optional)
           // activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
    //        DispatchQueue.main.async {
                activityVC.popoverPresentationController?.sourceView = sender
                self.present(activityVC, animated: true, completion: nil)
           
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nmeaDataString.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as UITableViewCell
        // Configure the cell...
        let cell = UITableViewCell()
        cell.textLabel?.text = self.nmeaDataString[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 10.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .justified
        return cell
    }
    

    // MARK: -  method that make alls setence in unique file
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    // MARK: -  method convert degress to nmea
    func convertCLLocationDegreesToNmea(degrees: CLLocationDegrees) -> Double {
        let degreeSign = ((degrees > 0.0) ? 1.0 : ((degrees < 0.0) ? -1.0 : 0));
        let degree = abs(degrees);
        let degreeDecimal = floor(degree);
        let degreeFraction = degree - degreeDecimal;
        let minutes = degreeFraction * 60.0;
        let nmea = degreeSign * (degreeDecimal * 100.0 + minutes);
        return nmea;
    }
    // MARK: -  method checksum that verify integrety of any setence for other devices
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
    
    //MARK: - sentence parser for actual location of this device
    func workNMEALocation(location: CLLocation){
        
    
      //  DispatchQueue.main.async {
       // for location in locations {
            let latitude = convertCLLocationDegreesToNmea(degrees: location.coordinate.latitude)
            let longitude = convertCLLocationDegreesToNmea(degrees: location.coordinate.longitude)
            
            // GPGGA - Global Positioning System Fix Data
            // http://www.gpsinformation.org/dale/nmea.htm#GGA
            var nmea0183GPGGA = "GPGGA," + self.timestampFormatter.string(from: location.timestamp)
            nmea0183GPGGA += String(format: ",%08.4f,", arguments: [abs(latitude)])
            nmea0183GPGGA += latitude > 0.0 ? "N" : "S"
            nmea0183GPGGA += String(format: ",%08.4f,", arguments: [abs(longitude)])
            nmea0183GPGGA += longitude > 0.0 ? "E" : "W"
            nmea0183GPGGA += ",1,08,1.0,"
            nmea0183GPGGA += String(format: "%1.1f,M,%1.1f,M,,,", arguments: [location.altitude, location.altitude])
            nmea0183GPGGA += String(format: "*%02lX", arguments: [nmeaSentenceChecksum(sentence: nmea0183GPGGA)])
            nmea0183GPGGA = "$" + nmea0183GPGGA
            
            // GPRMC - Recommended minimum specific GPS/Transit data
            // http://www.gpsinformation.org/dale/nmea.htm#RMC
            var nmea0183GPRMC = "GPRMC," + self.timestampFormatter.string(from: location.timestamp) + ",A,"
            nmea0183GPRMC += String(format: "%08.4f,", arguments: [abs(latitude)])
            nmea0183GPRMC += latitude > 0.0 ? "N" : "S"
            nmea0183GPRMC += String(format: ",%08.4f,", arguments: [abs(longitude)])
            nmea0183GPRMC += longitude > 0.0 ? "E" : "W"
            nmea0183GPRMC += String(format: ",%04.1f,", arguments: [(location.course > 0.0 ? location.speed * 3600.0 / 1000.0 * 0.54 : 0.0)])
            nmea0183GPRMC += String(format: "%04.1f,", arguments: [(location.course > 0.0 ? location.course : 0.0)])
            nmea0183GPRMC += self.nmeaDateFormatter.string(from: location.timestamp)
            nmea0183GPRMC += ",,,A"
            nmea0183GPRMC += String(format: "*%02lX", arguments: [nmeaSentenceChecksum(sentence: nmea0183GPRMC)])
            nmea0183GPRMC = "$" + nmea0183GPRMC
            
            // Log
            print(nmea0183GPGGA)
            print(nmea0183GPRMC)
        
        addNewNMEArow(gpgga: nmea0183GPGGA, gprmc: nmea0183GPRMC)
        //}
    }
    
    func addNewNMEArow(gpgga: String, gprmc: String){
        // Adding new item to data source
        nmeaDataString.append(gpgga)
        nmeaDataString.append(gprmc)
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isStartedNMEA = false
    }
    
    
}

//MARK: - get location from LocationManagerDelegate
extension NMEATableViewController :  LocationManagerDelegate{
    func locationDidUpdate(with location: CLLocation) {
        if isStartedNMEA {
            print("remove all")
            isStartedNMEA = false
            nmeaDataString.removeAll()
            tableView.reloadData()
        }
        self.workNMEALocation(location: location)
    }
}



