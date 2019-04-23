//
//  SigninTableViewController.swift
//  RunningRecorder
//
//  Created by 黄嘉华 on 2018/11/7.
//  Copyright © 2018 jhhuang. All rights reserved.
//

import UIKit
import Foundation

class SigninTableViewController: UITableViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordText1: UITextField!
    @IBOutlet weak var passwordText2: UITextField!
    
    var badBit: Int = 0
    
    @IBAction func doneButtonIsPressed(_ sender: Any) {
        let title = "错误"
        if userNameText.text != nil && userNameText.text!.isEmpty {
            showAlert(title: title, message: "用户名不能为空")
            return
        }
        
        if let email = emailTextField.text {
            if email.isEmpty {
                showAlert(title: title, message: "Email 不能为空")
                return
            }
            if !isValidEmail(testStr: email) {
                showAlert(title: title, message: "Email 格式不正确")
                return
            }
        }
        
        if let pwd1 = passwordText1.text {
            if let pwd2 = passwordText2.text {
                if pwd1.isEmpty || pwd2.isEmpty {
                    showAlert(title: title, message: "密码不能为空")
                    return
                }
                if pwd1 != pwd2 {
                    showAlert(title: title, message: "两项密码不相同")
                    return
                }
                if pwd1.count < 8 || pwd1.count > 64 {
                    showAlert(title: title, message: "密码在 8-64 位")
                    return
                }
            }
        }
        
        let userName = userNameText.text!
        let email = emailTextField.text!
        let password = passwordText1.text!
        register(un: userName, em: email, pwd: password)
        

    }
    
    func showAlert(title: String, message: String, isDone: Bool = false) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            if isDone {
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                }))
            } else {
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
            }
            self.present(alert, animated: true, completion: nil)
            self.passwordText2.text = ""
            self.passwordText1.text = ""

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameText.becomeFirstResponder()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func register(un: String, em: String, pwd: String) {
        submitAction(un: un, em: em, pwd: pwd)
    }
    
    func submitAction(un: String, em: String, pwd: String) {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = ["type": "register", "user_name": un, "e_mail": em, "password": pwd] as Dictionary<String, String>
        
        //create the url with URL
        let url = URL(string: "http://114.116.11.227:8001/login/register")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            showAlert(title: "错误", message: "网络错误")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    self.useJson(dict: json)
                }
            } catch let error {
                print(error.localizedDescription)
                self.showAlert(title: "失败", message: "注册失败")
                return
            }
        })
        task.resume()
    }
    

    func useJson(dict: [String: Any]) {
        if dict.keys.contains("typecode") { // if there is a typecode
            if let bit = dict["typecode"] as? Int { // if typecode is int
                if (bit != 0) {
                    print("not zero")
                    badBit = bit
                    showAlert(title: "失败", message: "注册失败")
                    return
                }
                else {
                    showAlert(title: "成功", message: "注册成功", isDone: true)
                    return
                }
            }
            else {
                badBit = -10
                showAlert(title: "失败", message: "注册失败")
                return
            }
        }
        else {
            showAlert(title: "失败", message: "注册失败")
            badBit = -10
            return
        }
    }

}
