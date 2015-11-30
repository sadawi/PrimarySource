//
//  SelectCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

public enum SelectMode {
    case Push
    case Alert
    case Picker
}

public class SelectCell<ValueType:Equatable>: FieldCell, TappableTableCell {
    public var value:ValueType? {
        didSet {
            self.update()
        }
    }
    public var options:[ValueType] = []
    public var selectMode:SelectMode = .Push
    
    public var valueLabel:UILabel?
    
    override func buildView() {
        super.buildView()
        
        let valueLabel = UILabel(frame: CGRect.zero)
        self.addControl(valueLabel)
        self.valueLabel = valueLabel
    }
    
    override func stylize() {
        super.stylize()
        
        self.valueLabel?.font = self.contentFont
        self.valueLabel?.textColor = self.valueTextColor
        
        switch self.selectMode {
        case .Push:
            self.accessoryType = .DisclosureIndicator
        default:
            self.accessoryType = .None
        }
    }
    
    override func update() {
        super.update()
        if let value = self.value {
            self.valueLabel?.text = String(value)
        } else {
            self.valueLabel?.text = nil
        }
        
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
