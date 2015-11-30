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
    public var value:Bool = false
}

public class SwitchCell:BooleanCell, TappableTableCell  {
    var switchControl:UISwitch?
    
    // TODO: probably want to leave the var alone, and add some overridable methods
    public override var value:Bool {
        get {
            return self.switchControl?.on ?? false
        }
        set {
            self.switchControl?.on = newValue
        }
    }
    
    override func buildView() {
        super.buildView()
        let control = UISwitch(frame: self.controlView!.bounds)
        
        //        control.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        
        self.addControl(control, alignment:.Right)
        control.addTarget(self, action: Selector("valueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.switchControl = control
    }
    
    public func toggle(animated:Bool=true) {
        self.switchControl?.setOn(!self.value, animated: animated)
        self.valueChanged()
    }
    
    func handleTap() {
        self.toggle()
    }
}