//
//  AddEventController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 19/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

protocol AddEventCOntrollerDelegate {
    func pushEventToCalendar()
}

class AddEventController: UIViewController{
    @IBOutlet weak var popUpBackground: UIImageView!
    @IBOutlet weak var weekDayPicker: UIPickerView!
    
    var delegate: AddEventCOntrollerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showAnimate()
        
        //config
        popUpBackground.layer.cornerRadius = 10
        
        //weekDayPicker
        let pickerVC = PickerViewController()
        self.addChildViewController(pickerVC)
        weekDayPicker.delegate = pickerVC
        weekDayPicker.dataSource = pickerVC
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sugue back to superview
    
    //confirm button
    @IBAction func closePopUp(_ sender: UIButton) {
        delegate.pushEventToCalendar()
        self.removeAnimate()
    }
    //cancel button
    @IBAction func cancelPopUp(_ sender: UIButton) {
        self.removeAnimate()
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


