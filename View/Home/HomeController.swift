//
//  HomeController.swift
//  SNLocation
//
//  Created by Tiago Maia on 12/04/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CityGNSSFramework


class HomeController: UIViewController {
    
    // MARK: - Properties
     let udSwithMapTypeConstant = "SwithMapTypeConstant"
    
    var delegate: MenuControllerDelegate?
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    var coord_latitude : Double = 0.0
    var coord_longitude : Double = 0.0
    var altitude: CLLocationDistance = 0.0
    var timestamp: Date = Date.init()
    
    let YOURLOCATION = MKPointAnnotation()
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set background controller the home view container
        view.backgroundColor = .white
        
        
        //load user defaults settings
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: udSwithMapTypeConstant)) {
            userChangedMapType(data: true)
        } else {
            userChangedMapType(data: false)
        }
        
        //inititiate
        configureLocationManager()
        
        //configure navigattionbar
        configureNavigationBar()
        
        let sat = CG_Satelitte(name: "String", id: 12)
        sat.info()
        
    }
    
    // MARK: - Handlers
    @objc func handleMenuToggle(){
        
        delegate?.handleMenuToggle(forMenuOption: nil)
        print("MenuToggle")
        
    }
    
    // MARK: - Functions
    func configureLocationManager(){
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        let status = CLLocationManager.authorizationStatus()
        

        if status == .notDetermined{
            //popup was not shown
            locationManager.requestAlwaysAuthorization()
        }else if status == .authorizedAlways || status == .authorizedWhenInUse {
          
            if CLLocationManager.locationServicesEnabled() {
                
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation //accuracy
                locationManager.allowsBackgroundLocationUpdates = true
                locationManager.startUpdatingLocation()
                
                print("map locationServicesEnabled")
                locateData()
            }
        }
        map.delegate = self
    }
    
    
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        
        navigationItem.title = "CityGNSS"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-filled-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
    }
    
    
    
    func locateData(){
        guard let coordinate: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        print("locations = \(coordinate.latitude) \(coordinate.longitude)")
        
        print("locate data map")
        
        
        //vars ===================== LOCATION_MANAGER ==========
        
        coord_latitude = coordinate.latitude
        coord_longitude = coordinate.longitude
        altitude = locationManager.location?.altitude ?? 0.0
        timestamp = locationManager.location?.timestamp ?? Date.init()
        
        
        //======================================================
        
        YOURLOCATION.coordinate = coordinate
        YOURLOCATION.title = "You're here!"
        YOURLOCATION.subtitle = "lat: \(coordinate.latitude) long: \(coordinate.longitude)"
        
        
        map.userLocation.title = "You're here"
        map.userLocation.subtitle = "lat: \(coordinate.latitude) long: \(coordinate.longitude)"
        map.showsUserLocation = true
        map.showsCompass = true
    
    
    
        
        //map.addAnnotation(YOURLOCATION)
    
        //teste  new anotation
       // var cav = CustomAnnotationView()
        
        
        map.camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 500, pitch: 0, heading: 0)
        
        
       // let annotation = MKPointAnnotation()
        //map.showAnnotations([annotation], animated: true)
        //map.addAnnotation(annotation)
   
        let annotation = MKPinAnnotationView()
        annotation.rightCalloutAccessoryView?.addSubview(CustomAnnotationView())
//        map.addAnnotation(annotation as! MKAnnotation)
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // let local = locations.last!.coordinate
        //map.camera = MKMapCamera(lookingAtCenter: local, fromDistance: 500, pitch: 0, heading: 0)
        
        print("update map")
        locateData()
    }
    
    override func applicationFinishedRestoringState() {
        configureLocationManager()
    }
    
    
    
    //Custom Annotation View
    
    private func customAnnotationView(in mapView: MKMapView, for annotation: MKAnnotation) -> CustomAnnotationView {
        let identifier = "CustomAnnotationViewID"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let customAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            customAnnotationView.canShowCallout = true
            return customAnnotationView
        }
    }
    
}



//MKMapViewDelegate method

extension HomeController:MKMapViewDelegate{
    
    
    
    //MARK: - view
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//       print("HomeController:MKMapViewDelegate")
//
//        guard annotation is MKPointAnnotation else { return nil }
//         print("HomeController: MKPointAnnotation")
//        let customAnnotationView = self.customAnnotationView(in: mapView, for: annotation)
//        customAnnotationView.number = arc4random_uniform(10)
//        return customAnnotationView
//
////        let view:MKAnnotationView!
////
////        if let dequed = map.dequeueReusableAnnotationView(withIdentifier: "pin") {
////            view = dequed
////        }
////        else {
////            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
////        }
////
////        let x = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
////        x.backgroundColor = UIColor.lightGray
////
////        // shows the red
////        //view.leftCalloutAccessoryView = x
////
////        // working as no subtitle - but no red view
////        view.detailCalloutAccessoryView = x
////
////        view.canShowCallout = true
////        return view
//    }
//
   
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // 2
           // guard let annotation = annotation as? MKAnnotation else { return nil }
            // 3
            let identifier = "ioslocation"
            var view: MKMarkerAnnotationView
            // 4
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 5
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                view.glyphText = "iOS"
                view.markerTintColor = .blue
               
            }
            return view
        }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if !(annotation is MKUserLocation) {
//            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
//
//            let rightButton = UIButton(type: .contactAdd)
//            rightButton.tag = annotation.hash
//
//            pinView.animatesDrop = true
//            pinView.canShowCallout = true
//            pinView.rightCalloutAccessoryView = rightButton
//
//            return pinView
//        }
//        else {
//            return nil
//        }
//    }
//    func mapView(_ mapView: MKMapView, annotationCanShowCallout annotation: MKAnnotation) -> Bool {
    // Always allow callouts to popup when annotations are tapped.
       // return true
//        return annotation.responds(to: #selector(getter: MKAnnotation.title)) && annotation.title! == "Hello world!"
//    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("mapView(_:annotationView:calloutAccessoryControlTapped)")
        
        //open view info
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
   
}


//Custom Subview

class CustomAnnotationView: MKAnnotationView {
    
    
    private let annotationFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
    private let label: UILabel
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
         print("CustomAnnotationView annotationview")
        self.label = UILabel(frame: annotationFrame.offsetBy(dx: 0, dy: -6))
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = annotationFrame
        self.label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        self.label.textColor = .white
        self.label.textAlignment = .center
        self.backgroundColor = .clear
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented!")
    }
    
    public var number: UInt32 = 0 {
        didSet {
            self.label.text = String(number)
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        context.closePath()
        
        UIColor.blue.set()
        context.fillPath()
    }
    
}


extension HomeController: DataSettingsDelegate{
    //Protocol in SettingsView
    func userChangedMapType(data: Bool) {
        if data  {
            //"Satellite":
            map.mapType = .satellite
        }else{
            map.mapType = .standard
        }
        
    }
}

//extension AppDelegate {
//    static var shared: AppDelegate {
//        return UIApplication.shared.delegate as! AppDelegate
//    }
//    var rootViewController: UIViewController {
//        return window!.rootViewController as! UIViewController
//    }
//}


//class CustomAnnotationView: MKAnnotationView {
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Use CALayer’s corner radius to turn this view into a circle.
//        layer.cornerRadius = bounds.width / 2
//        layer.borderWidth = 2
//        layer.borderColor = UIColor.white.cgColor
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Animate the border width in/out, creating an iris effect.
//        let animation = CABasicAnimation(keyPath: "borderWidth")
//        animation.duration = 0.1
//        layer.borderWidth = selected ? bounds.width / 4 : 2
//        layer.add(animation, forKey: "borderWidth")
//    }
//}


