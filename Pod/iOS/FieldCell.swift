//
//  FieldCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

enum ControlAlignment {
    case Right
}

public enum FieldLabelPosition {
    case Top
    case Left
}

public enum FieldState {
    case Normal
    case Error([String])
    case Editing
}

public class FieldCell: TitleDetailsCell {
    var errorLabel:UILabel?
    var errorIcon:UIImageView?
    
    public var readonly:Bool = false
    
    public var placeholderText:String? {
        didSet {
            self.update()
        }
    }
    
    public var blank:Bool {
        get { return true }
    }
    
    public var state:FieldState = .Normal {
        didSet {
            self.update()
            self.stylize()
        }
    }
    
    public dynamic var errorTextColor:UIColor? = UIColor.redColor()
    
    lazy var accessoryToolbar:UIToolbar = {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.bounds.size.width, 36))
        self.configureAccessoryToolbar(toolbar)
        return toolbar
        }()
    
    func configureAccessoryToolbar(toolbar:UIToolbar) {
        var items:[UIBarButtonItem] = []
        if self.toolbarShowsCancelButton {
            items.append(UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancel")))
        }
        if self.toolbarShowsClearButton {
            items.append(UIBarButtonItem(title: "Clear", style: .Plain, target: self, action: Selector("clear")))
        }
        
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("commit")))
        
        toolbar.items = items
    }
    
    var toolbarShowsCancelButton = false
    var toolbarShowsClearButton = false
    
    public func commit() {
    }
    
    public func cancel() {
    }
    
    public func clear() {
        self.cancel()
        self.update()
    }
    
    public var onChange:(Void -> Void)?
    
    override public func buildView() {
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
        
        self.detailContent?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[error]-right-|", options: .AlignAllTop, metrics: metrics, views: views))
        
        self.detailContent?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[error]|", options: .AlignAllTop, metrics: metrics, views: views))
    }
    
    override func update() {
        super.update()

        switch self.state {
        case .Error(let messages):
            self.errorIcon?.image = UIImage(named: "error-32", inBundle: NSBundle(forClass: FieldCell.self), compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
            self.errorLabel?.text = messages.joinWithSeparator("\n")
        default:
            self.errorIcon?.image = nil
            self.errorLabel?.text = nil
        }
    }
    
    override public func stylize() {
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
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.accessoryType = .None
        self.placeholderText = nil
    }
}
