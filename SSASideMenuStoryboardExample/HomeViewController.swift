//
//  FirstViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var findCarLogo: UIImageView!
    @IBOutlet weak var parkSpaceLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        //Config
        title = "Home"
        
        //shadow
        self.findCarLogo.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        self.findCarLogo.layer.shadowOpacity = 1
        self.findCarLogo.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.findCarLogo.layer.shadowRadius = 7
        
        self.parkSpaceLogo.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        self.parkSpaceLogo.layer.shadowOpacity = 1
        self.parkSpaceLogo.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.parkSpaceLogo.layer.shadowRadius = 7
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

