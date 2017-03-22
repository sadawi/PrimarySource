//
//  DateFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

open class DateFieldCell: TextFieldInputCell<Date> {
    open override var stringValue:String? {
        get {
            if let date = self.value {
                return self.dateFormatter.string(from: date)
            } else {
                return nil
            }
        }
        set {
            // Input is through the datePicker.
            // TODO: Might want to put date string parsing here, for completeness.
        }
    }
    
    open var dateFormatter:DateFormatter = DateFormatter()
    open var datePicker:UIDatePicker?
    
    override open func buildView() {
        super.buildView()
        
        self.dateFormatter.dateStyle = .medium
        
        self.datePicker = UIDatePicker()
        self.datePicker?.datePickerMode = .date
        self.datePicker?.addTarget(self, action: #selector(DateFieldCell.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        self.textField?.inputView = self.datePicker
        self.textField?.tintColor = UIColor.clear
    }
    
    func datePickerValueChanged() {
        self.value = self.datePicker?.date
        self.valueChanged()
    }
    
    override open func setDefaults() {
        super.setDefaults()
        self.toolbarShowsClearButton = true
    }
    
    override open func commit() {
        self.datePickerValueChanged()
        self.valueChanged()
        super.commit()
    }
    
    override open func clear() {
        self.value = nil
        super.clear()
    }
    
    override open func update() {
        super.update()
        if let date = self.value {
            self.datePicker?.date = date
        } else {
            self.datePicker?.date = Date()
        }
    }
    
}
