//
//  ViewController.swift
//  PrimarySourceExample-OSX
//
//  Created by Sam Williams on 5/25/16.
//  Copyright © 2016 Sam Williams. All rights reserved.
//

import Cocoa
import PrimarySource

let kNameColumnIdentifier = "Name"
let kAgeColumnIdentifier = "Age"

class ViewController: NSViewController {

    @IBOutlet var tableView: NSTableView!
    @IBOutlet var outlineView: NSOutlineView!
    
    var dataSource = ColumnedDataSource()
    
    var people: [Person] = {
        return [
            Person(name: "Alice", age: 49),
            Person(name: "Bob", age: 50),
            Person(name: "Martha", age: 22),
        ]
    }()
    
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
            for person in self.people {
                section <<< ColumnedCollectionItem<NSTableRowView> { item -> () in
                    item[kNameColumnIdentifier] = CollectionItem<NSTableCellView>(storyboardIdentifier: "NameCellView") { cell in
                        cell.textField?.stringValue = person.name
                    }
                    item[kAgeColumnIdentifier] = CollectionItem<NSTableCellView>(storyboardIdentifier: "AgeCellView") { cell -> () in
                        cell.textField?.integerValue = person.age
                    }
                }
            }
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

