//
//  AppDelegate.swift
//  SSASideMenuStoryboardExample
//
//  Created by Sebastian S. Andersen on 01/04/15.
//  Copyright (c) 2015 SebastianAndersen. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    let beaconManager = ESTBeaconManager();
    // the beacons to be monitoring
    let entranceBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 98, identifier: "Entrance")
    let liftBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 98, identifier: "Lift")
    
    let navigationBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "BPS")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Set status bar color to light
        UIApplication.shared.statusBarStyle = .lightContent
        
        // add beaconManger delegate
        self.beaconManager.delegate = self
        
        // authorize to use location services , the description can be edited in info.plist
        self.beaconManager.requestAlwaysAuthorization()
        
        // register alert
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: .alert, categories: nil))
        
        beaconManager.returnAllRangedBeaconsAtOnce = true
        
        entranceBeaconRegion.notifyOnEntry = true
        entranceBeaconRegion.notifyOnExit = true
        
        liftBeaconRegion.notifyOnEntry = true
        liftBeaconRegion.notifyOnExit = true
        
        // start monitoring for push notification
        beaconManager.startMonitoring(for: entranceBeaconRegion)
        beaconManager.startMonitoring(for: liftBeaconRegion)
        
        // ranging the beacon rssi every second
        //beaconManager.startRangingBeacons(in: beaconRegion)
        
        
        // Parse client configuration
        Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.server = "http://opw0011.ddns.net:8000/parse/"
            configuration.applicationId = "RAYW2_BPS"
            configuration.clientKey = "291fa14b5f8dc421c65f53ab9886edce"
        }))

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Did enter background, stop ranging...")
//        beaconManager.stopMonitoringForAllRegions()
//        beaconManager.stopRangingBeaconsInAllRegions()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        beaconManager.stopMonitoringForAllRegions()
//        beaconManager.stopRangingBeaconsInAllRegions()
    }
    
    func beaconManager(_ manager: Any, didStartMonitoringFor region: CLBeaconRegion) {
        NSLog("Beacon start monitoring for region...");
    }
    
    // Trigger when entering the beacon range
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        NSLog("enter");
        let notification = UILocalNotification()
        notification.alertBody = "Welcome to UST car park! Please use the app to check in."
        UIApplication.shared.presentLocalNotificationNow(notification)
    }
    
    // Trigger when beacon is out of range for at least 30s
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        NSLog("exit");
        if region == liftBeaconRegion {
            let notification = UILocalNotification()
            notification.alertBody = "Bye, remember to get back your car later!"
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }
    
    // Trigger when the beacon state changed
    func beaconManager(_ manager: Any, didDetermineState state: CLRegionState, for region: CLBeaconRegion) {
        NSLog("determinteState")
        switch state {
        case .unknown:
            NSLog("unknown")
        case .inside:
            NSLog("inside")
        case .outside:
            NSLog("outside")
        }
    }
    
//    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        print(beacons)
//    }
    
    func beaconManager(_ manager: Any, didFailWithError error: Error) {
        print(error);
    }
    
//    func beaconManager(_ manager: Any, rangingBeaconsDidFailFor region: CLBeaconRegion?, withError error: Error) {
//        print("fail regioning \(error)");
//    }
    
    func beaconManager(_ manager: Any, monitoringDidFailFor region: CLBeaconRegion?, withError error: Error) {
        print("fail monitoring \(error)");
    }
    
    // Check the location service permission
    func beaconManager(_ manager: Any, didChange status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            simpleAlert(title: "Permission Error", message: "Need Location Service Permission To Access Beacon")
            break
            
        case .denied:
            simpleAlert(title: "Permission Error", message: "Need Location Service Permission To Access Beacon")
            break
            
        default:
            break
        }
    }
    
    func simpleAlert(title:String,message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Approve", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.window?.rootViewController?.present(alert, animated: true, completion: {
            print("completion block")
        })
    
    }
}

