//
//  ViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 11/23/2015.
//  Copyright (c) 2015 Sam Williams. All rights reserved.
//

import UIKit
import PrimarySource

class ViewController: DataSourceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        super.viewDidLoad()
    }
    
    @IBAction func getValue(sender: AnyObject) {
        // TODO
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.reloadData()
    }
    
    @IBAction func edit(sender: AnyObject) {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
    }
    
    override func configureDataSource(dataSource: DataSource) {
        dataSource <<< Section(title: "Cells") { section in
            section <<< TableViewItem<MapCell> { cell in
                cell.mapHeight = 200
            }
            
            section <<< TableViewItem<StackCell> { cell in
                var views:[UIView] = []
                for i in 1...5 {
                    let view = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
                    view.text = "Item \(i)"
                    views.append(view)
                }
                cell.arrangedSubviews = views
            }
            
            section <<< TableViewItem<MultiColumnCell> { cell in
                cell.columns?.columnCount = 3
                var views:[UIView] = []
                for i in 1...10 {
                    let view = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
                    view.text = "Item \(i)"
                    views.append(view)
                }
                cell.columns?.items = views
            }
        }
    }
    
    
}

