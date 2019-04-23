//
//  AppDelegate.swift
//  RunningRecorder
//
//  Created by 黄嘉华 on 2018/11/2.
//  Copyright © 2018 jhhuang. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var currentUser: UserInfo! = UserInfo()
    let locationManager = CLLocationManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "User")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if currentUser.user_id == -1 {
            let context = persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    if data.value(forKey: "active") as! Bool == true {
                        currentUser.email = data.value(forKey: "email") as! String
                        currentUser.user_name = data.value(forKey: "username") as! String
                        currentUser.key = data.value(forKey: "key") as! String
                        currentUser.user_id = Int(data.value(forKey: "id") as! Int32)
                    }
                }
                
            } catch let error as NSError {
                print("Could not fetch, \(error), \(error.userInfo)")
            }
        }
        locationManager.requestWhenInUseAuthorization()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

