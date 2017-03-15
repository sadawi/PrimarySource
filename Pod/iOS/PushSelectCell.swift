//
//  SelectCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit


open class PushSelectCell<ValueType:Equatable>: ValueFieldCell<ValueType>, NavigationCell {
    
    // MARK: - NavigationCell
    
    public lazy var buildNextViewController: NavigationCell.ViewControllerGenerator? = {
        return { [weak self] presenter in self?.buildController() }
    }()

    public var presentationViewController: UIViewController? {
        return self.dataSource?.presentationViewController()
    }

    
    // MARK: -
    
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
    
    public func buildController() -> UIViewController? {
        let controller = SelectViewController(options: self.options, value:self.value) { [unowned self] value in
            self.value = value
            self.valueChanged()
            _ = self.presentationViewController?.navigationController?.popViewController(animated: true)
        }
        controller.title = self.title
        controller.options = self.options
        controller.includeNil = self.includeNil
        controller.textForNil = self.textForNil
        if let textForValue = self.textForValue {
            controller.textForValue = textForValue
        }
        self.configureSelectViewController?(controller)
        return controller
    }
}
