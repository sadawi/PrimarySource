//
//  FormViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import PrimarySource

enum Gender: String {
    case female
    case male
    case other
    
    static var all:[Gender] = [.female, .male, .other]
}

class FormViewController: DataSourceViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Changing values may change cell heights.  This is needed to update them correctly. 
        self.reloadData()
    }
    
    override func configure(_ dataSource: DataSource) {
        dataSource <<< Section(title: "Form") { section in
            section <<< CollectionItem<TextFieldCell>(key: "name") { cell in
                cell.labelPosition = .top
                cell.title = "Name"
                cell.placeholderText = "Enter a full name"
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            section <<< CollectionItem<SwitchCell>(key: "active") { cell in
                cell.title = "Active"
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            section <<< CollectionItem<EmailAddressCell>(key: "email") { cell in
                cell.title = "Email address"
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            section <<< CollectionItem<IntegerInputCell>(key: "count") { cell in
                cell.title = "Count"
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            section <<< CollectionItem<PhoneNumberCell>(key: "phone") { cell in
                cell.title = "Phone number"
                cell.value = "948AAA"
                cell.state = FieldState.error(["Looks like this phone number is invalid!"])
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            section <<< CollectionItem<DateFieldCell>(key: "birthday") { cell in
                cell.title = "Birthday"
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            section <<< CollectionItem<MonthYearPickerCell>(key: "expiration") { cell in
                cell.title = "Expiration Date"
                cell.value = Date()
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            section <<< CollectionItem<StepperCell>(key: "problems") { cell in
                cell.title = "Problems"
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            
            section <<< CollectionItem<PushSelectCell<Gender>>(key: "gender") { cell in
                cell.title = "Gender"
                cell.options = Gender.all
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }

            section <<< CollectionItem<SegmentedSelectCell<Gender>>(key: "gender") { cell in
                cell.title = "Gender"
                cell.options = Gender.all
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }

            section <<< CollectionItem<PushSelectCell<String>>(key: "long") { cell in
                cell.title = "String"
                cell.options = ["short", "a very long string that has no hope of staying within the bounds initially created for it, but should still be displayable"]
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            
            section <<< CollectionItem<PushSelectCell<String>>(key: "long") { cell in
                cell.title = "String"
                cell.labelPosition = .top
                cell.options = ["short", "a very long string that has no hope of staying within the bounds initially created for it, but should still be displayable"]
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            
            section <<< CollectionItem<PushFieldCell<String>> { cell in
                cell.title = "Custom editor"
                cell.value = "String value"
                cell.nextViewControllerGenerator = {
                    let controller = DataSourceViewController()
                    controller.title = "Custom String Editor"
                    return controller
                }
            }
            
        }
        
        dataSource <<< Section(title: "Convert to & from strings") { section in
            section <<< CollectionItem<TextFieldInputCell<String>> { cell in
                cell.title = "String"
                cell.textForValue = { value in
                    return value.uppercased()
                }
                cell.valueForText = { value in
                    return value.lowercased()
                }
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
            section <<< CollectionItem<TextFieldInputCell<Int>> { cell in
                cell.title = "Int"
                cell.textForValue = { value in
                    return String(value)
                }
                cell.valueForText = { value in
                    return Int(value)
                }
                cell.onChange = { _, newValue in
                    print("New value: \(newValue)")
                }
            }
        }
        
    }
}
