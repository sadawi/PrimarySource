//
//  TableCell.swift
//  Pods
//
//  Created by Sam Williams on 11/23/15.
//
//

import UIKit

protocol TappableTableCell {
    func handleTap()
}

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

public class ButtonCell: TableCell, TappableTableCell {
    public var button:UIButton?
    public var onTap:(Void -> Void)?
    
    public var title:String? {
        set {
            self.button?.setTitle(newValue, forState: UIControlState.Normal)
        }
        get {
            return self.button?.titleLabel?.text
        }
    }
    
    override func buildView() {
        super.buildView()
        let button = UIButton(type: .Custom)
        button.frame = self.contentView.bounds
        button.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.contentView.addSubview(button)
        
        button.addTarget(self, action: Selector("handleTap"), forControlEvents: .TouchUpInside)
        
        self.button = button
    }
    
    func handleTap() {
        if let onTap = self.onTap {
            onTap()
        }
    }
}

enum ControlAlignment {
    case Right
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
//                titleLabel.backgroundColor = UIColor.greenColor()
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let controlView = UIView(frame: CGRect.zero)
        controlView.translatesAutoresizingMaskIntoConstraints = false
//                controlView.backgroundColor = UIColor.redColor()
        self.contentView.addSubview(controlView)
        self.controlView = controlView
        
        let views = ["title":titleLabel, "controls":controlView]
        let metrics = ["left": self.separatorInset.left, "right": self.layoutMargins.right, "top": self.layoutMargins.top, "bottom": self.layoutMargins.bottom]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-left-[title]-[controls]-right-|",
            options: .AlignAllTop,
            metrics: metrics,
            views: views))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[title]|", options: .AlignAllTop, metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[controls]|", options: .AlignAllTop, metrics: metrics, views: views))
    }
    
    func valueChanged() {
        self.handleChange()
    }
    
    func handleChange() {
        if let onChange = self.onChange {
            onChange()
        }
    }
    
    private func addControl(control:UIView, alignment:ControlAlignment = .Right) {
        control.translatesAutoresizingMaskIntoConstraints = false
        self.controlView!.addSubview(control)
        
        self.addConstraint(NSLayoutConstraint(item: control, attribute: .Right, relatedBy: .Equal, toItem: control.superview, attribute: .Right, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: control, attribute: .CenterY, relatedBy: .Equal, toItem: control.superview, attribute: .CenterY, multiplier: 1, constant: 0))
    }
}

public class DateFieldCell: FieldCell {
    public var value:NSDate?
}

public enum TextEditingMode {
    case Inline
    case Push
}

public class TextFieldCell: FieldCell, UITextFieldDelegate {
    public var textField:UITextField?
    public var editingMode:TextEditingMode = .Inline
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
        textField.returnKeyType = UIReturnKeyType.Done
        textField.clearButtonMode = .WhileEditing
        
        self.controlView!.addSubview(textField)
        textField.delegate = self
        self.textField = textField
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        self.handleChange()
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

public class EmailAddressCell: TextFieldCell {
    override func buildView() {
        super.buildView()
        self.textField?.keyboardType = .EmailAddress
    }
}

public class PhoneNumberCell: TextFieldCell {
    override func buildView() {
        super.buildView()
        self.textField?.keyboardType = .PhonePad
    }
    
    
    // TODO: extract this / use a library
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let newString = (text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (text as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        } else {
            return false
        }
    }
    
}

public enum SelectMode {
    case Push
    case Alert
    case Picker
}

public class SelectCell<ValueType>: FieldCell {
    public var value:ValueType?
    public var options:[ValueType] = []
    public var selectMode:SelectMode = .Push
}

public class IntegerCell: FieldCell {
    public var value:Int?
}

public class StepperCell: IntegerCell {
    public var stepper:UIStepper?

    override func buildView() {
        super.buildView()
        let control = UIStepper(frame: self.controlView!.bounds)
        self.addControl(control, alignment:.Right)
        control.addTarget(self, action: Selector("valueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.stepper = control
    }
    
    
}

public class BooleanCell:FieldCell {
    // TODO: to be consistent, probably should be (Bool?)
    public var value:Bool = false
}

public class SwitchCell:BooleanCell, TappableTableCell  {
    var switchControl:UISwitch?
    
    // TODO: probably want to leave the var alone, and add some overridable methods
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
        let control = UISwitch(frame: self.controlView!.bounds)
        self.addControl(control, alignment:.Right)
        control.addTarget(self, action: Selector("valueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.switchControl = control
    }
    
    public func toggle(animated:Bool=true) {
        self.switchControl?.setOn(!self.value, animated: animated)
        self.valueChanged()
    }
    
    func handleTap() {
        self.toggle()
    }
}