//
//  DateComponentsPicker.swift
//  Pods
//
//  Created by Sam Williams on 6/7/16.
//
//

import Foundation
import UIKit

public class MonthYearPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var minimumDate: NSDate? = NSDate() {
        didSet {
            self.updateData()
        }
    }
    var maximumDate: NSDate? {
        didSet {
            self.updateData()
        }
    }
    var dateComponents: NSDateComponents? = MonthYearPicker.componentsForDate(NSDate()) {
        didSet {
            self.updateData()
        }
    }
    
    private var months: [String] = NSDateFormatter().monthSymbols
    private var minYear: Int = 0
    private var maxYear: Int = 0
    
    private static func componentsForDate(date: NSDate) -> NSDateComponents {
        return NSCalendar.currentCalendar().components([.Month, .Year], fromDate: date)
    }
    
    private func updateData() {
        if let min = self.minimumDate, let max = self.maximumDate {
            let minComponents = MonthYearPicker.componentsForDate(min)
            let maxComponents = MonthYearPicker.componentsForDate(max)
            let minYear = minComponents.year
            let maxYear = maxComponents.year
            if minYear <= maxYear {
                self.minYear = minYear
                self.maxYear = maxYear
            }
        }
        self.reloadAllComponents()
        if let components = self.dateComponents {
            self.selectRow(components.month-1, inComponent: self.monthComponentIndex, animated: false)
            
            let year = components.year
            if year >= self.minYear && year <= self.maxYear {
                let yearRow = year - self.minYear
                self.selectRow(yearRow, inComponent: self.yearComponentIndex, animated: false)
            }
        }
    }
    
    var onValueChange: ((NSDateComponents?)->Void)?
    
    // In theory, this could change based on locale.
    var monthComponentIndex: Int {
        return 0
    }
    
    var yearComponentIndex: Int {
        return 1
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    convenience init(minimumDate: NSDate, maximumDate: NSDate) {
        self.init(frame: CGRect.zero)
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.updateData()
    }
    
    func initialize() {
        self.updateData()
        self.delegate = self
        self.dataSource = self
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case self.monthComponentIndex:
            return self.months.count
        case self.yearComponentIndex:
            return self.maxYear - self.minYear
        default:
            return 0
        }
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case self.monthComponentIndex:
            return self.months[row]
        case self.yearComponentIndex:
            return String(self.minYear + row)
        default:
            return nil
        }
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case self.monthComponentIndex:
            self.dateComponents?.month = row + 1
        case self.yearComponentIndex:
            self.dateComponents?.year = self.minYear + row
        default:
            break
        }
        
        self.onValueChange?(self.dateComponents)
    }
}