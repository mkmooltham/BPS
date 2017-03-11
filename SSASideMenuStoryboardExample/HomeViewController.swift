//
//  FirstViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var findCarLogo: UIImageView!
    @IBOutlet weak var parkSpaceLogo: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelNumAvailable: UILabel!
    @IBOutlet weak var infoBoardBackground: UIImageView!
    @IBOutlet weak var parkModeText: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var parkTimeText: UITextField!
    
    var pickerData = Array(1...24)
    var picker = UIPickerView()
    
    //switch Park Mode
    @IBAction func changeParkMode(_ sender: UISwitch) {
        if switchControl.isOn == true{
            parkModeText.text="Busy Mode"
            parkTimeText.isHidden = false
            parkTimeText.inputView = picker
        } else{
            parkModeText.text="Fast Mode"
            parkTimeText.isHidden = true
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //picker
        picker.delegate = self
        picker.dataSource = self
        
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
        
        self.parkModeText.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        self.parkModeText.layer.shadowOpacity = 0.8
        self.parkModeText.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.parkModeText.layer.shadowRadius = 5

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
    
    //Picker View Table
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        parkTimeText.text = String(pickerData[row])+" HOURS"
        self.hideKeyboardWhenTappedAround()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
}

