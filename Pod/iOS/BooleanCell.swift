//
//  BooleanCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

public class BooleanCell:FieldCell {
    public var value:Bool? = false {
        didSet {
            self.update()
        }
    }

    // MARK: - Observable
    
    public typealias ValueType = Bool
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}

public class SwitchCell:BooleanCell, TappableTableCell  {
    var switchControl:UISwitch?
    
    override public func buildView() {
        super.buildView()
        let control = UISwitch(frame: self.controlView!.bounds)
        
        self.addControl(control, alignment:.Right)
        control.addTarget(self, action: Selector("switchChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.switchControl = control
    }
    
    public func switchChanged() {
        self.value = self.switchControl?.on
        self.valueChanged()
    }
    
    public func toggle(animated animated:Bool=true) {
        let newValue = (self.value != true)
        self.switchControl?.setOn(newValue, animated: animated)
        self.value = newValue
        self.valueChanged()
    }
    
    public override func update() {
        super.update()
        self.switchControl?.on = (self.value == true)
        self.switchControl?.userInteractionEnabled = !self.readonly
    }
    
    func handleTap() {
        self.toggle(animated: true)
    }
}