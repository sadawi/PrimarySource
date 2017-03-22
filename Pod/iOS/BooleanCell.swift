//
//  BooleanCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

open class BooleanCell:FieldCell<Bool> {
}

open class SwitchCell:BooleanCell, TappableTableCell  {
    var switchControl:UISwitch?
    
    override open func buildView() {
        super.buildView()
        let control = UISwitch(frame: self.controlView!.bounds)
        
        self.addControl(control, alignment:.right)
        control.addTarget(self, action: #selector(SwitchCell.switchChanged), for: UIControlEvents.valueChanged)
        self.switchControl = control
    }
    
    open func switchChanged() {
        self.value = self.switchControl?.isOn
        self.valueChanged()
    }
    
    open func toggle(animated:Bool=true) {
        let newValue = (self.value != true)
        self.switchControl?.setOn(newValue, animated: animated)
        self.value = newValue
        self.valueChanged()
    }
    
    open override func update() {
        super.update()
        self.switchControl?.isOn = (self.value == true)
        self.switchControl?.isUserInteractionEnabled = !self.readonly
    }
    
    public func handleTap() {
        self.toggle(animated: true)
    }
}
