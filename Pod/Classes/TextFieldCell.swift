//
//  TextFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

public enum TextEditingMode {
    case Inline
    case Push
}

public class TextFieldCell: FieldCell, UITextFieldDelegate {
    public var textField:UITextField?
    public var editingMode:TextEditingMode = .Inline
    public var value:String? {
        didSet {
            self.update()
        }
    }
    
    override func buildView() {
        super.buildView()
        
        let textField = UITextField(frame: self.controlView!.bounds)
        
        textField.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        textField.returnKeyType = UIReturnKeyType.Continue
        
        self.controlView!.addSubview(textField)
        
        textField.addConstraint(NSLayoutConstraint(item: textField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30))
        
        textField.delegate = self
        self.textField = textField
    }
    
    override public func commit() {
        super.commit()
        self.textField?.resignFirstResponder()
    }
    
    override func stylize() {
        super.stylize()
        self.textField?.textAlignment = self.labelPosition == .Left ? .Right : .Left
        self.textField?.font = self.contentFont
        self.textField?.textColor = self.valueTextColor
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        let newValue = self.textField?.text
        if newValue != self.value {
            self.value = newValue
            self.valueChanged()
        }
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.textField?.inputAccessoryView = self.accessoryToolbar
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.commit()
        return true
    }
    
    public override func valueChanged() {
        super.valueChanged()
    }
    
    override public func cancel() {
        self.textField?.resignFirstResponder()
    }
    
    override public func clear() {
        self.value = nil
        super.clear()
    }
    
    override public var blank:Bool {
        get {
            return self.value == nil
        }
    }
    
    func displayValue() -> String? {
        return self.value
    }
    
    override func update() {
        super.update()
        self.textField?.text = self.displayValue()
    }
    
}

public class EmailAddressCell: TextFieldCell {
    override func buildView() {
        super.buildView()
        self.textField?.keyboardType = .EmailAddress
        self.textField?.autocapitalizationType = .None
        self.textField?.autocorrectionType = .No
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