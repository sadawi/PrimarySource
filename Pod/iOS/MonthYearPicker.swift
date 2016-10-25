//
//  DateComponentsPicker.swift
//  Pods
//
//  Created by Sam Williams on 6/7/16.
//
//

import Foundation
import UIKit

open class MonthYearPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    open var minimumDate: Date? = Date() {
        didSet {
            self.updateData()
        }
    }
    open var maximumDate: Date? {
        didSet {
            self.updateData()
        }
    }
    open var dateComponents: DateComponents? {
        didSet {
            self.updateData()
        }
    }
    
    open var date: Date? {
        get {
            if let components = self.dateComponents {
                var components = components
                components.day = 1
                return Calendar.current.date(from: components)
            }
            return nil
        }
        set {
            if let date = newValue {
                let components = (Calendar.current as NSCalendar).components([.month, .year], from: date)
                self.dateComponents = components
            } else {
                self.dateComponents = nil
            }
        }
    }
    
    fileprivate var months: [String] = DateFormatter().monthSymbols
    fileprivate var minYear: Int = 0
    fileprivate var maxYear: Int = 0
    
    fileprivate static func componentsForDate(_ date: Date) -> DateComponents {
        return (Calendar.current as NSCalendar).components([.month, .year], from: date)
    }
    
    fileprivate func updateData() {
        if let min = self.minimumDate, let max = self.maximumDate {
            let minComponents = MonthYearPicker.componentsForDate(min)
            let maxComponents = MonthYearPicker.componentsForDate(max)
            let minYear = minComponents.year
            let maxYear = maxComponents.year
            if minYear! <= maxYear! {
                self.minYear = minYear!
                self.maxYear = maxYear!
            }
        }
        self.reloadAllComponents()
        if let components = self.dateComponents {
            self.selectRow(components.month!-1, inComponent: self.monthComponentIndex, animated: false)
            
            let year = components.year
            if year! >= self.minYear && year! <= self.maxYear {
                let yearRow = year! - self.minYear
                self.selectRow(yearRow, inComponent: self.yearComponentIndex, animated: false)
            }
        }
    }
    
    open var onValueChange: ((DateComponents?)->Void)?
    
    // In theory, this could change based on locale.
    var monthComponentIndex: Int {
        return 0
    }
    
    var yearComponentIndex: Int {
        return 1
    }
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
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
    
    convenience init(minimumDate: Date, maximumDate: Date) {
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
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case self.monthComponentIndex:
            return self.months.count
        case self.yearComponentIndex:
            return self.maxYear - self.minYear
        default:
            return 0
        }
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case self.monthComponentIndex:
            return self.months[row]
        case self.yearComponentIndex:
            return String(self.minYear + row)
        default:
            return nil
        }
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.dateComponents == nil {
            self.date = Date()
        }
        
        switch component {
        case self.monthComponentIndex:
            self.dateComponents?.month = row + 1
        case self.yearComponentIndex:
            self.dateComponents?.year = self.minYear + row
        default:
            break
        }
        
        self.updateData()
        
        self.onValueChange?(self.dateComponents)
    }
}
