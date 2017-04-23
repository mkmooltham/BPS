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
import Parse

class CalendarController: DayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calendar Style
        var style: CalendarStyle!
        style = StyleGenerator.darkStyle()
        updateStyle(style)
        

        // Call API to retreive parking space schedule
        guard let currentUser = PFUser.current() else {
            return
        }
        let query = PFQuery(className:"ParkingSpace")
        query.whereKey("owner", equalTo: currentUser)
        query.getFirstObjectInBackground { (parkingSpace: PFObject?, error: Error?) in
            if let err = error {
                print(err.localizedDescription)
                self.present(getErrorAlertCtrl(title: "Error", message: err.localizedDescription),
                             animated: true, completion: nil)
                return
            }
            
            guard parkingSpace != nil else {
                self.present(getErrorAlertCtrl(title: "No parking space found", message: "You do not own any parking space"),
                             animated: true, completion: nil)
                return
            }
            
            // parking space found

            let schedules = parkingSpace!["schedule"] as? [[String: AnyObject]]
            print(schedules ?? "No schedule")
            if let schedules = schedules {
                // clear previous schedules
                myParkingSchdules.removeAll()
                
            
                for schedule in schedules {
                    //let weekday = schedule["weekday"] as? Int
                    //let startTimeHour = schedule["startTime"] as? Float
                    //let duration = schedule["duration"] as? Float
                    
                    if let weekday = schedule["weekday"] as? Int,
                        let startTimeHour = schedule["startTime"] as? Float,
                        let duration = schedule["duration"] as? Float {
                        
                        print("Schedule item: \(weekday) \(startTimeHour) \(duration)");
                        let newParkingSchedule = ParkingSchedule.init(weekday: weekday + 1, startTimeHours: startTimeHour, duration: duration, parkingLotID: "A123")
                        myParkingSchdules.append(newParkingSchedule)
                    }
                    
                    
                }
                
            }
            
            // reload calendar view
            self.dayView.reloadData()

        }

    }
    
    func addEventToCalendar(dateid: Int,timeid: Int,timeendid: Int, spaid: Int){
        let secondEvent = TimeSlot(dateIndex: dateid, timeIndex: timeid, timeEndIndex: timeendid, spaceIndex:spaid, event: .release)
        timeSlotList.append(secondEvent)
        self.dayView.reloadData()
    }
    
    /*
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
 */
    override func eventViewsForDate(_ date: Date) -> [EventView] {
        var events = [EventView]()
        
        
        for schedule in myParkingSchdules {
            //print("Calendar load \(schedule)")
            
            // Create new EventView
            let event = EventView()
        
            // Specify TimePeriod
        
            let datePeriod = TimePeriod(beginning: schedule.startDateTime, end: schedule.endDateTime)
            event.datePeriod = datePeriod
            // Add info: event title, subtitle, location to the array of Strings
            //var info = [model.title, model.location]
            //info.append("\(datePeriod.beginning!.format(with: "HH:mm")) - \(datePeriod.end!.format(with: "HH:mm"))")
            // Set "text" value of event by formatting all the information needed for display
            //event.text = info.reduce("", {$0 + $1 + "\n"})
            event.data = ["date", "\(datePeriod.beginning!.format(with: "HH:mm")) - \(datePeriod.end!.format(with: "HH:mm"))"]
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
