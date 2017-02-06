//
//  File.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 9/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class ShareController: UIViewController{
    
    var current = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background
        //let imageView = UIImageView(frame: self.view.bounds)
        //imageView.image = UIImage(named: "Background_View.png")
        //self.view.addSubview(imageView)
        
        //Title
        title = "Share Park Time"
        
        //Config

        
                
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
