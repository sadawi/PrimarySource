//
//  PickerCell.swift
//  Pods
//
//  Created by Sam Williams on 6/7/16.
//
//

import Foundation
import UIKit

open class PickerCell: TextFieldInputCell {
    var picker: UIPickerView?
    
    open func buildPicker() -> UIPickerView? {
        // Override in subclas
        return nil
    }
    
    open override func buildView() {
        super.buildView()
        self.picker = self.buildPicker()
        self.textField?.inputView = self.picker
        self.textField?.tintColor = UIColor.clear
    }
    
    func pickerValueChanged() {
        // Subclass
    }
    
    open override func commit() {
        self.pickerValueChanged()
        self.valueChanged()
        super.commit()
    }
}
