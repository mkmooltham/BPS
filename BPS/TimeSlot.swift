//
//  timeSlot.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 13/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

enum eventType {
    case release
    case selfUse
    case rentOut
    case noEvent
}

class TimeSlot {
    public var start_year: Int = 0
    public var start_month: Int = 0
    public var start_day: Int = 0
    public var start_hour: Int = 0
    public var start_minute: Int = 0
    public var duration_hour: Int = 0
    public var duration_minute: Int = 0
    public var eventTitle: String = ""
    public var spaceName: String = ""
    public var eventColor: UIColor = .white
    
    init(){}
   
    init(dateIndex: Int, timeIndex:Int, timeEndIndex:Int, spaceIndex:Int ,event:eventType){
        //translate date
        let formatter = DateFormatter()
        let selectedDate = pickerWeek[dateIndex]!
        formatter.dateFormat = "y"
        start_year = NSString(string: formatter.string(from: selectedDate)).integerValue
        formatter.dateFormat = "M"
        start_month = NSString(string: formatter.string(from: selectedDate)).integerValue
        formatter.dateFormat = "d"
        start_day = NSString(string: formatter.string(from: selectedDate)).integerValue
        
        //translate time
        let selectedTime = pickerTime[timeIndex]
        var index = selectedTime.index(selectedTime.startIndex, offsetBy: 2)
        start_hour = NSString(string: selectedTime.substring(to: index)).integerValue
        index = selectedTime.index(selectedTime.startIndex, offsetBy: 2)
        start_minute = NSString(string: selectedTime.substring(from: index)).integerValue

        //translate endTime
        duration_hour = Int(Float(timeEndIndex-timeIndex)*0.5)
        duration_minute = Int((Float(timeEndIndex-timeIndex)*0.5-Float(duration_hour))*60)
        
        //translate space ID
        spaceName = spaceID[spaceIndex]
        
        //translate event type
        switch event {
        case .release:
            eventTitle = "Released"
            eventColor = .green
        case .selfUse:
            eventTitle = "Self Use"
            eventColor = .blue
        case .rentOut:
            eventTitle = "Rent Out"
            eventColor = .yellow
        default:
            eventTitle = "No events"
        }
    }
    
    func stringToDurationHour(duration : String) {
        let duration = NSString(string: duration).integerValue
        duration_hour = duration
    }
    
}
