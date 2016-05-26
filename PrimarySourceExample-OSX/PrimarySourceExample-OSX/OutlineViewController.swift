//
//  OutlineViewController.swift
//  PrimarySourceExample-OSX
//
//  Created by Sam Williams on 5/26/16.
//  Copyright © 2016 Sam Williams. All rights reserved.
//

import Foundation
import Cocoa
import PrimarySource

private let kNameColumnIdentifier = "Name"
private let kAgeColumnIdentifier = "Size"

struct Place {
    var name: String
    var size: Int
    var children: [Place] = []
}

class OutlineViewController: NSViewController {
    @IBOutlet var outlineView: NSOutlineView!
    
    var dataSource = ColumnedDataSource()
    
    var places: [Place] = {
        return [
            Place(name: "Europe", size: 22, children: [
                Place(name: "UK", size: 15, children: []),
                Place(name: "Germany", size: 15, children: []),
                Place(name: "Han Solo", size: 15, children: []),
                Place(name: "France", size: 15, children: []),
                ]),
            Place(name: "Asia", size: 22, children: [
                Place(name: "Thailand", size: 1, children: []),
                Place(name: "China", size: 154, children: []),
                Place(name: "Japan", size: 13, children: []),
                ]),
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.outlineView.setDataSource(self.dataSource)
        self.outlineView.setDelegate(self.dataSource)
        self.configureDataSource(self.dataSource)
        self.outlineView.reloadData()
    }
    
    func configureDataSource(dataSource: ColumnedDataSource) {
//        dataSource <<< Column(identifier: kNameColumnIdentifier, title: "Name")
//        dataSource <<< Column(identifier: kAgeColumnIdentifier, title: "Age")
        
        dataSource <<< Section(title: "Section 1") { section in
            for place in self.places {
                section <<< self.buildRow(place: place)
            }
        }
    }
    
    func buildRow(place place: Place) -> ColumnedCollectionItemType? {
        let result = ColumnedCollectionItem<NSTableRowView> { item -> () in
            item[kNameColumnIdentifier] = CollectionItem<NSTableCellView>(storyboardIdentifier: "NameCellView") { cell in
                cell.textField?.stringValue = place.name
            }
            item[kAgeColumnIdentifier] = CollectionItem<NSTableCellView>(storyboardIdentifier: "SizeCellView") { cell -> () in
                cell.textField?.integerValue = place.size
            }
        }
        result.children = place.children.map { self.buildRow(place: $0) }.flatMap { $0 }
        return result
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}