//
//  invoiceController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 18/4/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class InvoiceController: UIViewController {
    
    //Label
    @IBOutlet weak var checkInTime: UILabel!
    @IBOutlet weak var checkOutTime: UILabel!
    @IBOutlet weak var parkHour: UILabel!
    @IBOutlet weak var hourlyCharge: UILabel!
    @IBOutlet weak var totalCharge: UILabel!
    

    @IBAction func close(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.sideMenuViewController?.contentViewController = UINavigationController(rootViewController: controller!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar
        menuButton.setImage(UIImage(named: "menuIcon.png"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: barButtonSize, height: barButtonSize)
        menuButton.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: .touchUpInside)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let navbarFont = UIFont(name: "Ubuntu", size: titleSize) ?? UIFont.systemFont(ofSize: titleSize)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName:UIColor.lightText]
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        //Read Data
        checkInTime.text = checkoutInvoiceRecord.checkinTimeDetailedString
        checkOutTime.text = checkoutInvoiceRecord.checkoutTimeDetailedString
        parkHour.text = checkoutInvoiceRecord.parkingHourString
        hourlyCharge.text = "$40"
        totalCharge.text = checkoutInvoiceRecord.parkingChargeString
    }
    
    
}
