//
//  MonthYearPickerCell.swift
//  Pods
//
//  Created by Sam Williams on 6/7/16.
//
//

import Foundation
import UIKit

public class MonthYearPickerCell: PickerCell {
    public var dateFormatter: NSDateFormatter = NSDateFormatter()
    
    public var monthYearPicker: MonthYearPicker? {
        return self.picker as? MonthYearPicker
    }
    
    public override func buildView() {
        super.buildView()
        self.dateFormatter.dateFormat = "MM/YYYY"
    }
    
    public override func setDefaults() {
        super.setDefaults()
        self.toolbarShowsClearButton = false
    }
    
    public var value: NSDateComponents? {
        get {
            return self.monthYearPicker?.dateComponents
        }
        set {
            if let value = newValue {
                self.monthYearPicker?.dateComponents = value
            }
        }
    }
    
    public override func buildPicker() -> UIPickerView? {
        let picker = MonthYearPicker(minimumDate: NSDate(), maximumDate: NSDate().dateByAddingTimeInterval(15*365*24*60*60))
        picker.onValueChange = { [weak self] components in
            self?.update()
        }
        return picker
    }
    
    public override var stringValue: String? {
        get {
            if let date = self.monthYearPicker?.date {
                return self.dateFormatter.stringFromDate(date)
            }
            return nil
        }
        set {
            // Input through picker
        }
    }
}