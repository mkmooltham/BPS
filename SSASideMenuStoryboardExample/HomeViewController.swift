//
//  FirstViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import UIKit
import Parse

protocol HomeViewDelegate{
    func changeWord(input: String)
}

class HomeViewController: UIViewController , ParkHourSelectDelegate{
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var findCarLogo: UIImageView!
    @IBOutlet weak var parkSpaceLogo: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelNumAvailable: UILabel!
    @IBOutlet weak var infoBoardBackground: UIImageView!
    
    var delegate: HomeViewDelegate!
    
    @IBAction func findMyCar(_ sender: UIButton) {
        self.moveToMap(input:"Find")
    }
    

    func moveToMap(input: String){
        let findCarVc = self.storyboard?.instantiateViewController(withIdentifier: "FindCarMap") as! ParkSpaceController
        findCarVc.changeWord(input: input)
        print(input)
        
        self.navigationController?.pushViewController(findCarVc, animated: true)

    }
    
    @IBAction func parkMyCar(_ sender: UIButton) {
        // Check if current user has already checked into parking space
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "ParkingSpaceCheckedIn") as? String) != nil {
            let alertController = UIAlertController(title: "Already checked in", message: "You have already checked in a parking space, please click `Find My Car` to see the details", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                    print("OK")
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }

        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HourSelect") as! ParkHourSelectController
        popUpVC.delegate = self
        self.addChildViewController(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParentViewController: self)

    }
    
    func addBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func removeBlur(){
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    
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
        
        //Fluorescent
        self.findCarLogo.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        self.findCarLogo.layer.shadowOpacity = 1
        self.findCarLogo.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.findCarLogo.layer.shadowRadius = 7
        
        self.parkSpaceLogo.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        self.parkSpaceLogo.layer.shadowOpacity = 1
        self.parkSpaceLogo.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.parkSpaceLogo.layer.shadowRadius = 7
        
        self.labelAddress.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        self.labelAddress.layer.shadowOpacity = 0.8
        self.labelAddress.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.labelAddress.layer.shadowRadius = 5
        
        self.labelNumAvailable.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        self.labelNumAvailable.layer.shadowOpacity = 0.5
        self.labelNumAvailable.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.labelNumAvailable.layer.shadowRadius = 5
        
        //round corner
        infoBoardBackground.layer.cornerRadius = 10
        //shawdow
        infoBoardBackground.layer.shadowColor = UIColor.black.cgColor
        infoBoardBackground.layer.shadowOpacity = 1
        infoBoardBackground.layer.shadowOffset = CGSize(width: 1, height: 1)
        infoBoardBackground.layer.shadowRadius = 10
        
        // Get data from parse
        // TODO: change to live query on the # of available parking space
        let query = PFQuery(className:"CarPark")
        query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
            if let errorFound = error {
                // Log details of the failure
                print("Error: \(errorFound) \(errorFound.localizedDescription)")
                return
            }
            if let carPark = object {
                let numAvailable = carPark["availableSpace"] as? Int
                let numTotalAvailable = carPark["totalAvailableSpace"] as? Int
                let hourlyRate = carPark["hourlyRate"] as? Int
                let name = carPark["name"] as? String
                let address = carPark["address"] as? String
                
                print("numAvailable:\(numAvailable) numTotalAvailable:\(numTotalAvailable) hourlyRate:\(hourlyRate) name:\(name) address:\(address)")
                
                // update the label
                self.labelNumAvailable.text = "\(numAvailable!) /\(numTotalAvailable!)"
                self.labelAddress.text = address!
                // TODO: add hourly rate to the UI
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

