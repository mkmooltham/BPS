//
//  File.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 9/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit
import CalendarKit
import DateToolsSwift

class CalendarController: DayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calendar Style
        var style: CalendarStyle!
        style = StyleGenerator.darkStyle()
        updateStyle(style)
        }
    
    func addEventToCalendar(dateid: Int,timeid: Int,timeendid: Int, spaid: Int){
        let secondEvent = TimeSlot(dateIndex: dateid, timeIndex: timeid, timeEndIndex: timeendid, spaceIndex:spaid, event: .release)
        timeSlotList.append(secondEvent)
        self.dayView.reloadData()
    }
    
    override func eventViewsForDate(_ date: Date) -> [EventView] {
        
        var events = [EventView]()
        
        for i in 0...(timeSlotList.count-1) {
        let event = EventView()
        //Date(year,month,day,hours,minutes)
            let eventDate = Date(year: timeSlotList[i].start_year, month: timeSlotList[i].start_month, day: timeSlotList[i].start_day).add(TimeChunk(seconds: 0, minutes: timeSlotList[i].start_minute, hours: timeSlotList[i].start_hour, days: 0, weeks: 0, months: 0, years: 0))
        //Duration(hours,minutes)
            let duration = TimeChunk(seconds: 0, minutes: timeSlotList[i].duration_minute, hours: timeSlotList[i].duration_hour, days: 0, weeks: 0, months: 0, years: 0)
            let datePeriod = TimePeriod(beginning: eventDate, chunk: duration)
            event.datePeriod = datePeriod
        //event title
            if(timeSlotList[i].duration_hour >= 1){
                var info = [ "\(timeSlotList[i].spaceName) \(timeSlotList[i].eventTitle)" ]
                info.append("\(datePeriod.beginning!.format(with: "HH:mm")!) - \(datePeriod.end!.format(with: "HH:mm")!)")
                event.data = info
            }else{
                let info = [ "\(timeSlotList[i].spaceName) \(timeSlotList[i].eventTitle) \(datePeriod.beginning!.format(with: "HH:mm")!) - \(datePeriod.end!.format(with: "HH:mm")!)" ]
                event.data = info
            }
            
        //event color
            event.color = timeSlotList[i].eventColor
            events.append(event)
        }
        
        return events
    }

    
    // MARK: DayViewDelegate
    override func dayViewDidSelectEventView(_ eventview: EventView) {
        print("Event has been selected: \(eventview.data)")
    }
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        print("Event has been longPressed: \(eventView.data)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
}
