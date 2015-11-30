//
//  DateFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

public class DateFieldCell: TextFieldCell {
    public var dateValue:NSDate?
    public var dateFormatter:NSDateFormatter = NSDateFormatter()
    public var datePicker:UIDatePicker?
    
    override func buildView() {
        super.buildView()
        
        self.dateFormatter.dateStyle = .MediumStyle
        
        self.datePicker = UIDatePicker()
        self.datePicker?.datePickerMode = .Date
        self.datePicker?.addTarget(self, action: Selector("datePickerValueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.textField?.inputView = self.datePicker
        self.textField?.tintColor = UIColor.clearColor()
    }
    
    func datePickerValueChanged() {
        self.dateValue = self.datePicker?.date
        self.update()
    }
    
    override public func commit() {
        super.commit()
        self.datePickerValueChanged()
    }
    
    override public func clear() {
        self.dateValue = nil
        super.clear()
    }
    
    override func displayValue() -> String? {
        if let date = self.dateValue {
            return self.dateFormatter.stringFromDate(date)
        } else {
            return nil
        }
    }
    
}
