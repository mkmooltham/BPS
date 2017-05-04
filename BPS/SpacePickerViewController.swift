//
//  SpacePickerViewController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 30/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class SpacePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var picker = UIPickerView()
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return spaceID.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let spaceName = spaceID[row]
        return NSAttributedString(string: spaceName, attributes: [NSForegroundColorAttributeName:hexColor(hex: "#66CCFF")])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        whatSpaceIndex = row
    }
    
    
}


