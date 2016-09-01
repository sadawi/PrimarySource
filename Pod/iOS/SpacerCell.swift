//
//  SpacerCell.swift
//  Pods
//
//  Created by Sam Williams on 12/9/15.
//
//

import Foundation

public class SpacerCell: TableCell {
    public var height:CGFloat = 0 {
        didSet {
            self.heightConstraint.constant = self.height
        }
    }
    
    private var heightConstraint:NSLayoutConstraint!
    
    public override func buildView() {
        let view = self.contentView
        let constraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
        self.contentView.addConstraint(constraint)
        self.heightConstraint = constraint
        self.layoutMargins = UIEdgeInsetsZero
    }
    
    public override func stylize() {
        super.stylize()
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
    }
}