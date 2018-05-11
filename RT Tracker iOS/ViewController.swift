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
    // Consts
    //
    let API_URL = "https://dry-atoll-86022.herokuapp.com/api/simloc"
    
    // Vars
    //
    //location marker
    var locationMarker: GMSMarker!
    
    // default values
    var latitude = 23.7612372
    var longitude = 90.4322414
    
    // Pusher object
    var pusher: Pusher!
    
    
    // Outlets
    //
    // simulate button
    @IBOutlet weak var simulateButton: UIButton!
    // map view
    @IBOutlet weak var mapView: GMSMapView!
    // result label
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        mapView.camera = camera
        mapView.delegate = self
        
        // create a location marker at the center of the map
        locationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
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
    // simulate movement
    @IBAction func simulateLocation(_ sender: Any) {
        let parameters: Parameters = ["latitude": latitude, "longitude":longitude]
        Alamofire.request(API_URL, method: .post, parameters: parameters).validate().responseJSON { (response) in
            switch response.result {
            case .success(_):
                //print("Simulating...")
                self.resultLabel.text = "Simulating..."
            case .failure(let error):
                self.resultLabel.text = "Error! \(error.localizedDescription)"
            }
        }
    }
    
    
    // private helper functions
    //
    // connect to pusher service
    private func listenForCoordUpdates() {
        // Instantiate Pusher
        pusher = Pusher(key: "1ebaf7c01d0aa8db6fde", options: PusherClientOptions(host: .cluster("ap1")))
        // Subscribe to a Pusher channel
        let channel = pusher.subscribe("mapCoordinates")
        //
        // Listener and callback for the "update" event on the "mapCoordinates"
        // channel on Pusher
        //
        channel.bind(eventName: "update", callback: { (data: Any?) -> Void in
            if let data = data as? [String: AnyObject] {
                
                //
                // Data can be nil because of latency
                // don't update if nil
                //
                let long =  data["longitude"]
                let lat = data["latitude"]
                
                if long != nil {
                    self.longitude = long as! Double
                }
                if lat != nil {
                    self.latitude = lat as! Double
                }
                
                //
                // update label
                //
                self.resultLabel.text = "Longitude : \(self.longitude), Latitude: \(self.latitude)"
                
                //
                // Update marker position using data from Pusher
                //
                self.locationMarker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
                self.mapView.camera = GMSCameraPosition.camera(withTarget: self.locationMarker.position, zoom: 15.0)
            }
        })
        
        //
        // Connect to pusher
        //
        pusher.connect()
    }
}

