//
//  PushFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 12/11/15.
//
//

import UIKit

/**
 A cell that pushes another view controller for data entry.
*/
public class PushFieldCell<ValueType:Equatable>: FieldCell {
    public var value:ValueType? {
        didSet {
            self.update()
        }
    }
    
    public var valueLabel:UILabel?
    
    override public func buildView() {
        super.buildView()
        
        let valueLabel = UILabel(frame: CGRect.zero)
        self.addControl(valueLabel)
        self.valueLabel = valueLabel
    }
    
    override public func stylize() {
        super.stylize()
        
        self.valueLabel?.font = self.valueFont
        self.valueLabel?.textColor = self.valueTextColor
        self.accessoryType = .DisclosureIndicator
    }
    
    override func update() {
        super.update()
        if let value = self.value {
            self.valueLabel?.text = String(value)
        } else {
            self.valueLabel?.text = nil
        }
        self.userInteractionEnabled = !self.readonly
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}
