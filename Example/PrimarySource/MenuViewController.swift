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
            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "Form"
                cell.accessoryType = .disclosureIndicator
                }.onTap { _ in
                    let controller = FormViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
            }

            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "Misc"
                cell.accessoryType = .disclosureIndicator
                }.onTap { _ in
                    let controller = ViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
            }
            
            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "Animations"
                cell.accessoryType = .disclosureIndicator
                }.onTap { _ in
                    let controller = AnimationsViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
            }

            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "List Positions"
                cell.accessoryType = .disclosureIndicator
                }.onTap { _ in
                    let controller = ListPositionsViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
            }
            
            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "Reload test"
                cell.accessoryType = .disclosureIndicator
                }.onTap { _ in
                    let controller = ReloadViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
            }

            
        }
    }
}
