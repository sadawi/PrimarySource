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
            cell.nextViewControllerGenerator = { FormViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Misc"
            cell.nextViewControllerGenerator = { ViewController() }
        }

        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Navigation"
            cell.nextViewControllerGenerator = { PushExampleViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Animations"
            cell.nextViewControllerGenerator = { AnimationsViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "List Positions"
            cell.nextViewControllerGenerator = { ListPositionsViewController() }
        }
        
        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Reload test"
            cell.nextViewControllerGenerator = { ReloadViewController() }
        }

        dataSource <<< CollectionItem<PushCell> { cell in
            cell.textLabel?.text = "Common configuration"
            cell.nextViewControllerGenerator = { _ in CommonConfigurationViewController() }
        }
        
    }
}
