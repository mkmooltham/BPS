//
//  loginController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 1/2/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit
import Parse

class LoginController: UIViewController {
    
    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var loginPassward: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Config
        //textfield
        let textfieldArray: [UITextField] = [self.loginName, self.loginPassward]
        for item in textfieldArray{
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.cyan.cgColor
            border.frame = CGRect(x: 0, y: item.frame.size.height - width, width:  item.frame.size.width, height: item.frame.size.height)
            border.borderWidth = width
            item.layer.addSublayer(border)
            item.layer.masksToBounds = true
        }
        
        //Tap
        self.hideKeyboardWhenTappedAround()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinButtonClicked(_ sender: UIButton) {
        print("Signin button is clicked")
        
        // input validation
        guard let username = loginName.text, !username.isEmpty else {
            present(getErrorAlertCtrl(title: "Missing Username", message: "Please fill in the username"),
                    animated: true, completion: nil)
            return
        }
        
        guard let password = loginPassward.text, !password.isEmpty else {
            present(getErrorAlertCtrl(title: "Missing Password", message: "Please enter the password"),
                    animated: true, completion: nil)
            return
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.present(getErrorAlertCtrl(title: "Login failed", message: error.localizedDescription),
                             animated: true, completion: nil)
                return
            }
            
            // login success
            print("Login success \(user)")
            
            // TODO: redirect to somewhere
        }
        
    }
}
