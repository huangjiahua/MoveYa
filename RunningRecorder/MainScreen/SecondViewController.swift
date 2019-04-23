//
//  SecondViewController.swift
//  RunningRecorder
//
//  Created by 黄嘉华 on 2018/11/2.
//  Copyright © 2018 jhhuang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController {

    @IBOutlet weak var startRunningButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        startRunningButton.isEnabled = true
        mapView.showsUserLocation = true
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startAction(_ sender: Any) {
        startRunningButton.isEnabled = false
        countdownLabel.text! = "3"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of s
            self.countdownLabel.text! = "2"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of s
            self.countdownLabel.text! = "1"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // change 2 to desired number of s
            self.countdownLabel.text! = ""
            self.performSegue(withIdentifier: "StartDashBoardSegue", sender: nil)
        }
        
    }
    
    func updateLocation(_ userLocation: MKUserLocation) {
        let coordinate = userLocation.coordinate
        let viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200)
        mapView.setRegion(viewRegion, animated: false)
    }
    

    
}

extension SecondViewController: MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView1: MKMapView) {
        updateLocation(mapView1.userLocation)
    }
    
    func mapView(_ mapView1: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateLocation(userLocation)
    }
}



