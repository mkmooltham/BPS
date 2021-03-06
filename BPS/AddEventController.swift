//
//  AddEventController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 19/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

protocol AddEventControllerDelegate {
    func pushEventToCalendar()
    func addBlur()
    func removeBlur()
}

class AddEventController: UIViewController{
    @IBOutlet weak var popUpBackground: UIImageView!
    @IBOutlet weak var weekDayPicker: UIPickerView!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var spacePicker: UIPickerView!
    @IBOutlet weak var dateTitle: UILabel!
    
    var delegate: AddEventControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate.addBlur()
        self.showAnimate()
        
        //config
        dateTitle.text = "Date for Weekly Schedule"
        popUpBackground.layer.cornerRadius = 10
        //shadow
        popUpBackground.layer.shadowColor = UIColor.black.cgColor
        popUpBackground.layer.shadowOpacity = 0.8
        popUpBackground.layer.shadowOffset = CGSize(width: 5, height: 5)
        popUpBackground.layer.shadowRadius = 10
        
        //weekDayPicker
        let pickerVC = PickerViewController()
        self.addChildViewController(pickerVC)
        weekDayPicker.delegate = pickerVC
        weekDayPicker.dataSource = pickerVC
        //durationPicker
        let durPickerVC = DurationPickerViewController()
        self.addChildViewController(durPickerVC)
        durationPicker.delegate = durPickerVC
        durationPicker.dataSource = durPickerVC
        //spacePicker
        let spaPickerVC = SpacePickerViewController()
        self.addChildViewController(spaPickerVC)
        spacePicker.delegate = spaPickerVC
        spacePicker.dataSource = spaPickerVC
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //confirm button
    @IBAction func closePopUp(_ sender: UIButton) {
        delegate.pushEventToCalendar()
        delegate.removeBlur()
        self.removeAnimate()
    }
    //cancel button
    @IBAction func cancelPopUp(_ sender: UIButton) {
        delegate.removeBlur()
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


