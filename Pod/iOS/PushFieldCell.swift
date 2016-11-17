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
open class PushFieldCell<ValueType:Equatable>: FieldCell {
    open var value:ValueType? {
        didSet {
            self.update()
        }
    }
    
    open var valueLabel:UILabel?
    
    override open func buildView() {
        super.buildView()
        
        let valueLabel = UILabel(frame: CGRect.zero)
        self.addControl(valueLabel)
        self.valueLabel = valueLabel
    }
    
    override open func stylize() {
        super.stylize()
        
        self.valueLabel?.font = self.valueFont
        self.valueLabel?.textColor = self.valueTextColor
        self.accessoryType = .disclosureIndicator
    }
    
    override func update() {
        super.update()
        if let value = self.value {
            self.valueLabel?.text = String(describing: value)
        } else {
            self.valueLabel?.text = nil
        }
        self.isUserInteractionEnabled = !self.readonly
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
    }
}
