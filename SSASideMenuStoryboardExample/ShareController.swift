//
//  ShareController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 13/3/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class ShareController: UIViewController, AddEventControllerDelegate {
    
    @IBOutlet weak var addEventButton: UIButton!
    private var embeddedViewController: CalendarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Title
        title = "Park Share"
        
        //Config
        addEventButton.layer.cornerRadius = addEventButton.frame.height/2
        addEventButton.layer.shadowColor = hexColor(hex: "#18FFFF").cgColor
        addEventButton.layer.shadowOpacity = 0.6
        addEventButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        addEventButton.layer.shadowRadius = 8
        
        //Navigation bar
        menuButton.setImage(UIImage(named: "menuIcon.png"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: barButtonSize, height: barButtonSize)
        menuButton.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let navbarFont = UIFont(name: "Ubuntu", size: titleSize) ?? UIFont.systemFont(ofSize: titleSize)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName:UIColor.lightText]
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let vc = segue.destination as? CalendarController, segue.identifier == "calendarSegue" {
            self.embeddedViewController = vc
        }
    }
    
    func pushEventToCalendar(){
        self.embeddedViewController.addEventToCalendar(dateid: whatDayIndex, timeid: whatTimeIndex, dur: "2.5")
    }
    
    @IBAction func addEvent(_ sender: UIButton) {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpAddEvent") as! AddEventController
        whatTimeIndex = 0
        whatDayIndex = 0
        popUpVC.delegate = self
        self.addChildViewController(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

