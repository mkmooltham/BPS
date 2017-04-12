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
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://google.com")!
        webView.load(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
