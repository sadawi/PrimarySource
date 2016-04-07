//
//  ViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 11/23/2015.
//  Copyright (c) 2015 Sam Williams. All rights reserved.
//

import UIKit
import PrimarySource

class ViewController: DataSourceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        super.viewDidLoad()
    }
    
    @IBAction func getValue(sender: AnyObject) {
        // TODO
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.reloadData()
    }
    
    @IBAction func edit(sender: AnyObject) {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
    }
    
    override func configureDataSource(dataSource: DataSource) {
        dataSource <<< Section(title: "Cells") { section in
            section <<< CollectionItem<TitleTextCell> { cell in
                cell.title = "TitleTextCell"
                cell.value = "string value"
            }
            section <<< CollectionItem<TitleTextCell> { cell in
                cell.title = "TitleTextCell"
                cell.value = "a very long string value that will probably be too long for its container.  sorry about that!"
            }
            
            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "options"
                cell.accessoryType = .DisclosureIndicator
                }.onTap { _ in
                    let c = SelectViewController(options: [1, 2, 3], value: nil)
                    c.includeNil = true
                    c.textForNil = "any number"
                    c.textForValue = { value in
                        return "number \(value)"
                    }
                    self.navigationController?.pushViewController(c, animated: true)
            }
            
            section <<< CollectionItem<MapCell> { cell in
                cell.mapHeight = 200
            }
            
            section <<< CollectionItem<StackCell> { cell in
                var views:[UIView] = []
                for i in 1...5 {
                    let view = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
                    view.text = "Item \(i)"
                    views.append(view)
                }
                cell.arrangedSubviews = views
            }
            
            section <<< CollectionItem<MultiColumnCell> { cell in
                cell.columns?.columnCount = 3
                var views:[UIView] = []
                for i in 1...10 {
                    let view = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
                    view.text = "Item \(i)"
                    views.append(view)
                }
                cell.columns?.items = views
            }
            
        }
    }
    
    
}

