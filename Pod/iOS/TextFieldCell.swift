//
//  TextFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

public enum TextEditingMode {
    case inline
    case push
}

/**
    A cell that uses a UITextField as an input, but doesn't necessarily have a String value.
*/
open class TextFieldInputCell<Value: Equatable>: FieldCell<Value>, UITextFieldDelegate, TappableTableCell {
    open var textField:UITextField?
    open var editingMode:TextEditingMode = .inline
    
    /**
        The string that is set by and displayed in the text field, but isn't necessarily the primary value of this cell.
        Subclasses should override this with getters and setters that translate it to their primary value type.
    */
    open var stringValue:String? {
        get {
            return self.exportText(self.value)
        }
        set {
            self.value = self.importText(newValue)
        }
    }
    
    override open func buildView() {
        super.buildView()
        
        let textField = UITextField(frame: self.controlView!.bounds)
        
        textField.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textField.returnKeyType = UIReturnKeyType.continue
        
        self.controlView!.addSubview(textField)
        
        textField.addConstraint(NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
        
        textField.delegate = self
        self.textField = textField
    }
    
    override open func commit() {
        super.commit()
        self.textField?.resignFirstResponder()
    }
    
    override open func stylize() {
        super.stylize()
        self.textField?.textAlignment = self.labelPosition == .left ? .right : .left
        self.textField?.font = self.valueFont
        self.textField?.textColor = self.valueTextColor
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        let newValue = self.textField?.text
        if newValue != self.stringValue {
            self.stringValue = newValue
        }
    }
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textField?.inputAccessoryView = self.accessoryToolbar
        return true
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commit()
        return true
    }
    
    override open func cancel() {
        self.textField?.resignFirstResponder()
    }
    
    override open func clear() {
        self.stringValue = nil
        super.clear()
    }
    
    override open var isBlank:Bool {
        get {
            let string = self.stringValue
            return string == nil || string?.characters.count == 0
        }
    }
    
    override open func update() {
        super.update()
        self.textField?.text = self.stringValue
        self.textField?.placeholder = self.placeholderText
        self.textField?.isUserInteractionEnabled = !self.isReadonly
        self.textField?.keyboardType = self.keyboardType
    }
    
    public func handleTap() {
        self.textField?.becomeFirstResponder()
    }
   
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.stringValue = nil
        self.textField?.text = nil
        self.textField?.isEnabled = true

        self.textForValue = nil
        self.valueForText = nil
    }
    
    open var keyboardType: UIKeyboardType = .default

    open var textForValue:((Value) -> String)?
    open var valueForText:((String) -> Value?)?

    open func exportText(_ value: Value?) -> String? {
        if let value = value {
            if let formatter = self.textForValue {
                return formatter(value)
            } else {
                return String(describing: value)
            }
        } else {
            return nil // textfield will use placeholderText
        }
    }
    
    open func importText(_ text: String?) -> Value? {
        if let text = text, let importer = self.valueForText {
            return importer(text)
        } else {
            return nil
        }
    }
}

/**
    A cell that uses a UITextField as an input and has a String value
*/
open class TextFieldCell: TextFieldInputCell<String> {
    open override var stringValue:String? {
        get {
            return self.value
        }
        set {
            self.value = newValue
        }
    }
}

open class EmailAddressCell: TextFieldCell {
    override open func buildView() {
        super.buildView()
        self.textField?.keyboardType = .emailAddress
        self.textField?.autocapitalizationType = .none
        self.textField?.autocorrectionType = .no
    }
}

open class PasswordCell: TextFieldCell {
    override open func buildView() {
        super.buildView()
        self.textField?.autocapitalizationType = .none
        self.textField?.autocorrectionType = .no
        self.textField?.isSecureTextEntry = true
    }
}

open class PhoneNumberCell: TextFieldCell {
    override open func buildView() {
        super.buildView()
        self.textField?.keyboardType = .phonePad
    }
    
    
    // TODO: extract this / use a library
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (text as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        } else {
            return false
        }
    }
    
}
