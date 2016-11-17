//
//  ListPositionsViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 2/23/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import PrimarySource

class ListPositionsViewController: DataSourceViewController {
    var items: [ListMembership] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        self.items = [
            .contained(position: .End),
            .notContained,
            .contained(position: .Middle),
            .contained(position: .Middle),
            .contained(position: .Middle),
        ]
        self.reloadData()
    }
    
    override func configureDataSource(_ dataSource: DataSource) {
        dataSource <<< Section() { section in
            for item in self.items {
                let collectionItem = CollectionItem<TableCell> { cell in
                    cell.borderStyle = BorderStyle(top: .auto, bottom: .auto)
                    
                    switch cell.listMembership {
                    case .notContained:
                        cell.textLabel?.text = "Not contained"
                        cell.backgroundColor = UIColor(white: 0.9, alpha: 1)
                    case .contained(let position):
                        cell.backgroundColor = UIColor.clear
                        cell.textLabel?.text = "\(position)"
                    }
                }
                collectionItem.listMembership = item
                section <<< collectionItem
            }
        }
    }
}
