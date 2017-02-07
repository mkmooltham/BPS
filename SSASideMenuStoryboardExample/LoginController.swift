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
            showError(title: "Missing Username", message: "Please fill in the username")
            return
        }
        
        guard let password = loginPassward.text, !password.isEmpty else {
            showError(title: "Missing Password", message: "Please enter the password")
            return
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.showError(title: "Login failed", message: error.localizedDescription)
                return
            }
            
            // login success
            print("Login success \(user)")
            
            // TODO: redirect to somewhere
        }
        
    }
    
    // generic function to show popup error message
    func showError(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
