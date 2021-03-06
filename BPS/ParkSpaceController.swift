//
//  ParkSpaceController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 9/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit
import Parse
import FontAwesome

class ParkSpaceController: UIViewController, HomeViewDelegate {
    
    @IBOutlet weak var arrivedButton: UIButton!
    @IBOutlet weak var infoBoardView: UIImageView!
    @IBOutlet weak var carLotNum: UILabel!
    @IBOutlet weak var carLotTitle: UILabel!
    
    @IBOutlet weak var buttonShowMyPoint: UIButton!
    @IBOutlet weak var buttonDirectedGraph: UIButton!
    @IBOutlet weak var buttonEntrance: UIButton!
    
    
    var temp_title = "Park My Car"
    var temp_carLotTitle = "You Got Parking Space"
    //var temp_carLotNum = "A109"
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
        //carLotNum.text = temp_carLotNum
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
        
        
        // Set the 3 navigation buttons
        buttonShowMyPoint.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        buttonShowMyPoint.setTitle(String.fontAwesomeIcon(name: .eyeSlash), for: .normal)
        buttonShowMyPoint.setTitleColor(UIColor.black, for: .normal)
        
        buttonDirectedGraph.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        buttonDirectedGraph.setTitle(String.fontAwesomeIcon(name: .vine), for: .normal)
        buttonDirectedGraph.setTitleColor(UIColor.black, for: .normal)
        
        buttonEntrance.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        buttonEntrance.setTitle(String.fontAwesomeIcon(name: .signOut), for: .normal)
        buttonEntrance.setTitleColor(UIColor.black, for: .normal)
        
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
        if sender.titleLabel!.text == "Checkout"{
            // Call cloud funtion checkout
            PFCloud.callFunction(inBackground: "checkoutAndPay", withParameters: nil, block: { (response:Any?, error:Error?) in
                if let error = error {
                    let alertCtrl = getErrorAlertCtrl(title: "Cannot check-out", message: error.localizedDescription)
                    self.present(alertCtrl, animated: true, completion: nil)
                    return
                }
                
                print(response ?? "no response")
                // parse response parking record
                let parkingRecord = response as! PFObject
//                print(parkingRecord["checkoutTime"])
//                print(parkingRecord["paymentAmount"])
                
                // Clear the stored checkined parking space
                let defaults = UserDefaults.standard
                defaults.set(nil, forKey: "ParkingSpaceCheckedIn")
                
                checkoutInvoiceRecord = ParkingRecord.init(name: "Test", checkinTimeString: parkingRecord["checkinTime"] as? Date, checkoutTimeString: parkingRecord["checkoutTime"] as? Date, pkHour: parkingRecord["parkingHour"] as? Float, pkCharge: parkingRecord["paymentAmount"] as? Float)
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "Invoice")
                self.sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller!)
            })
            
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
            temp_arrivedButtonTitle = "Checkout"
        }else if input == "Park"{
            temp_title = "Park My Car"
            temp_carLotTitle = "You Got Parking Space"
            temp_arrivedButtonTitle = "Arrived"
        }
    }
    
    @IBAction func toggleShowMyPoint(_ sender: UIButton) {
        print("toggle show my point option button")
        if mapShowMyPoint {
            buttonShowMyPoint.setTitleColor(UIColor.black, for: .normal)
        } else {
            buttonShowMyPoint.setTitleColor(UIColor.white, for: .normal)
        }
        
        mapShowMyPoint = !mapShowMyPoint
    }
    
    @IBAction func toggleDirectedPath(_ sender: UIButton) {
        print("toggle show directed graph option button")
        if mapDirectedGraph {
            buttonDirectedGraph.setTitleColor(UIColor.black, for: .normal)
        } else {
            buttonDirectedGraph.setTitleColor(UIColor.white, for: .normal)
        }
        
        mapDirectedGraph = !mapDirectedGraph
    }
    
    @IBAction func toggleIsGoingToEntrance(_ sender: UIButton) {
        print("toggle show directed graph option button")
        if mapIsGoingToEntrance {
            buttonEntrance.setTitleColor(UIColor.black, for: .normal)
        } else {
            buttonEntrance.setTitleColor(UIColor.white, for: .normal)
        }
        
        mapIsGoingToEntrance = !mapIsGoingToEntrance
    }
}
