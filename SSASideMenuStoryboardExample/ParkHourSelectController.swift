//
//  ParkHourSelectController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 30/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

protocol ParkHourSelectDelegate {
    func moveToMap(input: String)
    func addBlur()
    func removeBlur()
}

class ParkHourSelectController: UIViewController{
    @IBOutlet weak var popUpBackground: UIImageView!
    @IBOutlet weak var bottomBackground: UIImageView!
    @IBOutlet weak var hourPicker: UIPickerView!
    @IBOutlet weak var colorLine: UIImageView!
    
    var delegate: ParkHourSelectDelegate!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Config
        //corner
        popUpBackground.layer.cornerRadius = 10
        colorLine.layer.cornerRadius = 1
        //shadow
        popUpBackground.layer.shadowColor = UIColor.black.cgColor
        popUpBackground.layer.shadowOpacity = 0.8
        popUpBackground.layer.shadowOffset = CGSize(width: 5, height: 5)
        popUpBackground.layer.shadowRadius = 10
        delegate.addBlur()
        self.showAnimate()
        
        //HourPicker
        let hrPickerVC = HourPickerViewController()
        self.addChildViewController(hrPickerVC)
        hourPicker.delegate = hrPickerVC
        hourPicker.dataSource = hrPickerVC
    }
 
    @IBAction func cancel(_ sender: UIButton) {
        delegate.removeBlur()
        self.removeAnimate()
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        delegate.removeBlur()
        self.removeAnimate()
        delegate.moveToMap(input: "Park")
    }
    
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }

}


