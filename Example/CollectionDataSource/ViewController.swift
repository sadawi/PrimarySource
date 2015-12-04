//
//  ViewController.swift
//  CollectionDataSource
//
//  Created by Sam Williams on 11/23/2015.
//  Copyright (c) 2015 Sam Williams. All rights reserved.
//

import UIKit
import CollectionDataSource

class ViewController: DataSourceViewController {
    
    override func viewDidLoad() {
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
            section <<< TableViewItem<StackCell> { cell in
                var views:[UIView] = []
                for i in 1...5 {
                    let view = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
                    view.text = "Item \(i)"
                    views.append(view)
                }
                cell.arrangedSubviews = views
            }
            
            section <<< TableViewItem<MultiColumnCell> { cell in
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
        
        dataSource <<< Section(title: "Form") { section in
            section <<< TableViewItem<TextFieldCell>(key: "name") { cell in
                cell.labelPosition = .Top
                cell.title = "Name"
                cell.placeholderText = "Enter a full name"
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
                cell.value = "948AAA"
                cell.state = FieldState.Error(["Looks like this phone number is invalid!"])
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< TableViewItem<DateFieldCell>(key: "birthday") { cell in
                cell.title = "Birthday"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< TableViewItem<StepperCell>(key: "problems") { cell in
                cell.title = "Problems"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< TableViewItem<SelectCell<String>>(key: "gender") { cell in
                cell.title = "Gender"
                cell.options = ["male", "female", "other"]
                cell.selectMode = .Push
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
        }
        
        dataSource <<< Section(title: "List") { section in
            for i in 1...25 {
                section <<< TableViewItem<UITableViewCell>(reorderable: true) { cell in
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
        
        dataSource <<< Section(title: "Manual Rows") { section in
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
    }
}

