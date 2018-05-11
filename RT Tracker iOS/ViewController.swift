//
//  ViewController.swift
//  RT Tracker iOS
//
//  Created by Shawon Ashraf on 5/11/18.
//  Copyright © 2018 Shawon Ashraf. All rights reserved.
//

import UIKit
import PusherSwift
import Alamofire
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate {
    // Vars
    //
    //location marker
    var locationMarker: GMSMarker!
    
    // default values
    var longitude = 23.7612372
    var lattitude = 90.4322414
    
    // Pusher object
    var pusher: Pusher!
    
    
    // Outlets
    //
    // simulate button
    @IBOutlet weak var simulateButton: UIButton!
    // map view
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let camera = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: 15)
        mapView.camera = camera
        mapView.delegate = self
        
        // create a location marker at the center of the map
        locationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: lattitude, longitude: longitude))
        locationMarker.map = mapView
        
        // connect to pusher
        //
        listenForCoordUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Actions
    //
    // simuylate movement
    @IBAction func simulateLocation(_ sender: Any) {
        
    }
    
    
    // private helper functions
    //
    // connect to pusher service
    private func listenForCoordUpdates() {
        // Instantiate Pusher
        pusher = Pusher(key: "PUSHER_APP_KEY", options: PusherClientOptions(host: .cluster("PUSHER_APP_CLUSTER")))
        // Subscribe to a Pusher channel
        let channel = pusher.subscribe("mapCoordinates")
        //
        // Listener and callback for the "update" event on the "mapCoordinates"
        // channel on Pusher
        //
        channel.bind(eventName: "update", callback: { (data: Any?) -> Void in
            if let data = data as? [String: AnyObject] {
                self.longitude = data["longitude"] as! Double
                self.lattitude  = data["latitude"] as! Double
                //
                // Update marker position using data from Pusher
                //
                self.locationMarker.position = CLLocationCoordinate2D(latitude: self.lattitude, longitude: self.longitude)
                self.mapView.camera = GMSCameraPosition.camera(withTarget: self.locationMarker.position, zoom: 15.0)
            }
        })
        // Connect to pusher
        pusher.connect()
    }
}

