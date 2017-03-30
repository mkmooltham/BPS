//
//  durationPickerViewController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 21/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class DurationPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var picker = UIPickerView()

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return pickerTime.count
        }else{
            return (pickerEndTime.count-whatTimeIndex-1)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if(component == 0){
            let titleData = pickerTime[row]
            return NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:hexColor(hex: "#66CCFF")])
        }else{
            let titleData = pickerEndTime[row+1+whatTimeIndex]
            return NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:hexColor(hex: "#66CCFF")])
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            if(whatEndTimeIndex+row-whatTimeIndex<pickerEndTime.count-1){whatEndTimeIndex = whatEndTimeIndex+row-whatTimeIndex}else{whatEndTimeIndex = pickerEndTime.count-1}
            whatTimeIndex = row
            pickerView.reloadAllComponents()
        }else{
            whatEndTimeIndex = row+1+whatTimeIndex
        }
    }
    
    
}

