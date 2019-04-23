//
//  ThirdViewController.swift
//  RunningRecorder
//
//  Created by 黄嘉华 on 2018/11/2.
//  Copyright © 2018 jhhuang. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ThirdViewController: UITableViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    private var fetchedRC: NSFetchedResultsController<User>!
    private var userInfo: UserInfo = UserInfo()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBAction func logoutButtonIsClicked(_ sender: Any) {
        if appDelegate.currentUser.user_id == -1 {
            return
        }
        let request = User.fetchRequest() as NSFetchRequest<User>
        request.predicate = NSPredicate(format: "username == %@", userInfo.user_name)
        var users: [User] = []
        do {
            users = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch, \(error), \(error.userInfo)")
        }
        print(users[0].active)
        users[0].active = false
        
        do {
            try context.save()
        } catch let error as NSError {
            print("cannot save, \(error)")
        }

        context.delete(users[0])

        appDelegate.currentUser.user_id = -1
        appDelegate.currentUser.user_name = ""
        usernameLabel.text! = "未登录"
        emailLabel.text! = "person@example.com"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        userInfo = appDelegate.currentUser
        
        if userInfo.user_id != -1 {
            usernameLabel.text = userInfo.user_name
            emailLabel.text = userInfo.email
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            if indexPath.section == 0 {
                if userInfo.user_id == -1 {
                    performSegue(withIdentifier: "GoToLoginSegue", sender: self)
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToLoginSegue" {
            let vc = segue.destination as! LoginTableViewController
            vc.thirdUserNameLabel = self.usernameLabel
            vc.thirdEmailLabel = self.emailLabel
        }
    }
    
    
    
    

}
