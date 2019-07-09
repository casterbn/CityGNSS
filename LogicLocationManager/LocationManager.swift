import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    
    // Passing in a coordinate to the delegate method
    func locationDidUpdate(with location: CLLocation)
}



class LocationManager: NSObject {
    
    
    let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        configureLocationManager()
    }
    

    
    func configureLocationManager(){
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
      
    }
    
    
}



extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("authorizedWhenInUse")
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation //accuracy
            manager.allowsBackgroundLocationUpdates = true
            manager.startUpdatingLocation()
            manager.requestLocation()
        }
        
        if(status == .denied){
             locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // Pass the location into the delegate method
            self.delegate?.locationDidUpdate(with: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
    

}
