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

public class FieldCell: TableCell {
    var showTitleLabel:Bool = true
    var titleLabel:UILabel?
    var errorLabel:UILabel?
    var errorIcon:UIImageView?
    
    var mainContent:UIView?
    var detailContent:UIView?
    
    public var readonly:Bool = false
    
    public var placeholderText:String? {
        didSet {
            self.update()
        }
    }
    
    var controlView:UIStackView?
    
    public var blank:Bool {
        get { return true }
    }
    
    var contentConstraints:[NSLayoutConstraint] = []

    public var state:FieldState = .Normal {
        didSet {
            self.update()
            self.stylize()
        }
    }
    
    public dynamic var titleTextColor:UIColor? = UIColor.blackColor()
    public dynamic var errorTextColor:UIColor? = UIColor.redColor()
    
    public dynamic var valueTextColor:UIColor? = UIColor(white: 0.4, alpha: 1)
    public dynamic var contentFont:UIFont = UIFont.systemFontOfSize(17)
    
    lazy var accessoryToolbar:UIToolbar = {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.bounds.size.width, 36))
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
    
    func formattedTitle() -> String? {
        if self.labelPosition == .Top {
            return self.title?.uppercaseString
        } else {
            return self.title
        }
    }
    
    override public func buildView() {
        super.buildView()
        
        let mainContent = UIView(frame: CGRect.zero)
        mainContent.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(mainContent)
        self.mainContent = mainContent

        let detailContent = UIView(frame: CGRect.zero)
        detailContent.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(detailContent)
        self.detailContent = detailContent
        
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainContent?.addSubview(titleLabel)
        self.titleLabel = titleLabel

//        let errorIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
//        errorIcon.contentMode = .ScaleAspectFit
//        errorIcon.translatesAutoresizingMaskIntoConstraints = false
//        self.detailContent?.addSubview(errorIcon)
//        self.errorIcon = errorIcon

        let errorLabel = UILabel(frame: detailContent.bounds)
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailContent?.addSubview(errorLabel)
        self.errorLabel = errorLabel

        let controlView = UIStackView(frame: CGRect.zero)
        controlView.axis = UILayoutConstraintAxis.Horizontal
        controlView.translatesAutoresizingMaskIntoConstraints = false
        self.mainContent?.addSubview(controlView)
        self.controlView = controlView
        
        
//        let views = ["error":errorLabel, "main":mainContent, "detail":detailContent, "errorIcon": errorIcon]
        let views = ["error":errorLabel, "main":mainContent, "detail":detailContent]
        let metrics = [
            "left": self.defaultContentInsets.left,
            "right": self.defaultContentInsets.right,
            "top": self.defaultContentInsets.top,
            "bottom": self.defaultContentInsets.bottom,
            "icon": 20
        ]
        
//        self.detailContent?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[errorIcon(icon)]-[error]-right-|", options: .AlignAllTop, metrics: metrics, views: views))
        self.detailContent?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[error]-right-|", options: .AlignAllTop, metrics: metrics, views: views))
        
        self.detailContent?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[error]|", options: .AlignAllTop, metrics: metrics, views: views))
//        self.detailContent?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[errorIcon]|", options: .AlignAllTop, metrics: metrics, views: views))
        
        var constraints:[NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[main]|", options: .AlignAllTop, metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[detail]|", options: .AlignAllTop, metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[main][detail]-bottom-|", options: .AlignAllLeft, metrics: metrics, views: views)
        self.contentView.addConstraints(constraints)
    
        
        self.setupConstraints()
        self.stylize()
        self.update()
    }
    
    func update() {
        self.titleLabel?.text = self.formattedTitle()
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
        
//        self.controlView?.backgroundColor = UIColor.greenColor()
//        self.titleLabel?.backgroundColor = UIColor.yellowColor()
//        self.errorLabel?.backgroundColor = UIColor.grayColor()
        
        switch self.labelPosition {
        case .Left:
            self.titleLabel?.font = self.contentFont
            self.titleLabel?.textColor = self.titleTextColor
        case .Top:
            self.titleLabel?.textColor = UIColor(white: 0.5, alpha: 1)
            self.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        }
        
        self.errorLabel?.textColor = self.errorTextColor
        self.errorIcon?.tintColor = self.errorTextColor
        self.errorLabel?.font = self.contentFont
    }
    
    func setupConstraints() {
        guard let titleLabel=self.titleLabel, controlView=self.controlView, mainContent=self.mainContent else { return }
        
        let views = ["title":titleLabel, "controls":controlView, "main":mainContent]
        let metrics = [
            "left": self.defaultContentInsets.left,
            "right": self.defaultContentInsets.right,
            "top": self.defaultContentInsets.top,
            "bottom": self.defaultContentInsets.bottom,
            "controlHeight": 10
        ]
        
        for constraint in self.contentConstraints {
            self.mainContent?.removeConstraint(constraint)
        }
        
        var newConstraints:[NSLayoutConstraint] = []
        
        switch self.labelPosition {
        case .Left:
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[title]-[controls]-right-|", options: .AlignAllTop, metrics: metrics, views: views)
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[title]|", options: .AlignAllTop, metrics: metrics, views: views)
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[controls]|", options: .AlignAllTop, metrics: metrics, views: views)
        case .Top:
            let options = NSLayoutFormatOptions.AlignAllLeft
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[title]-right-|", options: options, metrics: metrics, views: views)
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[controls]-right-|", options: options, metrics: metrics, views: views)
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[title]-[controls(>=controlHeight)]-|", options: options, metrics: metrics, views: views)
        }
        
        self.mainContent?.addConstraints(newConstraints)
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
    
    func addControl(control:UIView, alignment:ControlAlignment = .Right) {
        control.translatesAutoresizingMaskIntoConstraints = false
        self.controlView!.addArrangedSubview(control)
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.stylize()
    }
}
