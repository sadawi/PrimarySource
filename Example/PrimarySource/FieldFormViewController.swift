//
//  FieldFormViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 2/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import PrimarySource
//import MagneticFields

class FieldFormViewController: DataSourceViewController {
//    let name            = Field<String>(value: "Bob")
//    let active          = Field<Bool>(value: true)
//    let count           = Field<Int>(value: 0)
//    let emailAddress    = Field<String>()
//    
//    override func configureDataSource(dataSource: DataSource) {
//        dataSource <<< Section(title: "Form") { section in
//            section <<< CollectionItem<TextFieldCell> { [unowned self] cell in
//                cell.title = "Name"
//                cell.placeholderText = "Enter a full name"
////                cell <--> self.name
//            }
//            
//            section <<< CollectionItem<SwitchCell> { [unowned self] cell in
//                cell.title = "Active"
//            }
//            section <<< CollectionItem<StepperCell> { [unowned self] cell in
//                cell.title = "Count"
//            }
//
//            section <<< CollectionItem<ButtonCell> { cell in
//                cell.title = "Increment Count"
//                }.onTap { [weak self] _ in
//                    self?.count.value = (self?.count.value ?? 0) + 1
//            }
//            
//            section <<< CollectionItem<ButtonCell> { cell in
//                cell.title = "Submit"
//            }.onTap { [weak self] _ in
//                self?.showValues()
//            }
//        }
//    }
//    
//    func showValues() {
//        var parts: [String] = []
//        let fields: [String: FieldType] = [
//            "name": self.name,
//            "active": self.active,
//            "count": self.count
//        ]
//        for (key, field) in fields {
//            if let value = field.anyObjectValue {
//                parts.append("\(key) = \(value)")
//            }
//        }
//        
//        let message = parts.joinWithSeparator("\n")
//        let alert = UIAlertController(title: "form", message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { _ -> () in
//            self.dismissViewControllerAnimated(true, completion: nil)
//            })
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
}