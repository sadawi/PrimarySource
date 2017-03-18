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
            
            section <<< CollectionItem<PushCell> { [weak self] cell in
                cell.textLabel?.text = "New item"
                cell.nextViewControllerGenerator = {
                    let controller = ItemPickerViewController()
                    controller.action = { value in
                        self?.items.append(value)
//                        self?.reloadData()
                    }
                    return controller
                }
            }
        }
    }
}

fileprivate class ItemPickerViewController: DataSourceViewController {
    let options = ["red", "green", "apple", "network", "Chopin", "telephone"]
    
    var action: ((String)->())?
    
    fileprivate override func configureDataSource(_ dataSource: DataSource) {
        for item in self.options {
            dataSource <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = item
                }.onTap { [weak self] _ in
                    self?.pick(item)
            }
        }
    }
    
    func pick(_ value: String) {
        self.action?(value)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
