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





class HomeController: UIViewController {
    
    // MARK: - Properties
     let udSwithMapTypeConstant = "SwithMapTypeConstant"
    
    var delegate: MenuControllerDelegate?
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var iv_annotationView: UIImageView!
    @IBOutlet weak var lb_latitude: UILabel!
    @IBOutlet weak var lb_longitude: UILabel!
    @IBOutlet weak var view_accuracy: UIView!
    
    //single class to manages the location
    let locationManager = LocationManager()
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
        //configureLocationManager()
        //location = app.locationManager.locationManager
         locationManager.delegate = self
        
        //configure navigattionbar
        configureNavigationBar(with: self.navigationController!.navigationBar)
        navigationItem.title = "CityGNSS"
       navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-filled-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        
        map.delegate = self
        view_accuracy.isHidden = false
      
    }

   
    
    
    
    // MARK: - Handlers
    @objc func handleMenuToggle(){
        
        delegate?.handleMenuToggle(forMenuOption: nil)
        print("MenuToggle")
        
    }
    
    
    
  
    
    
    
    func funcInitMapData(location: CLLocation){
       
        YOURLOCATION.coordinate = location.coordinate
        YOURLOCATION.title = "You're here!"
        YOURLOCATION.subtitle = "lat: \(location.coordinate.latitude) long: \(location.coordinate.longitude)"
        
        map.accessibilityIdentifier = "iosloc"
        map.userLocation.title = "You're here"
        map.userLocation.subtitle = "lat: \(String(format: "%.8f meters", location.coordinate.latitude)) long: \(String(format: "%.8f meters", location.coordinate.longitude))"
        map.showsCompass = true
        map.showsUserLocation = true
        

        //need to change the next labels
        // accuracy values are the number of meters from the original geographic coordinate that could yield the user's actual location.
        lb_latitude.text = String(format: "%.3f meters", location.horizontalAccuracy)
        lb_longitude.text = String(format: "%.3f meters", location.verticalAccuracy)
       
    }
    
 
    
    
    //Custom Annotation View
    
    private func customAnnotationView(in mapView: MKMapView, for annotation: MKAnnotation) -> CustomAnnotationView {
        let identifier = "CustomAnnotationViewID"
         print("customAnnotationView")
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

extension HomeController:MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        // guard let annotation = annotation as? MKAnnotation else { return nil }
        // 3
//        guard !(annotation is MKUserLocation) else {
//             print("annotation nil")
//            return nil
//        }

        let identifier = "iOS"
       
/// ------------------------------------------------------------------
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
            view.calloutOffset = CGPoint(x: 0, y: 20)
            view.leftCalloutAccessoryView = UIButton(type: .system)
            view.glyphText = "iOS"
            //view.markerTintColor = .blue
            let button = UIButton(type: UIButton.ButtonType.infoDark) as UIButton
            button.addTarget(self, action: #selector(showMoreInformation(sender:)), for: UIControl.Event.touchUpInside)
            view.rightCalloutAccessoryView = button
/// ------ descomentar
            
           
        }
    

        
       print("annotation + \(view.debugDescription)")
        return view
    }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("mapView(_:annotationView:calloutAccessoryControlTapped)")
        
        //open view info
        
        print("do nothing")
    }
    
    //update region when receives updates to center user location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
        //print("update map region")
        mapView.setRegion(region, animated: true)
        
        
    }
    
    @objc func teste(sender: UIButton!) {
        print("this button action is a test")
    }

    @objc func showMoreInformation(sender: UIButton!) {
        delegate?.selectChangeView(forMenuOption: .LOCATIONINFO)
    }
    func getViewCallout()->UIView{
        var viewCallout: UIView
        let label_info: UILabel
        viewCallout = UIView(frame: CGRect(x: 0, y: 0, width: 180, height: 140))
        viewCallout.backgroundColor = .gray
        label_info = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        label_info.text = "informacion"
        let button = UIButton(type: UIButton.ButtonType.infoDark) as UIButton
        button.addTarget(self, action: #selector(showMoreInformation(sender:)), for: UIControl.Event.touchUpInside)
        viewCallout.addSubview(button)
        viewCallout.addSubview(label_info)
       
        return viewCallout
    }
    
}




    extension HomeController: LocationManagerDelegate {
        func locationDidUpdate(with location: CLLocation) {
            // Use the coordinate you fetched.
            //print("extension locationManager locations = \(location.coordinate.latitude) \(location.coordinate.longitude)")
            funcInitMapData(location: location)
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


//Custom Subview

class CustomAnnotationView: MKAnnotationView {
    
    
    private let annotationFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
    private let label: UILabel
    private var viewCallout: UIView!
   
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.label = UILabel(frame: annotationFrame.offsetBy(dx: 0, dy: -6))
        self.viewCallout = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 180))
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = annotationFrame
        self.label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        self.label.textColor = .white
        self.label.textAlignment = .center
        self.label.text = reuseIdentifier
        self.backgroundColor = .clear
        self.addSubview(label)
        

       // self.detailCalloutAccessoryView = getViewCallout()
        //self.viewCallout = getViewCallout()
        //self.inputView?.addSubview(getViewCallout())
       
        
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


