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
    @IBOutlet weak var proPicBorder: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!

    @IBOutlet weak var profileContainer: UIView!
    weak var currentViewController: UIViewController?
    
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
    
    @IBAction func swapViewButton(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "dashboardView")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "dashboardView")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        }
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
        logoutButton.layer.cornerRadius = 10
        //shadow
        logoutButton.layer.shadowColor = UIColor.black.cgColor
        logoutButton.layer.shadowOpacity = 0.2
        logoutButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        logoutButton.layer.shadowRadius = 10
        
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
        
        //Container
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "dashboardView")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.profileContainer.addSubview(currentViewController!.view)
        addSubview(subView: self.currentViewController!.view, toView: self.profileContainer)
        super.viewDidLoad()
        
        //Tap
        self.hideKeyboardWhenTappedAround()
        
        //Rotation
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
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
        proPicBorder.layer.cornerRadius = proPicBorder.frame.size.width/2
        proPicBorder.clipsToBounds = true
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
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.profileContainer!)
        newViewController.view.alpha = 0
       // newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMove(toParentViewController: self)
        })
    }
    

}

