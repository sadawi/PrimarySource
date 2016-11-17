//
//  FieldCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

enum ControlAlignment {
    case right
}

public enum FieldLabelPosition {
    case top
    case left
}

public enum FieldState {
    case normal
    case error([String])
    case editing
}

open class FieldCell: TitleDetailsCell {
    var errorLabel:UILabel?
    var errorIcon:UIImageView?
    
    open var readonly:Bool = false
    
    open var placeholderText:String? {
        didSet {
            self.update()
        }
    }
    
    open var blank:Bool {
        get { return true }
    }
    
    open var state:FieldState = .normal {
        didSet {
            self.update()
            self.stylize()
        }
    }
    
    open dynamic var errorTextColor:UIColor? = UIColor.red
    
    lazy var accessoryToolbar:UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 36))
        self.configureAccessoryToolbar(toolbar)
        return toolbar
        }()
    
    func configureAccessoryToolbar(_ toolbar:UIToolbar) {
        var items:[UIBarButtonItem] = []
        if self.toolbarShowsCancelButton {
            items.append(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FieldCell.cancel)))
        }
        if self.toolbarShowsClearButton {
            items.append(UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(FieldCell.clear)))
        }
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FieldCell.commit)))
        
        toolbar.items = items
    }
    
    var toolbarShowsCancelButton = false
    var toolbarShowsClearButton = false
    
    open func commit() {
    }
    
    open func cancel() {
    }
    
    open func clear() {
        self.cancel()
        self.update()
    }
    
    open var onChange:((Void) -> Void)?
    
    override open func buildView() {
        super.buildView()
        
        let errorLabel = UILabel(frame: self.detailContent!.bounds)
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailContent?.addSubview(errorLabel)
        self.errorLabel = errorLabel

        let views = ["error":errorLabel, "main":self.mainContent!]
        let metrics = [
            "left": self.defaultContentInsets.left,
            "right": self.defaultContentInsets.right,
            "top": self.defaultContentInsets.top,
            "bottom": self.defaultContentInsets.bottom,
            "icon": 20
        ]
        
        self.detailContent?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[error]-right-|", options: .alignAllTop, metrics: metrics, views: views))
        
        self.detailContent?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[error]|", options: .alignAllTop, metrics: metrics, views: views))
    }
    
    override func update() {
        super.update()

        switch self.state {
        case .error(let messages):
            self.errorIcon?.image = UIImage(named: "error-32", in: Bundle(for: FieldCell.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            self.errorLabel?.text = messages.joined(separator: "\n")
        default:
            self.errorIcon?.image = nil
            self.errorLabel?.text = nil
        }
    }
    
    override open func stylize() {
        super.stylize()
        
        self.errorLabel?.textColor = self.errorTextColor
        self.errorIcon?.tintColor = self.errorTextColor
        self.errorLabel?.font = self.valueFont
    }
    
    func valueChanged() {
        self.handleChange()
    }
    
    func handleChange() {
        if let onChange = self.onChange {
            onChange()
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.accessoryType = .none
        self.placeholderText = nil
    }
}
