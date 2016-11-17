//
//  SpacerCell.swift
//  Pods
//
//  Created by Sam Williams on 12/9/15.
//
//

import Foundation

open class SpacerCell: TableCell {
    open var height:CGFloat = 0 {
        didSet {
            self.heightConstraint.constant = self.height
        }
    }
    
    fileprivate var heightConstraint:NSLayoutConstraint!
    
    open override func buildView() {
        let view = self.contentView
        let constraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.contentView.addConstraint(constraint)
        self.heightConstraint = constraint
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    open override func stylize() {
        super.stylize()
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
}
