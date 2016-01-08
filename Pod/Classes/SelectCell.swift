//
//  SelectCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit
import MagneticFields

public class SelectCell<ValueType:Equatable>: FieldCell, Observable {
    public var value:ValueType? {
        didSet {
            self.update()
            self.notifyObservers()
        }
    }
    public var options:[ValueType] = [] {
        didSet {
            self.update()
        }
    }
    
    // If this is a regular (non-lazy) property, I get EXC_BAD_ACCESS whenever I try to access self.observations (e.g., in notifyObservers).
    // I'm not sure why.
    lazy public var observations = ObservationRegistry<ValueType>()
}

public class PushSelectCell<ValueType:Equatable>: SelectCell<ValueType>, TappableTableCell {
    // TODO: there's some duplicated code between here and PushFieldCell.  Maybe this should inherit from that instead of SelectCell?
    
    public var valueLabel:UILabel?
    
    override public func buildView() {
        super.buildView()
        
        let valueLabel = UILabel(frame: CGRect.zero)
        self.addControl(valueLabel)
        self.valueLabel = valueLabel
    }
    
    override public func stylize() {
        super.stylize()
        
        self.valueLabel?.font = self.contentFont
        self.valueLabel?.textColor = self.valueTextColor
        self.accessoryType = .DisclosureIndicator
    }
    
    override func update() {
        super.update()
        if let value = self.value {
            self.valueLabel?.text = String(value)
        } else {
            self.valueLabel?.text = nil
        }
        self.userInteractionEnabled = !self.readonly
    }
    
    func handleTap() {
        if let presenter = self.dataSource?.presentationViewController() {
            let controller = SelectViewController(options: self.options, value:self.value) { [unowned self] value in
                self.value = value
                self.valueChanged()
                presenter.navigationController?.popViewControllerAnimated(true)
            }
            controller.title = self.title
            controller.options = self.options
            presenter.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

public class SegmentedSelectCell<ValueType:Equatable>: SelectCell<ValueType> {
    public var segmentedControl:UISegmentedControl?
    
    override public func buildView() {
        let view = UISegmentedControl()
        
        view.addTarget(self, action: Selector("segmentedControlChanged"), forControlEvents: UIControlEvents.ValueChanged)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        let views = ["v": view]
        let metrics:[String:CGFloat] = [:]
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v]-|", options: [], metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[v]-|", options: [], metrics: metrics, views: views))

        self.segmentedControl = view
    }
    
    override public func stylize() {
        super.stylize()
        // TODO
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
            let title = String(self.options[i])
            self.segmentedControl?.insertSegmentWithTitle(title, atIndex: i, animated: false)
        }
        if let value = self.value, index = self.options.indexOf(value) {
            self.segmentedControl?.selectedSegmentIndex = index
        }
    }
    
}
