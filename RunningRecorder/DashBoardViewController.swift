//
//  DashBoardViewController.swift
//  RunningRecorder
//
//  Created by 黄嘉华 on 2018/11/2.
//  Copyright © 2018 jhhuang. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class DashBoardViewController: UIViewController {
    
    var timer: Timer! = Timer()
    var secondCount: Int = 0
    var minuteCount: Int = 0
    var timerIsStopped: Bool = false
    var currentSpeed: Double = 0.0
    var distance: Double = 0.0
    private let locationManager: CLLocationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
    
    
    
    var last: CLLocation?
    var timerCount: Int = 0
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var distanceKMLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        startReceivingLocationChanges()
        // Do any additional setup after loading the view.
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateClock() {
        secondCount += 1
        if secondCount == 60 {
            secondCount = 0
            minuteCount += 1
        }
        timerCount += 1
        secondLabel.text = String(format: "%02d", secondCount)
        minuteLabel.text = String(format: "%02d:  ", minuteCount)
        updateDistanceAndSpeed()
    }
    
    @objc func updateDistanceAndSpeed() {
        // just for debug
//        currentSpeed = distance / Double(minuteCount * 60 + secondCount)
        
        distanceKMLabel.text! = String(format: "%.2f", distance/1000.0)
        speedLabel.text! = String(format: "%.2f", currentSpeed)
    }
    
    @IBAction func stopButtonIsClicked(_ sender: Any) {
        if (timerIsStopped) {
            timerIsStopped = false
            endButton.isEnabled = false
            pauseButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            startTimer()
        }
        else {
            timerIsStopped = true
            endButton.isEnabled = true
            //pauseButton.value(forKey: "暂停")
            pauseButton.setImage(#imageLiteral(resourceName: "resume"), for: .normal)
            timer.invalidate()
        }
    }
    
    @IBAction func endButtonIsClicked(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        self.performSegue(withIdentifier: "FinishRunningSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinishRunningSegue" {
            if let resultVC = segue.destination as? RunningResultViewController {
                resultVC.avgSpeed = distance / Double(60 * minuteCount + secondCount)
                resultVC.minute = minuteCount
                resultVC.second = secondCount
                resultVC.distance = distance
            }
            
        }
    }
    
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            print("not authorized")
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            print("service not started")
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 2.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        print("great")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DashBoardViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if last != nil {
            let curr = locations.last
            if !timerIsStopped {
                let d = curr?.distance(from: last!)
                let duration = Double(timerCount)
                let v = d! / duration
                if v > 10 {
                    distance += 10.0 * duration
                    currentSpeed = 10.0
                } else {
                    distance += d!
                    currentSpeed = v
                }
                print("\(d!) / \(duration)")
            }
        } else {
            last = locations.last
            print("hi")
        }
        timerCount = 0
    }
}
