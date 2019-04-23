//
//  RunningResultViewController.swift
//  RunningRecorder
//
//  Created by 黄嘉华 on 2018/11/3.
//  Copyright © 2018 jhhuang. All rights reserved.
//

import UIKit
import CoreData

class RunningResultViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var minute: Int = 0
    var second: Int = 0
    var distance: Double = 0.0
    var avgSpeed: Double = 0.0
    var beginningTime: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text! = String(format: "%02d'%02d''", minute, second)
        distanceLabel.text! = String(format: "%.2f KM", distance/1000.0)
        speedLabel.text! = String(format: "%.2f M/S", avgSpeed)
        saveResultToDB()
    }
    
    func saveResultToDB() {
        let running = Running(entity: Running.entity(), insertInto: context)
        running.userID = Int32(appDelegate.currentUser.user_id)
        running.beginningTime = beginningTime
        running.distance = distance
        running.speed = avgSpeed
        running.duration = Int32(minute * 60 + second)
        appDelegate.saveContext()
        debugPrint()
    }
    
    func debugPrint() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Running")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "distance") as! Double)
            }
            
        } catch let error as NSError {
            print("Could not fetch, \(error), \(error.userInfo)")
        }
    }
    

}
