//
//  pickerVIewController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 20/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let AddEventVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpAddEvent") as! AddEventController
    
    let week = [
        Date(),
        Calendar.current.date(byAdding: .day, value: 1, to: Date()),
        Calendar.current.date(byAdding: .day, value: 2, to: Date()),
        Calendar.current.date(byAdding: .day, value: 3, to: Date()),
        Calendar.current.date(byAdding: .day, value: 4, to: Date()),
        Calendar.current.date(byAdding: .day, value: 5, to: Date()),
        Calendar.current.date(byAdding: .day, value: 6, to: Date())
    ]
    let time = [
        "0000","0030","0100","0130","0200","0230","0300","0330","0400","0430","0500","0530","0600","0630",
        "0700","0730","0800","0830","0900","0930","1000","1030","1100","1130","1200","1230","1300","1330",
        "1400","1430","1500","1530","1600","1630","1700","1730","1800","1830","1900","1930","2000","2030",
        "2100","2130","2200","2230","2300","2330"
    ]
    var whatWeekDay = Date()
    var whatTime = "0000"
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return week.count
        }else{
            return time.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0{
            let formatter = DateFormatter()
            formatter.dateFormat = "E  dd MMM"
            let date = formatter.string(from: week[row]!)
            return NSAttributedString(string: date, attributes: [NSForegroundColorAttributeName:UIColor.white])

        }else{
            let titleData = self.time[row]
            return NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.white])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0{
            return (self.view.frame.size.width*60)/100*0.8;
        }else{
            return (self.view.frame.size.width*40)/100*0.8;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            whatWeekDay = self.week[row]!
        }else{
            whatTime = self.time[row]
        }
        
        AddEventVC.selectedDay = whatWeekDay
        AddEventVC.selectedTime = whatTime
    }
    
    
}
