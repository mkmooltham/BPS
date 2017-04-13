//
//  ParkSpaceController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 9/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit
import Parse

class ParkSpaceController: UIViewController, HomeViewDelegate {
    
    @IBOutlet weak var arrivedButton: UIButton!
    @IBOutlet weak var infoBoardView: UIImageView!
    @IBOutlet weak var carLotNum: UILabel!
    @IBOutlet weak var carLotTitle: UILabel!
    
    var temp_title = "Park My Car"
    var temp_carLotTitle = "You Got Parking Space"
    var temp_carLotNum = "A109"
    var temp_arrivedButtonTitle = "Arrived"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if current user check in to any parking space
        let defaults = UserDefaults.standard
        
        if let parkingSpaceID = defaults.object(forKey: "ParkingSpaceCheckedIn") as? String {
            carLotNum.text = parkingSpaceID
        } else {
            // not checked in
            let alertController = UIAlertController(title: "Not checked in", message: "You have not checked in any parking space", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                // after clicking ok, go back to home view
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                self.sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller!)
            }
            alertController.addAction(okAction)

            present(alertController, animated: true, completion: nil)
        }

        //Title
        title = temp_title
        carLotTitle.text = temp_carLotTitle
        carLotNum.text = temp_carLotNum
        arrivedButton.setTitle(temp_arrivedButtonTitle, for: .normal)
        
        //Config
        //round corner
        arrivedButton.layer.cornerRadius = 10
        arrivedButton.layer.cornerRadius = 10
        //shadow
        arrivedButton.layer.shadowColor = UIColor.black.cgColor
        arrivedButton.layer.shadowOpacity = 1
        arrivedButton.layer.shadowOffset = CGSize(width: 1, height: -1)
        arrivedButton.layer.shadowRadius = 10
        carLotNum.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        carLotNum.layer.shadowOpacity = 0.8
        carLotNum.layer.shadowOffset = CGSize(width: 1, height: -1)
        carLotNum.layer.shadowRadius = 5
        carLotTitle.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        carLotTitle.layer.shadowOpacity = 0.8
        carLotTitle.layer.shadowOffset = CGSize(width: 1, height: -1)
        carLotTitle.layer.shadowRadius = 5
        
        //Naivgation Bar
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ParkSpaceController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightText
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let navbarFont = UIFont(name: "Ubuntu", size: titleSize) ?? UIFont.systemFont(ofSize: titleSize)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName:UIColor.lightText]

        
        //Orientation change
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    //Back button
    func back(sender: UIBarButtonItem) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller!)
    }
    
    //orientation change
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func rotated(){
        if UIDevice.current.orientation.isLandscape{
            infoBoardView.layer.cornerRadius = 10
            infoBoardView.layer.cornerRadius = 10
            print("Landscape")
        }else{
            infoBoardView.layer.cornerRadius = 0
            infoBoardView.layer.cornerRadius = 0
            print("Portrait")
        }
    }

    @IBAction func arriveButton(_ sender: UIButton) {
        if sender.titleLabel!.text == "Leave"{
            // Call cloud funtion checkout
            PFCloud.callFunction(inBackground: "checkout", withParameters: nil, block: { (response:Any?, error:Error?) in
                if let error = error {
                    let alertCtrl = getErrorAlertCtrl(title: "Cannot check-out", message: error.localizedDescription)
                    self.present(alertCtrl, animated: true, completion: nil)
                    return
                }
                
                print(response ?? "no response")
                // parse response parking record
                let parkingRecord = response as! PFObject
                print(parkingRecord["checkoutTime"])
                
                // Clear the stored checkined parking space
                let defaults = UserDefaults.standard
                defaults.set(nil, forKey: "ParkingSpaceCheckedIn")
                
            })
            
            let alert = UIAlertController(title: "Payment Success", message: "You paid $40~ Welcome next time", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller!)
        }
        else if sender.titleLabel!.text == "Arrived"{
            let alert = UIAlertController(title: "Park Success", message: "Your parking has recorded", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "Profile")
            self.sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller!)
        }
        
    }
    
    func changeWord(input: String){
        if input == "Find"{
            temp_title = "Find My Car"
            temp_carLotTitle = "Your Car at Parking Space"
            temp_arrivedButtonTitle = "Leave"
        }else if input == "Park"{
            temp_title = "Park My Car"
            temp_carLotTitle = "You Got Parking Space"
            temp_arrivedButtonTitle = "Arrived"
        }
    }
    
    @IBAction func toggleShowMyPoint(_ sender: UIButton) {
        print("toggle show my point option button")
        mapShowMyPoint = !mapShowMyPoint
    }
    
    @IBAction func toggleDirectedPath(_ sender: UIButton) {
        print("toggle show directed graph option button")
        mapDirectedGraph = !mapDirectedGraph
    }
    
    @IBAction func toggleIsGoingToEntrance(_ sender: UIButton) {
        print("toggle show directed graph option button")
        mapIsGoingToEntrance = !mapIsGoingToEntrance
    }
}
