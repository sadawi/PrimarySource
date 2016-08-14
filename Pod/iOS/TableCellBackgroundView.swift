//
//  TableCellBackgroundView.swift
//  Pods
//
//  Created by Sam Williams on 8/13/16.
//
//

import UIKit

public class TableCellBackgroundView: UIView {
    public var cornerRadius: CGFloat = 0
    public var listPosition: ListPosition?
    public var bottomPadding: CGFloat = 1
    public var color: UIColor = UIColor.clearColor()
    public var highlightedColor: UIColor = UIColor.clearColor()
    
    public var highlighted: Bool = false {
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
        self.backgroundColor = .clearColor()
    }
    
    public override func drawRect(rect: CGRect) {
        if self.highlighted {
            self.highlightedColor.setFill()
        } else {
            self.color.setFill()
        }
        
        let context = UIGraphicsGetCurrentContext()
        
        var rect = self.bounds
        rect.size.height -= self.bottomPadding
        
        var corners: UIRectCorner = []
        if let listPosition = self.listPosition {
            if listPosition.contains(ListPosition.Beginning) {
                corners = corners.union(UIRectCorner.TopLeft)
                corners = corners.union(UIRectCorner.TopRight)
            }
            if listPosition.contains(ListPosition.End) {
                corners = corners.union(UIRectCorner.BottomLeft)
                corners = corners.union(UIRectCorner.BottomRight)
            }
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
            CGContextAddPath(context, path.CGPath)
            CGContextFillPath(context)
        }
    }
}