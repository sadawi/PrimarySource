//
//  TableCellBackgroundView.swift
//  Pods
//
//  Created by Sam Williams on 8/13/16.
//
//

import UIKit

open class TableCellBackgroundView: UIView {
    open var cornerRadius: CGFloat = 0
    open var listPosition: ListPosition?
    open var bottomPadding: CGFloat = 1
    open var color: UIColor = UIColor.clear
    open var highlightedColor: UIColor = UIColor.clear
    
    open var highlighted: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {
        self.backgroundColor = .clear
    }
    
    open override func draw(_ rect: CGRect) {
        if self.highlighted {
            self.highlightedColor.setFill()
        } else {
            self.color.setFill()
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        var rect = self.bounds
        rect.size.height -= self.bottomPadding
        
        var corners: UIRectCorner = []
        if let listPosition = self.listPosition {
            if listPosition.contains(ListPosition.Beginning) {
                corners = corners.union(UIRectCorner.topLeft)
                corners = corners.union(UIRectCorner.topRight)
            }
            if listPosition.contains(ListPosition.End) {
                corners = corners.union(UIRectCorner.bottomLeft)
                corners = corners.union(UIRectCorner.bottomRight)
            }
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
            context?.addPath(path.cgPath)
            context?.fillPath()
        }
    }
}
