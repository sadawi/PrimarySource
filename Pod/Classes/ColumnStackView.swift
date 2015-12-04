//
//  ColumnStackView.swift
//  Pods
//
//  Created by Sam Williams on 12/3/15.
//
//

import Foundation

public class ColumnStackView: UIView {
    public var columnSpacing:CGFloat = 5.0 {
        didSet {
            self.columnStack?.spacing = self.columnSpacing
        }
    }

    public var columnCount:Int = 2 {
        didSet {
            self.rebuildColumns()
            self.rebalance()
        }
    }
    
    private var columnStack:UIStackView?
    public var items:[UIView] = [] {
        willSet {
            self.removeAllArrangedSubviews()
        }
        didSet {
            self.rebalance()
        }
    }
    private var needsRebalancing = true
    
    public convenience init(columnCount:Int) {
        self.init(frame:CGRectZero)
        self.columnCount = columnCount
        self.rebuildColumns()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.rebuildColumns()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.rebuildColumns()
    }
    
    private func rebalance() {
        self.removeAllArrangedSubviews()
        
        if self.columnStack != nil {
            
            let rowCount = Int(ceil(Float(self.items.count)/Float(self.columnCount)))
            for var i=0; i<rowCount*self.columnCount; i++ {
                var item:UIView
                if i < self.items.count {
                    item = self.items[i]
                } else {
                    // Add placeholders!
                    item = UIView(frame: CGRect.null)
                    item.backgroundColor = UIColor.clearColor()
                }
                let columnIndex = i / rowCount
                let column = self.columnStack?.arrangedSubviews[columnIndex] as! UIStackView
                column.addArrangedSubview(item)
            }
            
            self.needsRebalancing = false
        }
    }
    
    // MARK: - private
    
    private func rebuildColumns() {
        self.columnStack?.removeFromSuperview()
        
        let columnStack = UIStackView(frame: self.bounds)
        columnStack.axis = .Horizontal
        columnStack.distribution = UIStackViewDistribution.FillProportionally
        columnStack.translatesAutoresizingMaskIntoConstraints = false
        
        for var i=0; i<self.columnCount; i++ {
            let column = UIStackView(frame: CGRect.null)
            column.axis = .Vertical
            column.translatesAutoresizingMaskIntoConstraints = false
//            column.spacing = 1
            columnStack.addArrangedSubview(column)
        }
        
        self.addSubview(columnStack)
        self.columnStack = columnStack
        
        let views = ["columnStack": columnStack]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[columnStack]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[columnStack]|", options: [], metrics: nil, views: views))
    }
    
    private func removeAllArrangedSubviews() {
        for view in self.items {
            view.removeFromSuperview()
        }
    }
    
}