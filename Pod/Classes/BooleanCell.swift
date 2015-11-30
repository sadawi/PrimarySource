//
//  BooleanCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

public class BooleanCell:FieldCell {
    // TODO: to be consistent, probably should be (Bool?)
    public var value:Bool? = false
}

public class SwitchCell:BooleanCell, TappableTableCell  {
    var switchControl:UISwitch?
    
    override func buildView() {
        super.buildView()
        let control = UISwitch(frame: self.controlView!.bounds)
        
        self.addControl(control, alignment:.Right)
        control.addTarget(self, action: Selector("valueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.switchControl = control
    }
    
    public func toggle(animated:Bool=true) {
        self.value = (self.value != true)
        self.valueChanged()
    }
    
    public override func update() {
        super.update()
        self.switchControl?.on = (self.value == true)
    }
    
    func handleTap() {
        self.toggle()
    }
}