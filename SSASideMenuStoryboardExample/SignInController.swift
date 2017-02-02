//
//  SignInController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 1/2/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

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
    
    
}


