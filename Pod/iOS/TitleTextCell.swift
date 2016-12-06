//
//  TitleTextCell.swift
//  Pods
//
//  Created by Sam Williams on 4/7/16.
//
//

import UIKit

open class TitleTextValueCell: TitleDetailsCell {
    open var valueLabel: UILabel?
    
    open var value: String? {
        get {
            return self.valueLabel?.text
        }
        set {
            self.valueLabel?.text = newValue
        }
    }
    
    open override func buildView() {
        super.buildView()
        let valueLabel = UILabel()
        valueLabel.numberOfLines = 0
        valueLabel.lineBreakMode = .byWordWrapping
        self.valueLabel = valueLabel
        self.addControl(valueLabel)
    }
    
    open override func stylize() {
        super.stylize()
        self.valueLabel?.font = self.valueFont
        self.valueLabel?.textColor = self.valueTextColor
        
        switch self.labelPosition {
        case .left:
            self.valueLabel?.textAlignment = .right
        case .top:
            self.valueLabel?.textAlignment = .left
        }
    }
}
