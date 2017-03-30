//
//  ParkHourPickerViewController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 31/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//


import UIKit

class HourPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var picker = UIPickerView()
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return parkHour.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var hourTitle = ""
        if(parkHour[row]==1){
            hourTitle = String(parkHour[row])+" HOUR"
        }else{
            hourTitle = String(parkHour[row])+" HOURS"
        }

        return NSAttributedString(string: hourTitle, attributes: [NSForegroundColorAttributeName:hexColor(hex: "#66CCFF")])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        whatParkHourIndex = row
    }
    
    
}

