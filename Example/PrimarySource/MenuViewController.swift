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
    override func configureDataSource(_ dataSource: DataSource) {
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Form"
            cell.buildNextViewController = { _ in FormViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Misc"
            cell.buildNextViewController = { _ in ViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Animations"
            cell.buildNextViewController = { _ in AnimationsViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "List Positions"
            cell.buildNextViewController = { _ in ListPositionsViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Reload test"
            cell.buildNextViewController = { _ in ReloadViewController() }
        }

        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Common configuration"
            cell.buildNextViewController = { _ in CommonConfigurationViewController() }
        }
        
    }
}
