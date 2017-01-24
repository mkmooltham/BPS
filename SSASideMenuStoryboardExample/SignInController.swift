//
//  SignInController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 17/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var proPicIcon: UIImageView!
    @IBOutlet weak var proPicBorder: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Config
        //background
        backgroundView.backgroundColor = hexColor(hex: bgColor)
        //Title
        title = "Profile"
        //profile Picture
        proPicIcon.image = UIImage(named: "propic.jpg")
        coverView.image = UIImage(named: "propic.jpg")
        coverView.addBlurEffect()
        //border
        proPicIcon.layer.borderWidth = 1
        proPicIcon.layer.borderColor =  UIColor.gray.cgColor
        proPicIcon.layer.masksToBounds = true
        //circle
        proPicIcon.layer.cornerRadius = proPicIcon.frame.size.width/2
        proPicIcon.clipsToBounds = true
        proPicBorder.layer.cornerRadius = proPicBorder.frame.size.width/2
        proPicBorder.clipsToBounds = true
    
        
        //Navigation bar
        menuButton.setImage(UIImage(named: "menuIcon.png"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: barButtonSize, height: barButtonSize)
        menuButton.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let navbarFont = UIFont(name: "Ubuntu", size: titleSize) ?? UIFont.systemFont(ofSize: titleSize)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName:UIColor.lightText]
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

