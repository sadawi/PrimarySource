//
//  TableCell.swift
//  Pods
//
//  Created by Sam Williams on 11/23/15.
//
//

import UIKit

public class TableCell: UITableViewCell {
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildView()
    }
    
    func buildView() {
        
    }
}

public class FieldCell: TableCell {
    var showTitleLabel:Bool = true
    var titleLabel:UILabel?
    var controlView:UIView?
    
    public var onChange:(Void -> Void)?
    
    public var title:String? {
        didSet {
            self.titleLabel?.text = self.title
        }
    }
    
    override func buildView() {
        super.buildView()
        
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.backgroundColor = UIColor.greenColor()
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let controlView = UIView(frame: CGRect.zero)
        controlView.translatesAutoresizingMaskIntoConstraints = false
//        controlView.backgroundColor = UIColor.redColor()
        self.contentView.addSubview(controlView)
        self.controlView = controlView
        
        let views = ["title":titleLabel, "controls":controlView]
        let metrics = ["left": self.layoutMargins.left, "right": self.layoutMargins.right, "top": self.layoutMargins.top, "bottom": self.layoutMargins.bottom]

        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-left-[title]-[controls]-right-|",
            options: .AlignAllTop,
            metrics: metrics,
            views: views))

        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[title]|", options: .AlignAllTop, metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[controls]|", options: .AlignAllTop, metrics: metrics, views: views))
    }
    
    func handleChange() {
        if let onChange = self.onChange {
            onChange()
        }
    }
}

public class TextFieldCell: FieldCell, UITextFieldDelegate {
    public var textField:UITextField?
    public var value:String {
        get {
            return self.textField?.text ?? ""
        }
        set {
            self.textField?.text = newValue
        }
    }
    
    override func buildView() {
        super.buildView()
        let textField = UITextField(frame: self.controlView!.bounds)
        textField.textAlignment = .Right
        textField.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.controlView!.addSubview(textField)
        textField.delegate = self
        self.textField = textField
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        self.handleChange()
    }
}

public class EmailAddressCell: TextFieldCell {
    override func buildView() {
        super.buildView()
        self.textField?.keyboardType = .EmailAddress
    }
}

public class BooleanCell:FieldCell {
    public var value:Bool = false
}

public class SwitchCell:BooleanCell {
    var switchControl:UISwitch?

    public override var value:Bool {
        get {
            return self.switchControl?.on ?? false
        }
        set {
            self.switchControl?.on = newValue
        }
    }
    
    override func buildView() {
        super.buildView()
        let switchControl = UISwitch(frame: self.controlView!.bounds)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        self.controlView!.addSubview(switchControl)
        
        self.addConstraint(NSLayoutConstraint(item: switchControl, attribute: .Right, relatedBy: .Equal, toItem: switchControl.superview, attribute: .Right, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: switchControl, attribute: .CenterY, relatedBy: .Equal, toItem: switchControl.superview, attribute: .CenterY, multiplier: 1, constant: 0))
        
        switchControl.addTarget(self, action: Selector("valueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.switchControl = switchControl
    }
    
    func valueChanged() {
        self.handleChange()
    }
}