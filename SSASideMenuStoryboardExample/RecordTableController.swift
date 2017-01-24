//
//  ViewController.swift
//  Cell Expander
//
//  Created by Christian Di Lorenzo on 4/7/15.
//  Copyright (c) 2015 Christian Di Lorenzo. All rights reserved.
//

import UIKit
let cellID = "cell"

var titleColor: [String] = ["#0091EA","#FF3D00","#6200EA","#C51162"]
var cellColor: [String] = ["#80D8FF","#FF9E80","#EA80FC","#FF80AB"]

class RecordTableController: UITableViewController {
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        self.tableView.delegate?.tableView!(self.tableView, didSelectRowAt: indexPath)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RecordTableViewCell
        
        let imageArray: [UIImageView] = [cell.cellBackground, cell.spaceLogo, cell.parkTimeLogo, cell.chargeLogo, cell.inTimeLogo, cell.outTimeLogo]
        let labelArray: [UILabel] = [cell.spaceText, cell.parkTimeText, cell.chargeText, cell.inTimeText, cell.outTimeText]
        
        cell.titleLabel.text = "Test Title"
        //color
        cell.cellTitleBoard.backgroundColor = hexColor(hex: titleColor[indexPath.row % titleColor.count])
        cell.cellBackground.backgroundColor = hexColor(hex: cellColor[indexPath.row % cellColor.count])
        //round corner
        cell.cellTitleBoard.layer.cornerRadius = 10
        cell.cellBackground.layer.cornerRadius = 10
        //shadow
        cell.cellTitleBoard.layer.shadowColor = UIColor.black.cgColor
        cell.cellTitleBoard.layer.shadowOpacity = 1
        cell.cellTitleBoard.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.cellTitleBoard.layer.shadowRadius = 10
        for image in imageArray{
            image.layer.shadowColor = UIColor.black.cgColor
            image.layer.shadowOpacity = 0.5
            image.layer.shadowOffset = CGSize(width: 0, height: 0)
            image.layer.shadowRadius = 5
        }
        for text in labelArray{
            text.layer.shadowColor = UIColor.black.cgColor
            text.layer.shadowOpacity = 1
            text.layer.shadowOffset = CGSize(width: 0, height: 0)
            text.layer.shadowRadius = 5
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! RecordTableViewCell).watchFrameChanges()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! RecordTableViewCell).ignoreFrameChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [RecordTableViewCell] {
            cell.ignoreFrameChanges()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return RecordTableViewCell.expandedHeight
        } else {
            return RecordTableViewCell.defaultHeight
        }
    }
    
       
}

