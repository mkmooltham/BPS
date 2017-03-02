//
//  ParkingRecord.swift
//  SSASideMenuStoryboardExample
//
//  Created by BennyO on 2/3/2017.
//  Copyright © 2017 SebastianAndersen. All rights reserved.
//

import Foundation

class ParkingRecord {
    
    var parkingSpaceName: String?
    var checkinTime: Date?
    var checkoutTime: Date?
    
    // String to display in the table view
    
    var checkinTimeString: String? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let inTime = checkinTime {
                return dateFormatter.string(from: inTime)
            }
            return nil
        }
    }
    
    var checkoutTimeString: String? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let outTime = checkoutTime {
                return dateFormatter.string(from: outTime)
            }
            return nil
        }
    }
    
    var dateString: String? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let inTime = checkinTime {
                return dateFormatter.string(from: inTime)
            }
            return nil
        }
    }
    
    init(name: String?, checkinTimeString: Date?, checkoutTimeString: Date?) {
        parkingSpaceName = name
        checkinTime = checkinTimeString
        checkoutTime = checkoutTimeString
    }
    
}
