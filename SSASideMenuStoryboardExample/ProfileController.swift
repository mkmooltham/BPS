//
//  SignInController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 17/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit
import Parse
import Stripe

class ProfileController: UIViewController, STPAddCardViewControllerDelegate{
    
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var proPicIcon: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelUserEmail: UILabel!
    @IBOutlet weak var spaceBoard: UIImageView!
    @IBOutlet weak var timerBoard: UIImageView!
    @IBOutlet weak var inTimeBoard: UIImageView!
    @IBOutlet weak var averageHourText: UILabel!
    @IBOutlet weak var totalParkTimeText: UILabel!
    @IBOutlet weak var labelParkingLotNumber: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var labelCheckinTime: UILabel!
    
    var checkInDateTime: Date?
    var timer: Timer?
    
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBAction func logoutButton(_ sender: Any) {
        // Logout from the server
        PFUser.logOutInBackground(block: { (error: Error?) in
            if let error = error {
                print("cannot logout \(error.localizedDescription)")
            } else {
                print("logout success")
                
                // Clear the stored checkined parking space
                let defaults = UserDefaults.standard
                defaults.set(nil, forKey: "ParkingSpaceCheckedIn")
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
        //Fluorescent
        averageHourText.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        averageHourText.layer.shadowOpacity = 1
        averageHourText.layer.shadowOffset = CGSize(width: 1, height: -1)
        averageHourText.layer.shadowRadius = 7
        totalParkTimeText.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        totalParkTimeText.layer.shadowOpacity = 1
        totalParkTimeText.layer.shadowOffset = CGSize(width: 1, height: -1)
        totalParkTimeText.layer.shadowRadius = 7
        logoutButton.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        logoutButton.layer.shadowOpacity = 1
        logoutButton.layer.shadowOffset = CGSize(width: 1, height: -1)
        logoutButton.layer.shadowRadius = 7
        
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
        PFUser.current()?.fetchInBackground(block: { (user:PFObject?, error:Error?) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if let usr = user {
                print(usr)
                let activeRecord = usr["activeRecord"] as? PFObject;
                activeRecord?.fetchInBackground(block: { (record: PFObject?, error:Error?) in
                    if let err = error {
                        print(err.localizedDescription)
                        return
                    }
                    if let rec = record {
                        print(rec)

                        let checkinDate = rec["checkinTime"] as? Date
                        self.checkInDateTime = checkinDate
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        
                        self.labelCheckinTime.text = dateFormatter.string(from: checkinDate!)
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                        self.timer?.fire()
                    }
                })
            }
            
        })
        
        // update parking lot id
        let defaults = UserDefaults.standard
        if let parkingSpaceID = defaults.object(forKey: "ParkingSpaceCheckedIn") as? String {
            labelParkingLotNumber.text = parkingSpaceID
        }
    }
    
    func updateTimer() {
        //print("update timer")
        let timeElapsedSeconds = Int(Date().timeIntervalSince(checkInDateTime!))
        
        let h:Int = timeElapsedSeconds / 3600
        let m:Int = (timeElapsedSeconds/60) % 60
        let s:Int = timeElapsedSeconds % 60
        let timeString = String(format: "%u:%02u:%02u", h,m,s)
        
        labelTimer.text = String(timeString)
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

    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    @IBAction func addCreditCardButtonClicked(_ sender: UIButton) {
        /*
        let darkTheme = STPTheme()
        darkTheme.primaryBackgroundColor = UIColor(red:0.16, green:0.23, blue:0.31, alpha:1.00)
        darkTheme.secondaryBackgroundColor = UIColor(red:0.22, green:0.29, blue:0.38, alpha:1.00)
        darkTheme.primaryForegroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        darkTheme.secondaryForegroundColor = UIColor(red:0.60, green:0.64, blue:0.71, alpha:1.00)
        darkTheme.accentColor = UIColor(red:0.98, green:0.80, blue:0.00, alpha:1.00)
        darkTheme.errorColor = UIColor(red:0.85, green:0.48, blue:0.48, alpha:1.00)
        //darkTheme.font = UIFont(name: "GillSans", size: 17)
        //darkTheme.emphasisFont = UIFont(name: "GillSans", size: 17)
         */


        //let addCardViewController = STPAddCardViewController.init(theme: darkTheme)
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self

        // set the default card patment method
        let info = STPUserInformation()
        info.email = PFUser.current()?.email
        addCardViewController.prefilledInformation = info
        
        // STPAddCardViewController must be shown inside a UINavigationController.
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print(token)
        // call api to save the token to current parse user
        PFCloud.callFunction(inBackground: "addCreditCard", withParameters: ["stripeToken" : token.tokenId]) { (response: Any?, error: Error?) in
            print("call api")
            if let error = error {
                print(error)
                let alertCtrl = getErrorAlertCtrl(title: "ERROR", message: error.localizedDescription)
                self.present(alertCtrl, animated: true, completion: nil)
                completion(error)
                return
            }
            
            if let res = response {
                print(res)
                print("Add credit card success: \(res)")
                self.dismiss(animated: true, completion: nil)
                completion(nil)
            }
        }
    }
    
}

