//
//  FirstViewController.swift
//  RunningRecorder
//
//  Created by 黄嘉华 on 2018/11/2.
//  Copyright © 2018 jhhuang. All rights reserved.
//

import UIKit
import Cards
import CoreData

class FirstViewController: UITableViewController {
    
    private var fetchedRC: NSFetchedResultsController<Running>!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    func refresh() {
        let request = Running.fetchRequest() as NSFetchRequest<Running>
        let sort = NSSortDescriptor(key: #keyPath(Running.beginningTime), ascending: false)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch, \(error), \(error.userInfo)")
        }
        if let runnings = fetchedRC.fetchedObjects {
            print(runnings.count)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let runnings = fetchedRC.fetchedObjects {
            return runnings.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let card = cell.viewWithTag(1000) as! CardHighlight
        card.buttonText = "看看"
        let running = fetchedRC.object(at: indexPath)
        let distance = running.distance
        let duration = running.duration
        let time = running.beginningTime
        let formatter = DateFormatter()
        let i = abs(running.duration.hashValue)
        
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "China/Beijing")
        card.title = String(format: "%.2f KM", distance/1000)
        card.itemTitle = String(format: "%02d'%02d''", duration/60, duration%60)
        card.itemSubtitle = formatter.string(from: time!)
        
        // set the background picture
        card.backgroundImage = UIImage(named: "Running\(i % 8 + 1)")
        
        let cardContent = storyboard!.instantiateViewController(withIdentifier: "CardContent")
        
        card.shouldPresent(cardContent, from: self, fullscreen: true)
        return cell
    }
    
    


}

