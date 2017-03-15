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
            cell.buildNextViewController = { FormViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Misc"
            cell.buildNextViewController = { ViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Animations"
            cell.buildNextViewController = { AnimationsViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "List Positions"
            cell.buildNextViewController = { ListPositionsViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Reload test"
            cell.buildNextViewController = { ReloadViewController() }
        }

        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Common configuration"
            cell.buildNextViewController = { _ in CommonConfigurationViewController() }
        }
        
    }
}
