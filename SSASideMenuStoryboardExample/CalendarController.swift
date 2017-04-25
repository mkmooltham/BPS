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
                    if let weekday = schedule["weekday"] as? Int,
                        let startTimeHour = schedule["startTime"] as? Float,
                        let duration = schedule["duration"] as? Float {
                        
                        print("Schedule item: \(weekday) \(startTimeHour) \(duration)");
                        let newParkingSchedule = ParkingSchedule.init(weekday: weekday + 1, startTimeHours: startTimeHour, duration: duration, parkingLotID: parkingSpace!["parkingLotId"] as? String ?? "A100")
                        myParkingSchdules.append(newParkingSchedule)
                    }
                }
                
            }
            
            // reload calendar view
            self.dayView.reloadData()
        }

    }
    
    func addEventToCalendar(dateid: Int,timeid: Int,timeendid: Int, spaid: Int){
        let timeslot = TimeSlot(dateIndex: dateid, timeIndex: timeid, timeEndIndex: timeendid, spaceIndex:spaid, event: .release)
        let schedule = ParkingSchedule.init(year: timeslot.start_year, month: timeslot.start_month, day: timeslot.start_day, hour: timeslot.start_hour, minute: timeslot.start_minute, durationHour: timeslot.duration_hour, durationMinute: timeslot.duration_minute, parkingLotID: "Test")
        //timeSlotList.append(secondEvent)
        
        myParkingSchdules.append(schedule)
        
        // TODO: Upload the updated schedule to Server
        
        self.dayView.reloadData()
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]()
        
        print("Load view of \(myParkingSchdules.count) events")
        
        for schedule in myParkingSchdules {
            //print("Calendar load \(schedule)")
            
            // Create new EventView
            let event = Event()
        
            // Specify TimePeriod
        
            let datePeriod = TimePeriod(beginning: schedule.startDateTime, end: schedule.endDateTime)
            event.datePeriod = datePeriod

            // Set "text" value of event by formatting all the information needed for display
            event.color = UIColor.white
            event.backgroundColor = UIColor.blue
            event.text = "\(schedule.parkingLotID)\n \(datePeriod.beginning!.format(with: "HH:mm")) - \(datePeriod.end!.format(with: "HH:mm"))"
            events.append(event)
        }
        
        return events
    }

    // MARK: DayViewDelegate
    override func dayViewDidSelectEventView(_ eventview: EventView) {
        print("Event has been selected: \(eventview.descriptor?.datePeriod)")
        
    }
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        
        print("Event has been longPressed: \(eventView.descriptor?.datePeriod.beginning)")
        let alert = UIAlertController(title: "Delete?", message: "Do you want to delete this timeslot?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let selectedPeriod = eventView.descriptor?.datePeriod
            if let selectedPeriod = selectedPeriod, let startTime = selectedPeriod.beginning, let endTime = selectedPeriod.end {
                var indexToBeDeleted: Int?
                for (index, schdule) in myParkingSchdules.enumerated() {
                    if schdule.startDateTime.equals(startTime) && schdule.endDateTime.equals(endTime) {
                        print("Delete \(startTime) \(endTime)")
                        indexToBeDeleted = index
                        break;
                    }
                }
                
                // Delete that timeslot
                if let i = indexToBeDeleted {
                    print("Array size : \(myParkingSchdules.count)")
                    print("Delete \(i)")
                    //myParkingSchdules.removeAll()
                    myParkingSchdules.remove(at: i)
                    self.dayView.reloadData()
                    self.dayView.reloadInputViews()
                    //eventView.reloadInputViews()
                    
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
}
