//
//  ParkingSchedule.swift
//  SSASideMenuStoryboardExample
//
//  Created by BennyO on 23/4/2017.
//  Copyright © 2017 SebastianAndersen. All rights reserved.
//

import Foundation

class ParkingSchedule {
    var startDateTime: Date
    var endDateTime: Date
    var parkingLotID: String
    
    // weeday 1 = sunday, 2 = monday ... 7 = saturday
    init(weekday: Int, startTimeHours: Float, duration: Float, parkingLotID: String) {
        let curDate = Date()
        //let curDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())! // debug
        let calendar = Calendar.current
        let curWeekday = calendar.component(.weekday, from: curDate)
        
        var dayOffset: Int
        if weekday >= curWeekday {
            dayOffset = weekday - curWeekday
        } else {
            // cal the day of next weekday
            dayOffset = 7 - (curWeekday - weekday)
        }
        
        // the date after the weekday offset
        let curDateOffset = calendar.date(byAdding: .day, value: dayOffset, to: curDate)!
        
        var components = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .hour, .minute], from: curDateOffset)
        
        // inpu the hour and minutes
        let inputHours = floor(startTimeHours)
        let inputMinutes = (startTimeHours - inputHours == 0.5) ? 30 : 0
        components.hour = Int(inputHours)
        components.minute = inputMinutes
        
        //print(components)
        
        let startDate = calendar.date(from: components)!
        //print(startDate)
        self.startDateTime = startDate
        
        let minutesOffSet = Int(duration * 60)
        let endDate = calendar.date(byAdding: .minute, value: minutesOffSet, to: startDate)!
        //print(endDate)
        self.endDateTime = endDate
        
        self.parkingLotID = parkingLotID
    }
    
    
    init(year: Int, month: Int, day: Int, hour: Int, minute: Int, durationHour: Int, durationMinute: Int, parkingLotID: String) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: components)!
        self.startDateTime = startDate
        
        let endDate = calendar.date(byAdding: .minute, value: durationHour * 60 + durationMinute, to: startDate)!
        self.endDateTime = endDate
        
        self.parkingLotID = parkingLotID
    }
}
