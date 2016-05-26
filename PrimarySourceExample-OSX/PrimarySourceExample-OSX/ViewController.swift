//
//  ViewController.swift
//  PrimarySourceExample-OSX
//
//  Created by Sam Williams on 5/25/16.
//  Copyright © 2016 Sam Williams. All rights reserved.
//

import Cocoa
import PrimarySource

let kNameColumnIdentifier = "name"
let kAgeColumnIdentifier = "age"

class ViewController: NSViewController {

    @IBOutlet var tableView: NSTableView!
    @IBOutlet var outlineView: NSOutlineView!
    
    var dataSource = ColumnedDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setDataSource(self.dataSource)
        self.tableView.setDelegate(self.dataSource)
        self.configureDataSource(self.dataSource)
        self.tableView.reloadData()
    }

    func configureDataSource(dataSource: ColumnedDataSource) {
        dataSource <<< Column(identifier: kNameColumnIdentifier, title: "Name")
        dataSource <<< Column(identifier: kAgeColumnIdentifier, title: "Age")
        
        dataSource <<< Section(title: "Section 1") { section in
            section <<< ColumnedCollectionItem<NSTableRowView>(storyboardIdentifier: "NormalRow", configureItem: { item in
                item[kNameColumnIdentifier] = CollectionItem<NSTableCellView> { cell in
                }
            })
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

