//
//  pickerVIewController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 20/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return pickerWeek.count
        }else{
            return pickerTime.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0{
            let formatter = DateFormatter()
            formatter.dateFormat = "E  dd MMM"
            let date = formatter.string(from: pickerWeek[row]!)
            return NSAttributedString(string: date, attributes: [NSForegroundColorAttributeName:UIColor.white])

        }else{
            let titleData = pickerTime[row]
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
            whatDayIndex = row
        }else{
            whatTimeIndex = row
        }
    }
    
    
}
