//
//  SelectCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

public class SelectCell<ValueType:Equatable>: FieldCell {
    public var value:ValueType? {
        didSet {
            self.update()
        }
    }
    public var options:[ValueType] = [] {
        didSet {
            self.update()
        }
    }
    
    public var textForNil: String?
    
    public var textForValue:(ValueType -> String)?
    
    func formatValue(value: ValueType?) -> String {
        if let value = value {
            if let formatter = self.textForValue {
                return formatter(value)
            } else {
                return String(value)
            }
        } else {
            return self.textForNil ?? ""
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}

public class PushSelectCell<ValueType:Equatable>: SelectCell<ValueType>, TappableTableCell {
    // TODO: there's some duplicated code between here and PushFieldCell.  Maybe this should inherit from that instead of SelectCell?
    // Also duplication between this and TitleTextCell (both have valueLabels)
    
    public var includeNil:Bool = false
    
    public var valueLabel:UILabel?
    public var configureSelectViewController: (SelectViewController<ValueType> -> ())?
    
    override public func buildView() {
        super.buildView()
        let valueLabel = UILabel()
        valueLabel.textAlignment = .Right
        valueLabel.numberOfLines = 0
        valueLabel.lineBreakMode = .ByWordWrapping
        self.valueLabel = valueLabel
        self.addControl(valueLabel)
    }
    
    override public func stylize() {
        super.stylize()
        
        self.valueLabel?.font = self.valueFont
        self.valueLabel?.textColor = self.valueTextColor
        self.accessoryType = .DisclosureIndicator

        switch self.labelPosition {
        case .Left:
            self.valueLabel?.textAlignment = .Right
        case .Top:
            self.valueLabel?.textAlignment = .Left
        }
    }
    
    override func update() {
        super.update()
        self.valueLabel?.text = self.formatValue(self.value)
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
            controller.includeNil = self.includeNil
            controller.textForNil = self.textForNil
            self.configureSelectViewController?(controller)
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
            let title = self.formatValue(self.options[i])
            self.segmentedControl?.insertSegmentWithTitle(title, atIndex: i, animated: false)
        }
        if let value = self.value, index = self.options.indexOf(value) {
            self.segmentedControl?.selectedSegmentIndex = index
        }
    }
    
}
