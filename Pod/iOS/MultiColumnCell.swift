//
//  MultiColumnCell.swift
//  Pods
//
//  Created by Sam Williams on 12/3/15.
//
//

import Foundation

open class StackCell: ContentCell {
    open var stackView:UIStackView? {
        get {
            return self.content as? UIStackView
        }
    }
    
    open var arrangedSubviews:[UIView]? {
        get {
            return self.stackView?.arrangedSubviews
        }
        set {
            if let v = self.stackView {
                for view in v.arrangedSubviews {
                    view.removeFromSuperview()
                }
            }
            if let v = newValue {
                for view in v {
                    self.stackView?.addArrangedSubview(view)
                }
            }
        }
    }
    
    override open func buildContent() -> UIView {
        let stack =  UIStackView()
        stack.axis = .vertical
        
        return stack
    }
}

open class MultiColumnCell: ContentCell {
    open var columns:ColumnStackView? {
        get {
            return self.content as? ColumnStackView
        }
    }
    
    override open func buildContent() -> UIView {
        return ColumnStackView()
    }
}
