//
//  ParkSpaceController.swift
//  SSASideMenuStoryboardExample
//
//  Created by RAYW2 on 9/1/2017.
//  Copyright © 2017年 SebastianAndersen. All rights reserved.
//

import UIKit

class ParkSpaceController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var arrivedButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var infoBoardView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Title
        title = "Park Space"
        
        //Config
        //round corner
        arrivedButton.layer.cornerRadius = 10
        arrivedButton.layer.cornerRadius = 10
        //shadow
        arrivedButton.layer.shadowColor = UIColor.black.cgColor
        arrivedButton.layer.shadowOpacity = 1
        arrivedButton.layer.shadowOffset = CGSize(width: 1, height: -1)
        arrivedButton.layer.shadowRadius = 10
        
        //Naivgation Bar
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ParkSpaceController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightText
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let navbarFont = UIFont(name: "Ubuntu", size: titleSize) ?? UIFont.systemFont(ofSize: titleSize)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName:UIColor.lightText]
        
        //zoom config
        scrollView.backgroundColor = hexColor(hex: "#212121")
        setZoomScale()
        
        //Orientation change
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    //Back button
    func back(sender: UIBarButtonItem) {
        //code//
        _ = navigationController?.popViewController(animated: true)
    }
    
    //Zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapImage
    }
    func setZoomScale() {
        
        let imageViewSize = mapImage.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / (imageViewSize.width)
        let heightScale = scrollViewSize.height / (imageViewSize.height)
        
        scrollView.zoomScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.maximumZoomScale = 2.0
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    //orientation change
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func rotated(){
        if UIDevice.current.orientation.isLandscape{
            infoBoardView.layer.cornerRadius = 10
            infoBoardView.layer.cornerRadius = 10
            print("Landscape")
        }else{
            infoBoardView.layer.cornerRadius = 0
            infoBoardView.layer.cornerRadius = 0
            print("Portrait")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
