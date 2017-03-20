//
//  AddEventController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 19/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class AddEventController: UIViewController {
    @IBOutlet weak var popUpBackground: UIImageView!
    @IBOutlet weak var weekDayPicker: UIPickerView!
    
    let calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarView") as! CalendarController
    let shareVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Share") as! ShareController
    
    var selectedDay = Date()
    var selectedTime = "0000"
    
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
    
    //close button
    @IBAction func closePopUp(_ sender: UIButton) {
        calendarVC.addEventToCalendar(dur: "3.5")
        self.view.removeFromSuperview()
//        self.removeAnimate()
    }
    
    @IBAction func cancelPopUp(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}

