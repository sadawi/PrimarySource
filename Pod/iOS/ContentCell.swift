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
public class ContentCell: TableCell {
    var content:UIView?
    
    public func buildContent() -> UIView {
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
