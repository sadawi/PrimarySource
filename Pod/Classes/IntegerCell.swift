//
//  IntegerCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

public class IntegerCell: FieldCell {
    public var value:Int?
}

public class StepperCell: IntegerCell {
    public var stepper:UIStepper?
    
    override public func buildView() {
        super.buildView()
        let control = UIStepper(frame: self.controlView!.bounds)
        self.addControl(control, alignment:.Right)
        control.addTarget(self, action: Selector("valueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.stepper = control
    }
}