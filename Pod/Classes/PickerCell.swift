//
//  PickerCell.swift
//  Pods
//
//  Created by Sam Williams on 6/7/16.
//
//

import Foundation
import UIKit

public class PickerCell: TextFieldInputCell {
    var picker: UIPickerView?
    
    public func buildPicker() -> UIPickerView? {
        // Override in subclas
        return nil
    }
    
    public override func buildView() {
        super.buildView()
        self.picker = self.buildPicker()
        self.textField?.inputView = self.picker
    }
    
    public override func setDefaults() {
        super.setDefaults()
        self.toolbarShowsClearButton = true
    }
    
    func pickerValueChanged() {
        // Subclass
    }
    
    public override func commit() {
        self.pickerValueChanged()
        self.valueChanged()
        super.commit()
    }
}