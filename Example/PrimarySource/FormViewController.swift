//
//  FormViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import PrimarySource

class FormViewController: DataSourceViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Changing values may change cell heights.  This is needed to update them correctly. 
        self.reloadData()
    }
    
    override func configureDataSource(dataSource: DataSource) {
        dataSource <<< Section(title: "Form") { section in
            section <<< CollectionItem<TextFieldCell>(key: "name") { cell in
                cell.labelPosition = .Top
                cell.title = "Name"
                cell.placeholderText = "Enter a full name"
                cell.onChange = { [weak cell] in
                    print("New value: \(cell?.value)")
                }
            }
            section <<< CollectionItem<SwitchCell>(key: "active") { cell in
                cell.title = "Active"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< CollectionItem<EmailAddressCell>(key: "email") { cell in
                cell.title = "Email address"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< CollectionItem<PhoneNumberCell>(key: "phone") { cell in
                cell.title = "Phone number"
                cell.value = "948AAA"
                cell.state = FieldState.Error(["Looks like this phone number is invalid!"])
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< CollectionItem<DateFieldCell>(key: "birthday") { cell in
                cell.title = "Birthday"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< CollectionItem<MonthYearPickerCell>(key: "expiration") { cell in
                cell.title = "Expiration Date"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< CollectionItem<StepperCell>(key: "problems") { cell in
                cell.title = "Problems"
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            section <<< CollectionItem<PushSelectCell<String>>(key: "gender") { cell in
                cell.title = "Gender"
                cell.options = ["male", "female", "other"]
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }

            section <<< CollectionItem<PushSelectCell<String>>(key: "long") { cell in
                cell.title = "String"
                cell.options = ["short", "a very long string that has no hope of staying within the bounds initially created for it, but should still be displayable"]
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
            
            section <<< CollectionItem<PushSelectCell<String>>(key: "long") { cell in
                cell.title = "String"
                cell.labelPosition = .Top
                cell.options = ["short", "a very long string that has no hope of staying within the bounds initially created for it, but should still be displayable"]
                cell.onChange = { [unowned cell] in
                    print("New value: \(cell.value)")
                }
            }
        }
        
        dataSource <<< Section(title: "Convert to & from strings") { section in
            section <<< CollectionItem<TextFieldValueCell<String>> { cell in
                cell.title = "String"
                cell.textForValue = { value in
                    return value.uppercaseString
                }
                cell.valueForText = { value in
                    return value.lowercaseString
                }
                cell.onChange = { [weak cell] in
                    print("cell value changed to: ", cell?.value)
                }
            }
            section <<< CollectionItem<TextFieldValueCell<Int>> { cell in
                cell.title = "Int"
                cell.textForValue = { value in
                    return String(value)
                }
                cell.valueForText = { value in
                    return Int(value)
                }
                cell.onChange = { [weak cell] in
                    print("cell value changed to: ", cell?.value)
                }
            }
        }
        
    }
}