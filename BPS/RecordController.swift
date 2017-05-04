//
//  RecordController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 11/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit
import Parse

class RecordController: UIViewController {
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Title
        title = "Record"
        
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
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
//        rightSwipe.direction = .right
//        view.addGestureRecognizer(rightSwipe)
        
        // Make sure the user is logined, otherwise redirect to the login page
        guard PFUser.current() != nil else {
            print("user is not login yet")
            present(getErrorAlertCtrl(title: "Login Required", message: "Please sign in first"),
                    animated: true, completion: nil)
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "Account")
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller!)
            return
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

