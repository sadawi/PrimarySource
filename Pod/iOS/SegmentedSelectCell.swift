//
//  SegmentedSelectCell.swift
//  Pods
//
//  Created by Sam Williams on 3/14/17.
//
//

import UIKit

open class SegmentedSelectCell<Value:Equatable>: ValueFieldCell<Value> {
    open var segmentedControl:UISegmentedControl?
    
    override open func buildView() {
        let view = UISegmentedControl()
        
        view.addTarget(self, action: #selector(SegmentedSelectCell.segmentedControlChanged), for: UIControlEvents.valueChanged)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        let views = ["v": view]
        let metrics:[String:CGFloat] = [:]
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-|", options: [], metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: [], metrics: metrics, views: views))
        
        self.segmentedControl = view
    }
    
    func segmentedControlChanged() {
        if let index = self.segmentedControl?.selectedSegmentIndex {
            if index < self.options.count {
                self.value = self.options[index]
                self.valueChanged()
            }
        }
    }
    
    override func update() {
        super.update()
        self.segmentedControl?.removeAllSegments()
        for i in 0..<self.options.count {
            let title = self.formatValue(self.options[i])
            self.segmentedControl?.insertSegment(withTitle: title, at: i, animated: false)
        }
        if let value = self.value, let index = self.options.index(of: value) {
            self.segmentedControl?.selectedSegmentIndex = index
        }
    }
    
}
