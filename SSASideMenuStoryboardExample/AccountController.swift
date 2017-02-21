//
//  AccountController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 1/2/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit
import Parse

class AccountController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?
    @IBOutlet weak var switchButton: UIButton!
    
    
    @IBAction func switchButton(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInView")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginView")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //Container
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInView")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.containerView.addSubview(currentViewController!.view)
        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        
        //Tap
        self.hideKeyboardWhenTappedAround()
        
        // Check if the user has logined, if true, direct to profile page
        if PFUser.current() != nil {
            signIned = true
            let controller1 = storyboard?.instantiateViewController(withIdentifier: "Profile")
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller1!)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.addSubview(subView: newViewController.view, toView:self.containerView!)
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

