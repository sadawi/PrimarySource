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
    
    func formattedTitle() -> String? {
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
    
    func addControl(control:UIView, alignment:ControlAlignment = .Right) {
        control.translatesAutoresizingMaskIntoConstraints = false
        self.controlView!.addArrangedSubview(control)
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.stylize()
    }
}
