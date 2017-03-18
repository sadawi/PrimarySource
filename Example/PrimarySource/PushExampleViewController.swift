//
//  PushExampleViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 3/18/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import PrimarySource

class PushExampleViewController: DataSourceViewController {
    var items: [String] = []
    
    override func configureDataSource(_ dataSource: DataSource) {
        let items = self.items
        
        dataSource <<< Section(title: "Items") { section in
            for item in items {
                section <<< CollectionItem<TableCell> { cell in
                    cell.textLabel?.text = item
                }
            }
            
            section <<< CollectionItem<PushCell> { cell in
                cell.textLabel?.text = "New item"
                cell.nextViewControllerGenerator = { ItemPickerViewController() }
            }
        }
    }
}

fileprivate class ItemPickerViewController: DataSourceViewController {
    let options = ["red", "green", "apple", "network", "Chopin", "telephone"]
    
    fileprivate override func configureDataSource(_ dataSource: DataSource) {
        for item in self.options {
            dataSource <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = item
            }
        }
    }
}
