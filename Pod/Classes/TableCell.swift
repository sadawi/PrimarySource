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
    internal weak var dataSource:DataSource?
    
    var defaultContentInsets:UIEdgeInsets {
        get {
            let side = self.separatorInset.left
            return UIEdgeInsets(top: self.layoutMargins.top, left: side, bottom: self.layoutMargins.bottom, right: side)
        }
    }
    
    public dynamic var textLabelFont:UIFont? {
        get {
            return self.textLabel?.font
        }
        set {
            self.textLabel?.font = newValue
        }
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildView()
    }
    
    func buildView() {
        self.clipsToBounds = true
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        self.stylize()
    }
    
    func stylize() {
    }
}

public class SubtitleCell: TableCell {
    public dynamic var detailTextColor:UIColor? = UIColor(white: 0.5, alpha: 1)
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func stylize() {
        self.detailTextLabel?.textColor = self.detailTextColor
    }
}

public class ActivityIndicatorCell: TableCell {
    public var activityIndicator:UIActivityIndicatorView?
    
    override func buildView() {
        super.buildView()
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activity.center = CGPoint(x: CGRectGetMidX(self.contentView.bounds), y: CGRectGetMidY(self.contentView.bounds))
        activity.autoresizingMask = [.FlexibleLeftMargin, .FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleRightMargin]
        self.contentView.addSubview(activity)
        self.activityIndicator = activity
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.activityIndicator?.startAnimating()
    }
}

public class ButtonCell: TableCell, TappableTableCell {
    public var button:UIButton?
    public var onTap:(Void -> Void)?
    
    public dynamic var buttonFont:UIFont?
    
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
        
        var frame = self.contentView.bounds
        frame.origin.x = self.defaultContentInsets.left
        frame.origin.y = self.defaultContentInsets.top
        frame.size.width -= (frame.origin.x + self.defaultContentInsets.right)
        frame.size.height -= (frame.origin.y + self.defaultContentInsets.bottom)
        
        button.frame = frame
        button.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.contentView.addSubview(button)
        button.addTarget(self, action: Selector("handleTap"), forControlEvents: .TouchUpInside)
        
        self.button = button
    }
    
    override func stylize() {
        super.stylize()
        if let font = self.buttonFont {
            self.button?.titleLabel?.font = font
        }
        self.button?.setTitleColor(self.tintColor, forState: UIControlState.Normal)
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

public enum FieldLabelPosition {
    case Top
    case Left
}

public class FieldCell: TableCell {
    var showTitleLabel:Bool = true
    var titleLabel:UILabel?
    var controlView:UIStackView?
    
    public var blank:Bool {
        get { return true }
    }
    
    var contentConstraints:[NSLayoutConstraint] = []
    
    public dynamic var titleTextColor:UIColor? = UIColor.blackColor()
    public dynamic var valueTextColor:UIColor? = UIColor(white: 0.4, alpha: 1)
    public dynamic var contentFont:UIFont = UIFont.systemFontOfSize(17)
    
    lazy var accessoryToolbar:UIToolbar = {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height))
        self.configureAccessoryToolbar(toolbar)
        return toolbar
    }()
    
    func configureAccessoryToolbar(toolbar:UIToolbar) {
        var items:[UIBarButtonItem] = []
        if toolbarShowsCancelButton() {
            items.append(UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancel")))
        }
        if toolbarShowsClearButton() {
            items.append(UIBarButtonItem(title: "Clear", style: .Done, target: self, action: Selector("clear")))
        }
        
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("commit")))
        
        toolbar.items = items
    }
    
    func toolbarShowsCancelButton() -> Bool {
        return false
    }

    func toolbarShowsClearButton() -> Bool {
        return true
    }
    
    public func commit() {
    }
    
    public func cancel() {
    }
    
    public func clear() {
        self.cancel()
        self.update()
    }
    
    public var labelPosition:FieldLabelPosition = .Left {
        didSet {
            self.setupConstraints()
            self.stylize()
        }
    }
    
    public var onChange:(Void -> Void)?
    
    public var title:String? {
        didSet {
            self.update()
        }
    }
    
    private func formattedTitle() -> String? {
        if self.labelPosition == .Top {
            return self.title?.uppercaseString
        } else {
            return self.title
        }
    }
    
    override func buildView() {
        super.buildView()
        
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //                titleLabel.backgroundColor = UIColor.greenColor()
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let controlView = UIStackView(frame: CGRect.zero)
        controlView.axis = UILayoutConstraintAxis.Horizontal
        //        controlView.distribution =
        controlView.translatesAutoresizingMaskIntoConstraints = false
        //                controlView.backgroundColor = UIColor.redColor()
        self.contentView.addSubview(controlView)
        self.controlView = controlView
        
        self.setupConstraints()
        self.stylize()
        self.update()
    }
    
    func update() {
        self.titleLabel?.text = self.formattedTitle()
    }
    
    override func stylize() {
        super.stylize()
        
        switch self.labelPosition {
        case .Left:
            self.titleLabel?.font = self.contentFont
            self.titleLabel?.textColor = self.titleTextColor
        case .Top:
            self.titleLabel?.textColor = UIColor(white: 0.5, alpha: 1)
            self.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        }
    }
    
    func setupConstraints() {
        guard let titleLabel=self.titleLabel, controlView=self.controlView else { return }
        
        let views = ["title":titleLabel, "controls":controlView]
        let metrics = [
            "left": self.defaultContentInsets.left,
            "right": self.defaultContentInsets.right,
            "top": self.defaultContentInsets.top,
            "bottom": self.defaultContentInsets.bottom,
            "controlHeight": 10
        ]
        
        for constraint in self.contentConstraints {
            self.contentView.removeConstraint(constraint)
        }
        
        var newConstraints:[NSLayoutConstraint] = []
        
        switch self.labelPosition {
        case .Left:
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[title]-[controls]-right-|", options: .AlignAllTop, metrics: metrics, views: views)
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[title]-bottom-|", options: .AlignAllTop, metrics: metrics, views: views)
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[controls]-bottom-|", options: .AlignAllTop, metrics: metrics, views: views)
            
        case .Top:
            let options = NSLayoutFormatOptions.AlignAllLeft
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[title]-right-|", options: options, metrics: metrics, views: views)
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[controls]-right-|", options: options, metrics: metrics, views: views)
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[title]-[controls(>=controlHeight)]-bottom-|", options: options, metrics: metrics, views: views)
        }
        
        self.contentView.addConstraints(newConstraints)
        self.contentConstraints = newConstraints
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
        self.controlView!.addArrangedSubview(control)
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.stylize()
    }
}

public class DateFieldCell: TextFieldCell {
    public var dateValue:NSDate?
    public var dateFormatter:NSDateFormatter = NSDateFormatter()
    public var datePicker:UIDatePicker?
    
    override func buildView() {
        super.buildView()
        
        self.dateFormatter.dateStyle = .MediumStyle
        
        self.datePicker = UIDatePicker()
        self.datePicker?.datePickerMode = .Date
        self.datePicker?.addTarget(self, action: Selector("datePickerValueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.textField?.inputView = self.datePicker
        self.textField?.tintColor = UIColor.clearColor()
    }
    
    func datePickerValueChanged() {
        self.dateValue = self.datePicker?.date
        self.update()
    }
    
    override public func commit() {
        super.commit()
        self.datePickerValueChanged()
    }
    
    override public func clear() {
        self.dateValue = nil
        super.clear()
    }
    
    override func update() {
        super.update()
        if let date = self.dateValue {
            self.textField?.text = self.dateFormatter.stringFromDate(date)
        } else {
            self.textField?.text = nil
        }
    }
    
}

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
    
    override func update() {
        super.update()
        self.textField?.text = self.value
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
        
        //        control.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        
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