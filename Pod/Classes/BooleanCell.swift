//
//  BooleanCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit
import MagneticFields

public class BooleanCell:FieldCell, Observable {
    public var value:Bool? = false {
        didSet {
            self.update()
            self.notifyObservers()
        }
    }

    // MARK: - Observable
    
    public typealias ValueType = Bool
    public var observations = ObservationRegistry<ValueType>()
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
    
    public func toggle(animated:Bool=true) {
        self.value = (self.value != true)
        self.valueChanged()
    }
    
    public override func update() {
        super.update()
        self.switchControl?.on = (self.value == true)
        self.switchControl?.userInteractionEnabled = !self.readonly
    }
    
    func handleTap() {
        self.toggle()
    }
}