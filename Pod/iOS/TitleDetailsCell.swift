//
//  TitleValueCell.swift
//  Pods
//
//  Created by Sam Williams on 4/7/16.
//
//

import UIKit

open class TitleDetailsCell: TableCell {
    var showTitleLabel:Bool = true
    var titleLabel:UILabel?
    
    var mainContent:UIView?
    var detailContent:UIView?
    
    open var controlView:UIStackView?
    
    private var contentConstraints:[NSLayoutConstraint] = []
    
    open dynamic var titleTextColor:UIColor? = UIColor.black               { didSet { self.stylize() } }
    open dynamic var titleFont:UIFont = UIFont.boldSystemFont(ofSize: 17)           { didSet { self.stylize() } }
    
    open dynamic var topTitleTextColor:UIColor? = UIColor.black             { didSet { self.stylize() } }
    open dynamic var topTitleFont:UIFont = UIFont.boldSystemFont(ofSize: 11)         { didSet { self.stylize() } }
    
    // Doesn't quite belong here, but many subclasses use this.  Convenience!
    open dynamic var valueTextColor:UIColor? = UIColor(white: 0.4, alpha: 1)       { didSet { self.stylize() } }
    open dynamic var valueFont:UIFont = UIFont.systemFont(ofSize: 17)                { didSet { self.stylize() } }

    open var labelPosition:FieldLabelPosition = .left {
        didSet {
            self.setupConstraints()
            self.stylize()
        }
    }
    
    open var title:String? {
        didSet {
            self.update()
        }
    }
    
    func formattedTitle() -> String? {
        if self.labelPosition == .top {
            return self.title?.uppercased()
        } else {
            return self.title
        }
    }
    
    override open func buildView() {
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
        titleLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        self.mainContent?.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let controlView = UIStackView(frame: CGRect.zero)
        controlView.axis = UILayoutConstraintAxis.horizontal
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.spacing = 15
        self.mainContent?.addSubview(controlView)
        self.controlView = controlView
        
        
        let views = ["main":mainContent, "detail":detailContent]
        let metrics = [
            "left":     self.defaultContentInsets.left,
            "right":    self.defaultContentInsets.right,
            "top":      self.defaultContentInsets.top,
            "bottom":   self.defaultContentInsets.bottom,
            "icon":     20
        ]
        
        var constraints:[NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[main]|", options: .alignAllTop, metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[detail]|", options: .alignAllTop, metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[main][detail]-bottom-|", options: .alignAllLeft, metrics: metrics, views: views)
        self.contentView.addConstraints(constraints)
        
        
        self.setupConstraints()
        self.stylize()
        self.update()
    }
    
    func update() {
        self.titleLabel?.text = self.formattedTitle()
    }
    
    override open func stylize() {
        super.stylize()
        
        switch self.labelPosition {
        case .left:
            self.titleLabel?.font       = self.titleFont
            self.titleLabel?.textColor  = self.titleTextColor
        case .top:
            self.titleLabel?.font       = self.topTitleFont
            self.titleLabel?.textColor  = self.topTitleTextColor
        }
    }
    
    func setupConstraints() {
        guard let titleLabel=self.titleLabel, let controlView=self.controlView, let mainContent=self.mainContent else { return }
        
        let views = ["title":titleLabel, "controls":controlView, "main":mainContent]
        let metrics = [
            "left":             self.defaultContentInsets.left,
            "right":            self.defaultContentInsets.right,
            "top":              self.defaultContentInsets.top,
            "bottom":           self.defaultContentInsets.bottom,
            "minTitleWidth":    10,
            "hSpacing":         10,
            "controlHeight":    10
        ]
        
        mainContent.removeConstraints(self.contentConstraints)
        self.contentConstraints.removeAll()
        
        switch self.labelPosition {
        case .left:
            self.contentConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[title(>=minTitleWidth)]-(hSpacing)-[controls]-right-|", options: .alignAllTop, metrics: metrics, views: views)
            self.contentConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[title]|", options: .alignAllTop, metrics: metrics, views: views)
            self.contentConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[controls]|", options: .alignAllTop, metrics: metrics, views: views)
        case .top:
            let options = NSLayoutFormatOptions.alignAllLeft
            self.contentConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[title]-right-|", options: options, metrics: metrics, views: views)
            self.contentConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[controls]-right-|", options: options, metrics: metrics, views: views)
            self.contentConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[title]-[controls(>=controlHeight)]-|", options: options, metrics: metrics, views: views)
        }
        
        self.mainContent?.addConstraints(self.contentConstraints)
    }
    
    func addControl(_ control:UIView, alignment:ControlAlignment = .right) {
        control.translatesAutoresizingMaskIntoConstraints = false
        self.controlView!.addArrangedSubview(control)
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.stylize()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // Ensure we have the correct content insets (which could be inherited from tableView)
        self.setupConstraints()
    }
}
