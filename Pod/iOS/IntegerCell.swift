//
//  IntegerCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

open class IntegerCell: FieldCell<Int> {
}

open class IntegerInputCell: TextFieldInputCell<Int> {
    open override var keyboardType: UIKeyboardType {
        get { return .numberPad }
        set { }
    }
    
    open override func importText(_ text: String?) -> Int? {
        if let text = text {
            return Int(text)
        } else {
            return nil
        }
    }
    
    open override func exportText(_ value: Int?) -> String? {
        if let value = value {
            return String(value)
        } else {
            return nil
        }
    }
}

open class StepperCell: IntegerCell {
    open var stepper:UIStepper?
    open var valueLabel:UILabel?
    
    override open func buildView() {
        super.buildView()
        
        let label = UILabel(frame: self.controlView!.bounds)
        self.addControl(label)
        self.valueLabel = label

        let control = UIStepper(frame: self.controlView!.bounds)
        control.stepValue = 1
        self.addControl(control, alignment:.right)
        control.addTarget(self, action: #selector(StepperCell.stepperValueChanged), for: UIControlEvents.valueChanged)
        self.stepper = control
    }
    
    func stepperValueChanged() {
        if let value = self.stepper?.value {
            self.value = Int(value)
        } else {
            self.value = nil
        }
    }
    
    override open func stylize() {
        super.stylize()
        self.valueLabel?.font = self.valueFont
        self.valueLabel?.textColor = self.valueTextColor
    }
    
    override open func update() {
        super.update()
        
        if let value = self.value {
            self.valueLabel?.text = String(value)
            self.stepper?.value = Double(value)
        } else {
            self.valueLabel?.text = nil
        }
    }
}
