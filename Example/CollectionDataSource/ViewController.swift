//
//  ViewController.swift
//  CollectionDataSource
//
//  Created by Sam Williams on 11/23/2015.
//  Copyright (c) 2015 Sam Williams. All rights reserved.
//

import UIKit
import CollectionDataSource

class ViewController: UITableViewController {
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    func loadData() {
        self.dataSource <<< Section(title: "Static Rows") { section in
            section <<< TableViewItem<CustomButtonCell>(storyboardIdentifier: "ButtonCell") { cell in
                cell.backgroundColor = UIColor.greenColor()
                cell.button?.setTitle("PRESS ME", forState: .Normal)
            }
            section <<< TableViewItem<UITableViewCell> { cell in
                cell.textLabel?.text = "Hello"
                }.onTap { _ in
                    print("hello there")
                }.onDelete { _ in
                    print("deleted!")
            }
        }
        
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }

}

