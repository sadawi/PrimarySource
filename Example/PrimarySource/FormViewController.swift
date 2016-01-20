//
//  FormViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import PrimarySource

class FormViewController: DataSourceViewController {
    override func configureDataSource(dataSource: DataSource) {
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
            section <<< TableViewItem<PushSelectCell<String>>(key: "gender") { cell in
                cell.title = "Gender"
                cell.options = ["male", "female", "other"]
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
        }

    }
}