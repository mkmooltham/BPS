//
//  PickerTableViewCell.swift
//  Cell Expander
//
//  Created by Christian Di Lorenzo on 4/7/15.
//  Copyright (c) 2015 Christian Di Lorenzo. All rights reserved.
//

import UIKit

class RecordTableViewCell : UITableViewCell {
    var isObserving = false;
    @IBOutlet weak var titleLabel:         UILabel!
    @IBOutlet weak var cellBackground: UIImageView!
    @IBOutlet weak var cellTitleBoard: UIImageView!
    @IBOutlet weak var spaceLogo:      UIImageView!
    @IBOutlet weak var spaceText:          UILabel!
    @IBOutlet weak var parkTimeLogo:   UIImageView!
    @IBOutlet weak var parkTimeText:       UILabel!
    @IBOutlet weak var chargeLogo:     UIImageView!
    @IBOutlet weak var chargeText:         UILabel!
    @IBOutlet weak var inTimeLogo:     UIImageView!
    @IBOutlet weak var inTimeText:         UILabel!
    @IBOutlet weak var outTimeLogo:    UIImageView!
    @IBOutlet weak var outTimeText:        UILabel!
    
    
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat  { get { return 64  } }
   
    func checkHeight() {
        let collapsed = (frame.size.height < RecordTableViewCell.expandedHeight)
        cellBackground.isHidden = collapsed
        spaceLogo.isHidden = collapsed
        spaceText.isHidden = collapsed
        parkTimeLogo.isHidden = collapsed
        parkTimeText.isHidden = collapsed
        chargeLogo.isHidden = collapsed
        chargeText.isHidden = collapsed
        inTimeLogo.isHidden = collapsed
        inTimeText.isHidden = collapsed
        outTimeLogo.isHidden = collapsed
        outTimeText.isHidden = collapsed
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}
