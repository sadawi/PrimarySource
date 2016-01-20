//
//  MenuViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 1/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import PrimarySource

class MenuViewController: DataSourceViewController {
    override func configureDataSource(dataSource: DataSource) {
        dataSource <<< Section { section in
            section <<< TableViewItem<TableCell> { cell in
                cell.textLabel?.text = "Basic"
                cell.accessoryType = .DisclosureIndicator
                }.onTap { _ in
                    let controller = ViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
            }
            
            section <<< TableViewItem<TableCell> { cell in
                cell.textLabel?.text = "Animations"
                cell.accessoryType = .DisclosureIndicator
                }.onTap { _ in
                    let controller = AnimationsViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }
    }
}