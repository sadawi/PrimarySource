//
//  MonthYearPickerCell.swift
//  Pods
//
//  Created by Sam Williams on 6/7/16.
//
//

import Foundation
import UIKit

open class MonthYearPickerCell: PickerCell<Date> {
    open var dateFormatter: DateFormatter = DateFormatter()
    
    open var monthYearPicker: MonthYearPicker? {
        return self.picker as? MonthYearPicker
    }
    
    open override func buildView() {
        super.buildView()
        self.dateFormatter.dateFormat = "MM/YYYY"
    }
    
    open override func setDefaults() {
        super.setDefaults()
        self.toolbarShowsClearButton = false
    }
    
    open var dateComponentsValue: DateComponents? {
        get {
            return self.monthYearPicker?.dateComponents as DateComponents?
        }
        set {
            self.monthYearPicker?.dateComponents = newValue
            self.update()
        }
    }
    
    open override var value: Date? {
        get {
            return self.monthYearPicker?.date as Date?
        }
        set {
            self.monthYearPicker?.date = newValue
            self.update()
        }
    }
    
    open override func buildPicker() -> UIPickerView? {
        let picker = MonthYearPicker(minimumDate: Date(), maximumDate: Date().addingTimeInterval(15*365*24*60*60))
        picker.onValueChange = { [weak self] components in
            self?.update()
        }
        return picker
    }
    
    open override var stringValue: String? {
        get {
            if let date = self.monthYearPicker?.date {
                return self.dateFormatter.string(from: date as Date)
            }
            return nil
        }
        set {
            // Input through picker
        }
    }
}
