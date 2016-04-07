//
//  TitleTextCell.swift
//  Pods
//
//  Created by Sam Williams on 4/7/16.
//
//

import UIKit

public class TitleTextCell: TitleDetailsCell {
    public var valueLabel: UILabel?
    
    public var value: String? {
        get {
            return self.valueLabel?.text
        }
        set {
            self.valueLabel?.text = newValue
        }
    }
    
    public override func buildView() {
        super.buildView()
        let valueLabel = UILabel()
        valueLabel.numberOfLines = 0
        valueLabel.lineBreakMode = .ByWordWrapping
        self.valueLabel = valueLabel
        self.addControl(valueLabel)
    }
    
    public override func stylize() {
        super.stylize()
        self.valueLabel?.font = self.valueFont
        self.valueLabel?.textColor = self.valueTextColor
        
        switch self.labelPosition {
        case .Left:
            self.valueLabel?.textAlignment = .Right
        case .Top:
            self.valueLabel?.textAlignment = .Left
        }
    }
}