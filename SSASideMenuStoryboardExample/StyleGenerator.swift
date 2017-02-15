//
//  StyleGenerator.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 15/2/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import CalendarKit
import DynamicColor

struct StyleGenerator {
    static func defaultStyle() -> CalendarStyle {
        return CalendarStyle()
    }
    
    static func darkStyle() -> CalendarStyle {
        let orange = UIColor.orange
        let dark = UIColor(hexString: "1A1A1A")
        let light = UIColor.lightGray
        let white = UIColor.white
        
        //Selected Date
        let selector = DaySelectorStyle()
        selector.activeTextColor = white
        selector.inactiveTextColor = white
        selector.selectedBackgroundColor = orange
        selector.todayActiveBackgroundColor = orange
        selector.todayInactiveTextColor = orange
        
        //Week day
        let daySymbols = DaySymbolsStyle()
        daySymbols.weekDayColor = white
        daySymbols.weekendColor = light
        
        //Current Selected Date
        let swipeLabel = SwipeLabelStyle()
        swipeLabel.textColor = white
        
        //Week Table
        let header = DayHeaderStyle()
        header.daySelector = selector
        header.daySymbols = daySymbols
        header.swipeLabel = swipeLabel
        header.backgroundColor = hexColor(hex: bgColor)
        
        //Event Board
        let timeline = TimelineStyle()
        timeline.timeIndicator.color = orange
        timeline.lineColor = light
        timeline.timeColor = light
        timeline.backgroundColor = dark
        
        let style = CalendarStyle()
        style.header = header
        style.timeline = timeline
        
        return style
    }
}
