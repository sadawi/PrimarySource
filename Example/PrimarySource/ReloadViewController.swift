//
//  File.swift
//  PrimarySource
//
//  Created by Sam Williams on 3/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import PrimarySource

class ReloadViewController: DataSourceViewController {
    override func configureDataSource(dataSource: DataSource) {
        dataSource <<< Section { section in
            section <<< CollectionItem<TableCell> { cell in
                print("tapping")
                cell.textLabel?.text = "tap"
                }.onTap { _ in
                    self.reloadData()
            }
        }
    }
}