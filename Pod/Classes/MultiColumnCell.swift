//
//  MultiColumnCell.swift
//  Pods
//
//  Created by Sam Williams on 12/3/15.
//
//

import Foundation

public class ContentCell: TableCell {
    var content:UIView?
    
    func buildContent() -> UIView {
        return UIView(frame: CGRect.zero)
    }

    public override func buildView() {
        super.buildView()
        
        let view = self.buildContent()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        let views = ["v": view]
        let metrics:[String:CGFloat] = [:]
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v]-|", options: [], metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[v]-|", options: [], metrics: metrics, views: views))
        
        self.content = view
    }
}

public class StackCell: ContentCell {
    public var stackView:UIStackView? {
        get {
            return self.content as? UIStackView
        }
    }
    
    public var arrangedSubviews:[UIView]? {
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
    
    override func buildContent() -> UIView {
        let stack =  UIStackView()
        stack.axis = .Vertical
        
        return stack
    }
}

public class MultiColumnCell: ContentCell {
    public var columns:ColumnStackView? {
        get {
            return self.content as? ColumnStackView
        }
    }
    
    override func buildContent() -> UIView {
        return ColumnStackView()
    }
}