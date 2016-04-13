//
//  TextFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit
import MagneticFields

public enum TextEditingMode {
    case Inline
    case Push
}

/**
    A cell that uses a UITextField as an input, but doesn't necessarily have a String value.  Should be subclassed.
*/
public class TextFieldInputCell: FieldCell, UITextFieldDelegate, TappableTableCell {
    public var textField:UITextField?
    public var editingMode:TextEditingMode = .Inline
    
    /**
        The string that is set by and displayed in the text field, but isn't necessarily the primary value of this cell.
        Subclasses should override this with getters and setters that translate it to their primary value type.
    */
    public var stringValue:String?
    
    override public func buildView() {
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
    
    override public func stylize() {
        super.stylize()
        self.textField?.textAlignment = self.labelPosition == .Left ? .Right : .Left
        self.textField?.font = self.valueFont
        self.textField?.textColor = self.valueTextColor
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        let newValue = self.textField?.text
        if newValue != self.stringValue {
            self.stringValue = newValue
            
            // TODO: could be more accurate about this.  Maybe keep track of whether user actually changed the value
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
    
    override public func cancel() {
        self.textField?.resignFirstResponder()
    }
    
    override public func clear() {
        self.stringValue = nil
        super.clear()
    }
    
    override public var blank:Bool {
        get {
            return self.stringValue == nil
        }
    }
    
    override func update() {
        super.update()
        self.textField?.text = self.stringValue
        self.textField?.placeholder = self.placeholderText
        self.textField?.userInteractionEnabled = !self.readonly
    }
    
    func handleTap() {
        self.textField?.becomeFirstResponder()
    }
   
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.stringValue = nil
        self.textField?.text = nil
        self.textField?.enabled = true
    }
}

/**
    A cell that uses a UITextField as an input and has a String value
*/

public class TextFieldCell: TextFieldInputCell, Observable, Observer {
    public override var stringValue:String? {
        get {
            return self.value
        }
        set {
            self.value = newValue
        }
    }
    
    public var value:String? {
        didSet {
            self.update()
            self.notifyObservers()
        }
    }

    // MARK: - Observable
    
    public typealias ValueType = String
    public var observations = ObservationRegistry<ValueType>()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.removeAllObservers()
    }
    
    // MARK: - Observer
    
    public func valueChanged<ObservableType:Observable>(value:ValueType?, observable:ObservableType?) {
        self.value = value
    }
}

public class EmailAddressCell: TextFieldCell {
    override public func buildView() {
        super.buildView()
        self.textField?.keyboardType = .EmailAddress
        self.textField?.autocapitalizationType = .None
        self.textField?.autocorrectionType = .No
    }
}

public class PasswordCell: TextFieldCell {
    override public func buildView() {
        super.buildView()
        self.textField?.autocapitalizationType = .None
        self.textField?.autocorrectionType = .No
        self.textField?.secureTextEntry = true
    }
}

public class PhoneNumberCell: TextFieldCell {
    override public func buildView() {
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
