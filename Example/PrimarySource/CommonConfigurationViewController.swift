//
//  CommonConfigurationViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 3/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import PrimarySource

enum Style {
    case normal
    case highlighted
    
    var color: UIColor {
        switch(self) {
        case .normal: return .clear
        case .highlighted: return .yellow
        }
    }
}

class CommonConfigurationViewController: DataSourceViewController {
    var style: Style? = .normal
    
    override func configureDataSource(_ dataSource: DataSource) {
        dataSource.configureView = { [weak self] view in
            if let cell = view as? UITableViewCell {
                if let style = self?.style {
                    cell.backgroundColor = style.color
                }
            }
        }
        
        dataSource <<< Section { section in
            section <<< CollectionItem<SegmentedSelectCell<Style>> { [weak self] cell in
                cell.options = [.normal, .highlighted]
                cell.value = self?.style
                cell.onChange = { [weak cell] in
                    self?.style = cell?.value
                    self?.reloadData()
                }
            }
        }
        dataSource <<< Section { section in
            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "one"
            }
            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "two"
            }
            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "three"
            }
        }
    }
}
