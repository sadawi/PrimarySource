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
        self.items = [
            .Contained(position: .End),
            .NotContained,
            .Contained(position: .Middle),
            .Contained(position: .Middle),
            .Contained(position: .Middle),
        ]
        self.reloadData()
    }
    
    override func configureDataSource(dataSource: DataSource) {
        dataSource <<< Section() { section in
            for item in self.items {
                let collectionItem = CollectionItem<TableCell> { cell in
                    switch cell.listMembership {
                    case .NotContained:
                        cell.textLabel?.text = "Not contained"
                    case .Contained(let position):
                        cell.textLabel?.text = "\(position)"
                    }
                }
                collectionItem.listMembership = item
                section <<< collectionItem
            }
        }
    }
}