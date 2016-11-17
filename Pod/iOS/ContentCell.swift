//
//  ContentCell.swift
//  Pods
//
//  Created by Sam Williams on 12/3/15.
//
//

import Foundation


/**
 A TableCell with a single view that fills its content and determines its size.
 */
open class ContentCell: TableCell {
    var content:UIView?
    
    open func buildContent() -> UIView {
        return UIView(frame: CGRect.zero)
    }
    
    open override func buildView() {
        super.buildView()
        
        let view = self.buildContent()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        let views = ["v": view]
        let metrics:[String:CGFloat] = [:]
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-|", options: [], metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: [], metrics: metrics, views: views))
        
        self.content = view
    }
}
