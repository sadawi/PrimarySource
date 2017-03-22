//
//  PushFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 3/15/17.
//
//
import UIKit

open class PushFieldCell<Value: Equatable>: ValueFieldCell<Value>, NavigationCell {
    open var nextViewControllerGenerator: NavigationCell.ViewControllerGenerator?
    
    // MARK: - NavigationCell
    
    public var presentationViewController: UIViewController? {
        return self.dataSource?.presentationViewController()
    }
    
    open func buildNextViewController() -> UIViewController? {
        return self.nextViewControllerGenerator?()
    }
    
    // MARK: - View
    
    open var valueLabel:UILabel?
    
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
        
        self.accessoryType = .disclosureIndicator
        
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
        self.isUserInteractionEnabled = !self.isReadonly
    }
    
}
