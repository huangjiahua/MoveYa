//
//  LoginTableViewController.swift
//  RunningRecorder
//
//  Created by 黄嘉华 on 2018/11/7.
//  Copyright © 2018 jhhuang. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var thirdUserNameLabel: UILabel?
    var thirdEmailLabel: UILabel?

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginButtonIsClicked(_ sender: Any) {
        let un = nameField.text!
        let pwd = passwordField.text!
        if un.isEmpty || pwd.isEmpty {
            showAlert(title: "错误", message: "不能为空")
        }
        login(name: un, pwd: pwd)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameField.becomeFirstResponder()
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
            
        }
    }
    
    func login(name: String, pwd: String) {
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        var parameters = ["type": "login", "password": pwd] as Dictionary<String, String>
        if isValidEmail(testStr: name) {
            parameters["e_mail"] = name
        } else {
            parameters["user_name"] = name
        }
        
        //create the url with URL
        let url = URL(string: "http://114.116.11.227:8001/login/login")! //change the url
        
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
                self.showAlert(title: "失败", message: "登录失败")
                return
            }
        })
        task.resume()
    }
    
    func useJson(dict: [String: Any]) {
        if dict.keys.contains("typecode") {
            let code = dict["typecode"] as! Int
            if code != 0 {
                showAlert(title: "错误", message: "用户名/邮箱与密码不匹配")
                return
            } else {
                let key = dict["key"] as! String
                let id = dict["id"] as! Int
                let username = dict["user_name"] as! String
                let user = User(entity: User.entity(), insertInto: context)
                user.active = true
                user.email = "person@example.com"
                user.id = Int32(id)
                user.key = key
                user.username = username
                appDelegate.saveContext()
                appDelegate.currentUser.update(user: user)
                DispatchQueue.main.async {
                    self.thirdUserNameLabel!.text = username
                    self.thirdEmailLabel!.text = user.email
                }

                showAlert(title: "成功", message: "登录成功", isDone: true)
                return
            }
        }
        else {
            showAlert(title: "错误", message: "登录失败")
        }
    }
}

extension LoginTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }
}
