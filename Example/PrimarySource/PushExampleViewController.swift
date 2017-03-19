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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure { [weak self] dataSource in
            guard let items = self?.items else { return }
            
            dataSource <<< Section(title: "Items") { section in
                for item in items {
                    section <<< CollectionItem<TableCell> { cell in
                        cell.textLabel?.text = item
                        }.didDelete { _ in
                            self?.remove(item)
                    }
                }
                
                section <<< CollectionItem<PushCell> { cell in
                    cell.textLabel?.text = "New item"
                    cell.nextViewControllerGenerator = {
                        let controller = ItemPickerViewController()
                        controller.action = { value in
                            self?.items.append(value)
                            dataSource.reload()
                        }
                        return controller
                    }
                }
            }
        }
    }
    
    func remove(_ value: String) {
        if let index = self.items.index(of: value) {
            self.items.remove(at: index)
        }
    }

}

fileprivate class ItemPickerViewController: DataSourceViewController {
    let options = ["red", "green", "apple", "network", "Chopin", "telephone"]
    
    var action: ((String)->())?
    
    fileprivate override func configure(_ dataSource: DataSource) {
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
