//
//  TableCell.swift
//  Pods
//
//  Created by Sam Williams on 11/23/15.
//
//

import UIKit

public struct TableCellSeparatorStyle: OptionSetType {
    public let rawValue:Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let None     = TableCellSeparatorStyle(rawValue: 0)
    public static let Top      = TableCellSeparatorStyle(rawValue: 1 << 1)
    public static let Bottom   = TableCellSeparatorStyle(rawValue: 1 << 2)
}

protocol TappableTableCell {
    func handleTap()
}

public class TableCell: UITableViewCell {
    internal weak var dataSource:DataSource?
    
    private let internalSeparatorHeight: CGFloat = 0.5
    
    public dynamic var internalSeparatorColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            self.updateSeparators()
        }
    }
    
    public var internalSeparatorStyle: TableCellSeparatorStyle = .None {
        didSet {
            self.updateSeparators()
        }
    }
    
    lazy private var topSeparator: UIView = {
        let view = self.buildSeparator()
        view.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
        self.addSubview(view)
        return view
    }()

    lazy private var bottomSeparator: UIView = {
        let view = self.buildSeparator()
        view.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        var f = view.frame
        f.origin.y = self.bounds.size.height - self.internalSeparatorHeight
        view.frame = f
        self.addSubview(view)
        return view
    }()
    
    private func buildSeparator() -> UIView {
        let view = UIView()
        let x = self.defaultContentInsets.left
        view.frame = CGRect(x: x, y: 0, width: self.contentView.bounds.size.width-x, height: internalSeparatorHeight)
        view.hidden = true
        return view
    }
    
    func updateSeparators() {
        self.topSeparator.hidden = !self.internalSeparatorStyle.contains(.Top)
        self.bottomSeparator.hidden = !self.internalSeparatorStyle.contains(.Bottom)
        for separator in [self.topSeparator, self.bottomSeparator] {
            separator.backgroundColor = self.internalSeparatorColor
        }
    }
    
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
        self.updateSeparators()
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        self.stylize()
    }
    
    public func stylize() {
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.internalSeparatorStyle = .None
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

public class ButtonCell: ContentCell {
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
    
    public override func buildContent() -> UIView {
        let button = UIButton(type: .Custom)
        self.button = button
        return button
    }
    
    override public func buildView() {
        super.buildView()
        self.selectionStyle = .None
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