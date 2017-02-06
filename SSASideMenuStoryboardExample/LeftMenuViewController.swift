//
//  LeftMenuViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import Foundation
import UIKit

class LeftMenuViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 20, y: (self.view.frame.size.height - 54 * 5) / 2.0, width: self.view.frame.size.width, height: 54 * 5)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.bounces = false
        return tableView
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.addSubview(tableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


// MARK : TableViewDataSource & Delegate Methods

extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
   
        let titles: [String] = ["Home", "Park Status", "Record", "Share", "Account"]
        
        let images: [String] = ["IconHome", "IconEmpty", "IconCalendar", "IconSettings", "IconProfile"]
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text  = titles[indexPath.row]
        cell.selectionStyle = .none
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
     
        switch indexPath.row {
        case 0:
            let storyboard = self.storyboard
            let controller = storyboard?.instantiateViewController(withIdentifier: "Home")
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller!)
            sideMenuViewController?.hideMenuViewController()
            break
        case 1:
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: ParkInfoViewController())
            sideMenuViewController?.hideMenuViewController()
            break
        case 2:
            let storyboard = self.storyboard
            let controller2 = storyboard?.instantiateViewController(withIdentifier: "Record")
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller2!)
            sideMenuViewController?.hideMenuViewController()
        case 3:
            let storyboard = self.storyboard
            let controller1 = storyboard?.instantiateViewController(withIdentifier: "ParkInfo")
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller1!)
            sideMenuViewController?.hideMenuViewController()
        case 4:
            let storyboard = self.storyboard
            if signIned == false{
                let controller1 = storyboard?.instantiateViewController(withIdentifier: "Account")
                sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller1!)
                sideMenuViewController?.hideMenuViewController()
            }else{
                let controller1 = storyboard?.instantiateViewController(withIdentifier: "Profile")
                sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller1!)
                sideMenuViewController?.hideMenuViewController()
            }
            
        default:
            break
        }
        
        
    }
    
}
    
