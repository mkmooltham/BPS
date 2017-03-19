//
//  timeSlot.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 13/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

enum eventType {
    case freeUp
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
    public var eventColor: UIColor = .white
    
    init(){}
    
    init(year:String, month:String, day:String , hour:String, minute:String, duration:String, event:eventType){
        start_year = NSString(string: year).integerValue
        start_month = NSString(string: month).integerValue
        start_day = NSString(string: day).integerValue
        start_hour = NSString(string: hour).integerValue
        start_minute = NSString(string: minute).integerValue
        
        duration_hour = NSString(string: duration).integerValue
        if(Int((NSString(string: duration).floatValue*10))%10 == 0){duration_minute=0}else{duration_minute=30};
        
        switch event {
        case .freeUp:
            eventTitle = "Free Up"
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
