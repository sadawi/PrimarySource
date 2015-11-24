//
//  ViewController.swift
//  CollectionDataSource
//
//  Created by Sam Williams on 11/23/2015.
//  Copyright (c) 2015 Sam Williams. All rights reserved.
//

import UIKit
import CollectionDataSource

class ViewController: UITableViewController {
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    @IBAction func getValue(sender: AnyObject) {
        // TODO
    }
    @IBAction func edit(sender: AnyObject) {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
    }
    
    func loadData() {
        self.dataSource <<< Section(title: "Manual Rows") { section in
            section <<< TableViewItem<CustomButtonCell>(storyboardIdentifier: "ButtonCell") { cell in
                cell.backgroundColor = UIColor.greenColor()
                cell.button?.setTitle("PRESS ME", forState: .Normal)
            }
            section <<< TableViewItem<UITableViewCell> { cell in
                cell.textLabel?.text = "Hello"
                }.onTap { _ in
                    print("hello there")
                }.onDelete { _ in
                    print("deleted!")
            }
        }
        
        self.dataSource <<< Section(title: "form") { section in
            section <<< TableViewItem<TextFieldCell>(key: "name") { cell in
                cell.title = "Name"
                cell.onChange = { [weak cell] in
                    print("New value: \(cell?.value)")
                }
            }
            section <<< TableViewItem<SwitchCell>(key: "active") { cell in
                cell.title = "Active"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< TableViewItem<EmailAddressCell>(key: "email") { cell in
                cell.title = "Email address"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< TableViewItem<PhoneNumberCell>(key: "phone") { cell in
                cell.title = "Phone number"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
        }
        
        self.dataSource <<< Section(title: "List") { section in
            for i in 1...5 {
                section <<< TableViewItem<UITableViewCell> { cell in
                    cell.textLabel?.text = "Value \(i)"
                    }.onDelete { _ in
                }
            }
            
            section <<< TableViewItem<ButtonCell> { cell in
                cell.title = "Add"
                cell.onTap = {
                    print("O!")
                }
            }
        }
        
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
}

