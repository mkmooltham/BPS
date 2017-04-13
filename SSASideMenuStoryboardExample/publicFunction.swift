//
//  publicFunction.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 13/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

//Custome parameter
let bgColor = "000E29"
let titleSize = CGFloat(22)
let barButtonSize = CGFloat(45)
var signIned = false

// Car park navigation map options
var mapShowMyPoint = false
var mapDirectedGraph = false
var mapIsGoingToEntrance = false

//ShareParkSpace
var timeSlotList = [TimeSlot()]

// 0 = any hour, 1 .. 23 = 1 to 23 hour(s)
let parkHour = Array(0...23)
let pickerWeek = [
    Date(),
    Calendar.current.date(byAdding: .day, value: 1, to: Date()),
    Calendar.current.date(byAdding: .day, value: 2, to: Date()),
    Calendar.current.date(byAdding: .day, value: 3, to: Date()),
    Calendar.current.date(byAdding: .day, value: 4, to: Date()),
    Calendar.current.date(byAdding: .day, value: 5, to: Date()),
    Calendar.current.date(byAdding: .day, value: 6, to: Date())
]
let pickerTime = [
    "0000","0030","0100","0130","0200","0230","0300","0330","0400","0430","0500","0530","0600","0630",
    "0700","0730","0800","0830","0900","0930","1000","1030","1100","1130","1200","1230","1300","1330",
    "1400","1430","1500","1530","1600","1630","1700","1730","1800","1830","1900","1930","2000","2030",
    "2100","2130","2200","2230","2300","2330"
]
let pickerEndTime = [
    "0000","0030","0100","0130","0200","0230","0300","0330","0400","0430","0500","0530","0600","0630",
    "0700","0730","0800","0830","0900","0930","1000","1030","1100","1130","1200","1230","1300","1330",
    "1400","1430","1500","1530","1600","1630","1700","1730","1800","1830","1900","1930","2000","2030",
    "2100","2130","2200","2230","2300","2330","2400"
]
let spaceID = [
    "A001","A002","A003","A004","A005","A006","B001","B002","B003","B004","B005","B006","B007","B008",
    "B009","B010","C001","C002","C003","C004","C005","C006"
]
var whatParkHourIndex: Int = 0
var whatDayIndex: Int = 0
var whatTimeIndex: Int = 0
var whatEndTimeIndex: Int = 1
var whatSpaceIndex: Int = 0


//Custom button
let menuButton = UIButton(type: .custom)

//hex color function
func hexColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// Generic function to show popup error message
// Usage: present(alertController, animated: true, completion: nil)
func getErrorAlertCtrl(title:String, message:String) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
    
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        (result : UIAlertAction) -> Void in
        print("OK")
    }
    
    alertController.addAction(okAction)
    return alertController
}

//blurEffect
extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

//Color of placeholder
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}

//tap gesture
extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
}

//UIImage with color
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }    
}

