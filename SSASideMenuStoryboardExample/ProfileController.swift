//
//  SignInController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 17/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit
import Parse

class ProfileController: UIViewController {
    
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var proPicIcon: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelUserEmail: UILabel!
    @IBOutlet weak var spaceBoard: UIImageView!
    @IBOutlet weak var timerBoard: UIImageView!
    @IBOutlet weak var inTimeBoard: UIImageView!

    
    @IBOutlet weak var logoutButton: UIButton!
    @IBAction func logoutButton(_ sender: Any) {
        // Logout from the server
        PFUser.logOutInBackground(block: { (error: Error?) in
            if let error = error {
                print("cannot logout \(error.localizedDescription)")
            } else {
                print("logout success")
            }
        })
        
        signIned = false
        let controller1 = storyboard?.instantiateViewController(withIdentifier: "Account")
        sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller1!)
    }
    
    override func viewWillLayoutSubviews() {
        //Blur
        coverView.addBlurEffect()
        //Round
        let dSize: CGFloat = min(proPicIcon.frame.height, proPicIcon.frame.width)
        proPicIcon.layer.cornerRadius = dSize/2.0
    }
    
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
        //border
        proPicIcon.layer.borderWidth = 1
        proPicIcon.layer.borderColor =  UIColor.gray.cgColor
        proPicIcon.layer.masksToBounds = true
        //round corner
        spaceBoard.layer.cornerRadius = 10
        timerBoard.layer.cornerRadius = 10
        inTimeBoard.layer.cornerRadius = 10
        //shadow
 
        
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
        
        //Tap
        self.hideKeyboardWhenTappedAround()
        
        //Rotation
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        
        // Get user information and disaply in the labels
        
        labelUserName.text = PFUser.current()?.username
        labelUserEmail.text = PFUser.current()?.email
        // TODO: show license plate number
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //remove rotation observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //rotation
    func rotated(){
    //circle
        proPicIcon.layer.cornerRadius = proPicIcon.frame.size.width/2
        proPicIcon.clipsToBounds = true
        coverView.addBlurEffect()
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }

}

