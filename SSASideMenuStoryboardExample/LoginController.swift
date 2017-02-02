//
//  loginController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 1/2/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

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
    
}
