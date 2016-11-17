//
//  SelectCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

open class SelectCell<ValueType:Equatable>: FieldCell {
    open var value:ValueType? {
        didSet {
            self.update()
        }
    }
    open var options:[ValueType] = [] {
        didSet {
            self.update()
        }
    }
    
    open var textForNil: String?
    
    open var textForValue:((ValueType) -> String)?
    
    func formatValue(_ value: ValueType?) -> String {
        if let value = value {
            if let formatter = self.textForValue {
                return formatter(value)
            } else {
                return String(describing: value)
            }
        } else {
            return self.textForNil ?? ""
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
}

open class PushSelectCell<ValueType:Equatable>: SelectCell<ValueType>, TappableTableCell {
    // TODO: there's some duplicated code between here and PushFieldCell.  Maybe this should inherit from that instead of SelectCell?
    // Also duplication between this and TitleTextCell (both have valueLabels)
    
    open var includeNil:Bool = false
    
    open var valueLabel:UILabel?
    open var configureSelectViewController: ((SelectViewController<ValueType>) -> ())?
    
    override open func buildView() {
        super.buildView()
        let valueLabel = UILabel()
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 0
        valueLabel.lineBreakMode = .byWordWrapping
        self.valueLabel = valueLabel
        self.addControl(valueLabel)
    }
    
    override open func stylize() {
        super.stylize()
        
        self.valueLabel?.font = self.valueFont
        self.valueLabel?.textColor = self.valueTextColor
        self.accessoryType = .disclosureIndicator

        switch self.labelPosition {
        case .left:
            self.valueLabel?.textAlignment = .right
        case .top:
            self.valueLabel?.textAlignment = .left
        }
    }
    
    override func update() {
        super.update()
        self.valueLabel?.text = self.formatValue(self.value)
        self.isUserInteractionEnabled = !self.readonly
    }
    
    func handleTap() {
        if let presenter = self.dataSource?.presentationViewController() {
            let controller = SelectViewController(options: self.options, value:self.value) { [unowned self] value in
                self.value = value
                self.valueChanged()
                presenter.navigationController?.popViewController(animated: true)
            }
            controller.title = self.title
            controller.options = self.options
            controller.includeNil = self.includeNil
            controller.textForNil = self.textForNil
            if let textForValue = self.textForValue {
                controller.textForValue = textForValue
            }
            self.configureSelectViewController?(controller)
            presenter.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

open class SegmentedSelectCell<ValueType:Equatable>: SelectCell<ValueType> {
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
    
    override open func stylize() {
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
            self.segmentedControl?.insertSegment(withTitle: title, at: i, animated: false)
        }
        if let value = self.value, let index = self.options.index(of: value) {
            self.segmentedControl?.selectedSegmentIndex = index
        }
    }
    
}
