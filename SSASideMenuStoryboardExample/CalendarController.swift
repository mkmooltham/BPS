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

enum SelectedStyle {
    case Dark
    case Light
}

class CalendarController: DayViewController {
    
    var data = [["Reserved",
                 "HKUST"],
                
                ["Reserved",
                 "HKUST"],
                
                ["Reserved",
                 "HKUST"],
                
                ["Reserved",
                 "HKUST"],
                
                ["Free",
                 "HKUST"],
                
                ["Free",
                 "HKUST"],
                
                ["Free",
                 "HKUST"],
                
                ["Rent Out",
                 "HKUST"],
                
                ["Rent Out",
                 "HKUST"],
                
                ]
    
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.black,
                  UIColor.green,
                  UIColor.red]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calendar Style
        var style: CalendarStyle!
        style = StyleGenerator.darkStyle()
        updateStyle(style)        

        }
 
    // MARK: DayViewDataSource
    override func eventViewsForDate(_ date: Date) -> [EventView] {
        var date = date.add(TimeChunk(seconds: 0, minutes: 0, hours: Int(arc4random_uniform(10) + 5), days: 0, weeks: 0, months: 0, years: 0))
        var events = [EventView]()
        
        for _ in 0...5 {
            let event = EventView()
            let duration = Int(arc4random_uniform(160) + 60)
            let datePeriod = TimePeriod(beginning: date,
                                        chunk: TimeChunk(seconds: 0, minutes: duration, hours: 0, days: 0, weeks: 0, months: 0, years: 0))
            
            event.datePeriod = datePeriod
            var info = data[Int(arc4random_uniform(UInt32(data.count)))]
            info.append("\(datePeriod.beginning!.format(with: "HH:mm")!) - \(datePeriod.end!.format(with: "HH:mm")!)")
            event.data = info
            event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
            events.append(event)
            
            let nextOffset = Int(arc4random_uniform(250) + 40)
            date = date.add(TimeChunk(seconds: 0, minutes: nextOffset, hours: 0, days: 0, weeks: 0, months: 0, years: 0))
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
