//
//  ColumnStackView.swift
//  Pods
//
//  Created by Sam Williams on 12/3/15.
//
//

import Foundation

open class ColumnStackView: UIView {
    open var columnSpacing:CGFloat = 5.0 {
        didSet {
            self.columnStack?.spacing = self.columnSpacing
        }
    }

    open var columnCount:Int = 2 {
        didSet {
            self.rebuildColumns()
            self.rebalance()
        }
    }
    
    fileprivate var columnStack:UIStackView?
    open var items:[UIView] = [] {
        willSet {
            self.removeAllArrangedSubviews()
        }
        didSet {
            self.rebalance()
        }
    }
    fileprivate var needsRebalancing = true
    
    public convenience init(columnCount:Int) {
        self.init(frame:CGRect.zero)
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
    
    fileprivate func rebalance() {
        self.removeAllArrangedSubviews()
        
        if self.columnStack != nil {
            
            let rowCount = Int(ceil(Float(self.items.count)/Float(self.columnCount)))
            for i in 0 ..< rowCount*self.columnCount {
                var item:UIView
                if i < self.items.count {
                    item = self.items[i]
                } else {
                    // Add placeholders!
                    item = UIView(frame: CGRect.null)
                    item.backgroundColor = UIColor.clear
                }
                let columnIndex = i / rowCount
                let column = self.columnStack?.arrangedSubviews[columnIndex] as! UIStackView
                column.addArrangedSubview(item)
            }
            
            self.needsRebalancing = false
        }
    }
    
    // MARK: - private
    
    fileprivate func rebuildColumns() {
        self.columnStack?.removeFromSuperview()
        
        let columnStack = UIStackView(frame: self.bounds)
        columnStack.spacing = 5.0
        columnStack.axis = .horizontal
        columnStack.distribution = UIStackViewDistribution.fillProportionally
        columnStack.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0 ..< self.columnCount {
            let column = UIStackView(frame: CGRect.null)
            column.axis = .vertical
            column.distribution = .fillEqually
            column.translatesAutoresizingMaskIntoConstraints = false
            columnStack.addArrangedSubview(column)
        }
        
        self.addSubview(columnStack)
        self.columnStack = columnStack
        
        let views = ["columnStack": columnStack]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[columnStack]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[columnStack]|", options: [], metrics: nil, views: views))
    }
    
    fileprivate func removeAllArrangedSubviews() {
        guard let columnStack = self.columnStack else { return }
        
        for column in columnStack.arrangedSubviews {
            for view in column.subviews {
                view.removeFromSuperview()
            }
        }
    }
    
}
