//
//  NavigationViewController.swift
//  SSASideMenuStoryboardExample
//
//  Created by BennyO on 12/4/2017.
//  Copyright © 2017 SebastianAndersen. All rights reserved.
//

import UIKit
import WebKit

class NavigationMapController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
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

}
