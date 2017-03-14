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
        dataSource <<< Section { section in
            section <<< CollectionItem<PushCell> { cell in
                cell.textLabel?.text = "Form"
                cell.buildNextViewController = { _ in FormViewController() }
            }

            section <<< CollectionItem<PushCell> { cell in
                cell.textLabel?.text = "Misc"
                cell.buildNextViewController = { _ in ViewController() }
            }
            
            section <<< CollectionItem<PushCell> { cell in
                cell.textLabel?.text = "Animations"
                cell.buildNextViewController = { _ in AnimationsViewController() }
            }

            section <<< CollectionItem<PushCell> { cell in
                cell.textLabel?.text = "List Positions"
                cell.buildNextViewController = { _ in ListPositionsViewController() }
            }
            
            section <<< CollectionItem<PushCell> { cell in
                cell.textLabel?.text = "Reload test"
                cell.buildNextViewController = { _ in ReloadViewController() }
            }

            
        }
    }
}
