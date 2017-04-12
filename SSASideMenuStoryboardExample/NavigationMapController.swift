//
//  NavigationViewController.swift
//  SSASideMenuStoryboardExample
//
//  Created by BennyO on 12/4/2017.
//  Copyright © 2017 SebastianAndersen. All rights reserved.
//

import UIKit
import WebKit

class NavigationMapController: UIViewController, WKUIDelegate, ESTBeaconManagerDelegate {

    var webView: WKWebView!
    let beaconManager = ESTBeaconManager();
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Navigation View Controller loaded")

//        let url = URL(string: "https://google.com")!
//        webView.load(URLRequest(url: url))
        
        // load the car park main web view
        webView.load(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "web/index", ofType: "html")!)))
        
        // add observer to monitor if the web content complete loading
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        // add beaconManger delegate
        self.beaconManager.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.beaconManager.startRangingBeacons(in: appDelegate.navigationBeaconRegion)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("web content is loaded");

        let dataJsonString = "'[{\"bid\": 22, \"rssi\": -59}]'";
        let javaScriptFunctionString = "updateMarker(0, 0, 'p55', \(dataJsonString))"
        print(javaScriptFunctionString)
        self.webView.evaluateJavaScript(javaScriptFunctionString, completionHandler: { (result:Any?, error:Error?) in
            if let err = error {
                print(err)
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // unregister the observer
        webView.removeObserver(self, forKeyPath: "loading", context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // beacon ranging
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //print(beacons)
        let knownBeacons = beacons.filter { (beacon:CLBeacon) -> Bool in
            beacon.proximity != .unknown
        }
        print("known beacons: \(knownBeacons)")
        if(knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            print(closestBeacon)
            let dataJsonString = "'[{\"bid\": \(closestBeacon.major), \"rssi\": \(closestBeacon.rssi)}]'";
            let javaScriptFunctionString = "updateMarker(0, 0, 'p55', \(dataJsonString))"
            callJavaScriptFunction(fn: javaScriptFunctionString)
        }
    }
    
    func callJavaScriptFunction(fn: String) {
        print("Calling \(fn)")
        self.webView.evaluateJavaScript(fn, completionHandler: { (result:Any?, error:Error?) in
            if let err = error {
                print(err)
            }
        })
    }
    
    func beaconManager(_ manager: Any, rangingBeaconsDidFailFor region: CLBeaconRegion?, withError error: Error) {
        print("fail ranging beacon: \(error)");
        // alert user to turn on bluetooth
        self.parent?.present(getErrorAlertCtrl(title: "Turn on Bluetooth", message: "Please turn on bluetooth to start navigation"),
                animated: true, completion: nil)
    }

}
