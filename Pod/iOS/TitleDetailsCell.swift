//
//  TitleValueCell.swift
//  Pods
//
//  Created by Sam Williams on 4/7/16.
//
//

import UIKit

public class TitleDetailsCell: TableCell {
    var showTitleLabel:Bool = true
    var titleLabel:UILabel?
    
    var mainContent:UIView?
    var detailContent:UIView?
    
    public var controlView:UIStackView?
    
    var contentConstraints:[NSLayoutConstraint] = []
    
    public dynamic var titleTextColor:UIColor? = UIColor.blackColor()               { didSet { self.stylize() } }
    public dynamic var titleFont:UIFont = UIFont.boldSystemFontOfSize(17)           { didSet { self.stylize() } }
    
    public dynamic var topTitleTextColor:UIColor? = UIColor.blackColor()             { didSet { self.stylize() } }
    public dynamic var topTitleFont:UIFont = UIFont.boldSystemFontOfSize(11)         { didSet { self.stylize() } }
    
    // Doesn't quite belong here, but many subclasses use this.  Convenience!
    public dynamic var valueTextColor:UIColor? = UIColor(white: 0.4, alpha: 1)       { didSet { self.stylize() } }
    public dynamic var valueFont:UIFont = UIFont.systemFontOfSize(17)                { didSet { self.stylize() } }

    public var labelPosition:FieldLabelPosition = .Left {
        didSet {
            self.setupConstraints()
            self.stylize()
        }
    }
    
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
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        self.mainContent?.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let controlView = UIStackView(frame: CGRect.zero)
        controlView.axis = UILayoutConstraintAxis.Horizontal
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.spacing = 15
        self.mainContent?.addSubview(controlView)
        self.controlView = controlView
        
        
        let views = ["main":mainContent, "detail":detailContent]
        let metrics = [
            "left": self.defaultContentInsets.left,
            "right": self.defaultContentInsets.right,
            "top": self.defaultContentInsets.top,
            "bottom": self.defaultContentInsets.bottom,
            "icon": 20
        ]
        
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
    }
    
    override public func stylize() {
        super.stylize()
        
        switch self.labelPosition {
        case .Left:
            self.titleLabel?.font       = self.titleFont
            self.titleLabel?.textColor  = self.titleTextColor
        case .Top:
            self.titleLabel?.font       = self.topTitleFont
            self.titleLabel?.textColor  = self.topTitleTextColor
        }
    }
    
    func setupConstraints() {
        guard let titleLabel=self.titleLabel, controlView=self.controlView, mainContent=self.mainContent else { return }
        
        let views = ["title":titleLabel, "controls":controlView, "main":mainContent]
        let metrics = [
            "left": self.defaultContentInsets.left,
            "right": self.defaultContentInsets.right,
            "top": self.defaultContentInsets.top,
            "bottom": self.defaultContentInsets.bottom,
            "minTitleWidth": 10,
            "hSpacing": 10,
            "controlHeight": 10
        ]
        
        for constraint in self.contentConstraints {
            self.mainContent?.removeConstraint(constraint)
        }
        
        var newConstraints:[NSLayoutConstraint] = []
        
        switch self.labelPosition {
        case .Left:
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[title(>=minTitleWidth)]-(hSpacing)-[controls]-right-|", options: .AlignAllTop, metrics: metrics, views: views)
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
    
    func addControl(control:UIView, alignment:ControlAlignment = .Right) {
        control.translatesAutoresizingMaskIntoConstraints = false
        self.controlView!.addArrangedSubview(control)
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.stylize()
    }
}