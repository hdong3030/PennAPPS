//
//  FirstViewController.swift
//  PennApps
//
//  Created by Helen Dong on 9/6/19.
//  Copyright © 2019 Helen Dong. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var status: UISegmentedControl!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var settings: UIButton!
    
    @IBOutlet weak var revertButton: UIButton!
    
    var user = UserInformation(information: ["","","",""])
    
    let locationManager = CLLocationManager()
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation() //need to add timer to update location some time

        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.layer.cornerRadius = 30
        
        revertButton.layer.cornerRadius = 30
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //change this and the info.plist to be always not inuse
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        map.tintColor = UIColor.gray
        
        if #available(iOS 11.0, *) {
            map.register(PersonMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            print("Not iOS 11 or after")
        }
        
        // let allPeople = PersonList(numPerson: 10, minLat: 37.8, maxLat: 37.9, minLong: -122.5, maxLong: -122.4) Alcatraz
        
        let allPeople = PersonList(numPerson: 10, minLat: 39.9, maxLat: 40.0, minLong: -75.3, maxLong: -75.1) // Philadelphia
        
        let people = allPeople.generateList() //
        
        for p in people {
            
            map.addAnnotation(p)
        }
        

    }
    

    
    @IBAction func statusBarChange(_ sender: UISegmentedControl) {
        switch status.selectedSegmentIndex {
        case 0:
            map.tintColor = UIColor.red
        case 1:
            map.tintColor = UIColor.orange
        case 2:
            map.tintColor = UIColor.gray
        case 3:
            map.tintColor = UIColor(red:0.09, green:0.99, blue:0.25, alpha:1.0)
        case 4:
            map.tintColor = UIColor(red:0.46, green:0.89, blue: 0.90, alpha:1.0)
        default:
            break
        }
    }
    
    @IBAction func infoButton(_ sender: AnyObject) {
        
    }
    
    
    @IBAction func userZoom(_ sender: Any) {
        self.locationManager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        if segue.destination is UINavigationController {
            let navVC = segue.destination as? UINavigationController
            let dest = navVC?.viewControllers.first as? InfoButtonViewController
            dest?.user = user
        }
    }
    
    
    
    

}
