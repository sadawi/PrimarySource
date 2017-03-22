//
//  ValueFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 3/14/17.
//
//

import UIKit

/**
 Any cell that presents its value as a string that is not directly editable.
 */
open class ValueFieldCell<Value:Equatable>: FieldCell<Value> {
    
    open var options:[Value] = [] {
        didSet {
            self.update()
        }
    }
    
    open var textForNil: String?
    
    open var textForValue:((Value) -> String)?
    
    func formatValue(_ value: Value?) -> String {
        if let value = value {
            if let formatter = self.textForValue {
                return formatter(value)
            } else {
                return String(describing: value)
            }
        } else {
            return self.textForNil ?? ""
        }
    }
}
