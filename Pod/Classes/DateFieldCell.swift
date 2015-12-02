//
//  DateFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

public class DateFieldCell: TextFieldInputCell {
    public override var stringValue:String? {
        get {
            if let date = self.value {
                return self.dateFormatter.stringFromDate(date)
            } else {
                return nil
            }
        }
        set {
            // Input is through the datePicker.
            // TODO: Might want to put date string parsing here, for completeness.
        }
    }
    
    public var value:NSDate? {
        didSet {
            self.update()
        }
    }
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
        self.value = self.datePicker?.date
//        self.valueChanged()
    }
    
    override public func commit() {
        self.datePickerValueChanged()
        self.valueChanged()
        super.commit()
    }
    
    override public func clear() {
        self.value = nil
        super.clear()
    }
    
    override public func update() {
        super.update()
        if let date = self.value {
            self.datePicker?.date = date
        } else {
            self.datePicker?.date = NSDate()
        }
    }
    
}
