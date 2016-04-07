//
//  BooleanCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit
import MagneticFields

public class BooleanCell:FieldCell, Observable, Observer {
    public var value:Bool? = false {
        didSet {
            self.update()
            self.notifyObservers()
        }
    }

    // MARK: - Observable
    
    public typealias ValueType = Bool
    public var observations = ObservationRegistry<ValueType>()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.removeAllObservers()
    }
    
    // MARK: - Observer
    
    public func valueChanged<ObservableType:Observable>(value:ValueType?, observable:ObservableType?) {
        self.value = value
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