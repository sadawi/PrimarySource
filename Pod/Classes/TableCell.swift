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
    
    public func buildView() {
        self.clipsToBounds = true
        self.textLabel?.numberOfLines = 0
        self.textLabel?.lineBreakMode = .ByWordWrapping
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        self.stylize()
    }
    
    public func stylize() {
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
    
    override public func stylize() {
        self.detailTextLabel?.textColor = self.detailTextColor
    }
}

public class ActivityIndicatorCell: TableCell {
    public var activityIndicator:UIActivityIndicatorView?
    
    override public func buildView() {
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

public class ButtonCell: TableCell {
    public var button:UIButton?
    
    public dynamic var buttonFont:UIFont?
    
    public var title:String? {
        set {
            self.button?.setTitle(newValue, forState: UIControlState.Normal)
        }
        get {
            return self.button?.titleLabel?.text
        }
    }
    
    override public func buildView() {
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
        self.selectionStyle = .None
        
        self.button = button
    }
    
    // Let the CollectionItem handle taps
    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if CGRectContainsPoint(self.bounds, point) {
            return self
        } else {
            return super.hitTest(point, withEvent: event)
        }
    }
    
    override public func stylize() {
        super.stylize()
        if let font = self.buttonFont {
            self.button?.titleLabel?.font = font
        }
        if self.button?.backgroundColor == nil || self.button?.backgroundColor == UIColor.clearColor() || self.button?.backgroundColor == self.button?.titleColorForState(.Normal) {
            self.button?.setTitleColor(self.tintColor, forState: UIControlState.Normal)
        }
    }
}