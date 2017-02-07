//
//  SignInController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 1/2/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit
import Parse

class SignInController: UIViewController {
   
    @IBOutlet weak var createLoginName: UITextField!
    @IBOutlet weak var createLoginPassward: UITextField!
    @IBOutlet weak var confirmPassward: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Config
        //textfield
        let textfieldArray: [UITextField] = [self.createLoginName, self.createLoginPassward, self.confirmPassward]
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
    
    @IBAction func signupButtonClicked(_ sender: Any) {
        print("Sign up btn is clicked")
        
        // Basic Validation on the input field
        guard let username = createLoginName.text, !username.isEmpty else {
            present(getErrorAlertCtrl(title: "Missing Username", message: "Please fill in the username"),
                    animated: true, completion: nil)
            return
        }
        
        guard let password = createLoginPassward.text, !password.isEmpty else {
            present(getErrorAlertCtrl(title: "Missing Password", message: "Please fill in the password"),
                    animated: true, completion: nil)
            return
        }
        
        guard let passwordConfirm = confirmPassward.text, !passwordConfirm.isEmpty, password == passwordConfirm else {
            present(getErrorAlertCtrl(title: "Password Mismatch", message: "Please enter the same password again"),
                    animated: true, completion: nil)
            return
        }
        
        
        let user = PFUser()
        user.username = username
        user.password = passwordConfirm
        
        user.signUpInBackground { (success:Bool, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
                // Show warning alert to user
                let alertCtrl = getErrorAlertCtrl(title: "Sign up failed", message: error.localizedDescription)
                self.present(alertCtrl, animated: true, completion: nil)
                
            } else {
                // login success
                print("success login \(success)")
                
                // TODO: redirect to somewhere else
                
            }
        }
    }
}


