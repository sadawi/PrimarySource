//
//  IntegerCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit
import MagneticFields

public class IntegerCell: FieldCell, Observable {
    public var value:Int? {
        didSet {
            self.update()
            self.notifyObservers()
        }
    }

    // MARK: - Observable
    
    public typealias ValueType = Int
    public var observations = ObservationRegistry<Int>()

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.removeAllObservers()
    }
}

public class StepperCell: IntegerCell {
    public var stepper:UIStepper?
    public var valueLabel:UILabel?
    
    override public func buildView() {
        super.buildView()
        
        let label = UILabel(frame: self.controlView!.bounds)
        self.addControl(label)
        self.valueLabel = label

        let control = UIStepper(frame: self.controlView!.bounds)
        control.value = 1
        control.stepValue = 1
        self.addControl(control, alignment:.Right)
        control.addTarget(self, action: Selector("stepperValueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.stepper = control
    }
    
    func stepperValueChanged() {
        if let value = self.stepper?.value {
            self.value = Int(value)
        } else {
            self.value = nil
        }
        self.valueChanged()
    }
    
    override public func stylize() {
        super.stylize()
        self.valueLabel?.font = self.valueFont
        self.valueLabel?.textColor = self.valueTextColor
    }
    
    override func update() {
        super.update()
        
        if let value = self.value {
            self.valueLabel?.text = String(value)
        } else {
            self.valueLabel?.text = nil
        }
    }
}