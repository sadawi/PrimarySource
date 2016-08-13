//
//  TableCell.swift
//  Pods
//
//  Created by Sam Williams on 11/23/15.
//
//

import UIKit

//public struct TableCellSeparatorStyle: OptionSetType {
//    public let rawValue:Int
//    
//    public init(rawValue: Int) {
//        self.rawValue = rawValue
//    }
//    
//    public static let None     = TableCellSeparatorStyle(rawValue: 0)
//    public static let Top      = TableCellSeparatorStyle(rawValue: 1 << 1)
//    public static let Bottom   = TableCellSeparatorStyle(rawValue: 1 << 2)
//}
//

public enum Visibility {
    case None
    case Auto
    case Always
}

public struct BorderStyle {
    public var top: Visibility = .None
    public var bottom: Visibility = .None
    
    public init(top: Visibility, bottom: Visibility) {
        self.top = top
        self.bottom = bottom
    }
}

protocol TappableTableCell {
    func handleTap()
}

public class TableCell: UITableViewCell, ListMember {
    internal weak var dataSource:DataSource?
    
    public var adjustFrame: ((CGRect)->CGRect)?
    
    private let borderThickness: CGFloat = 0.5
    public var borderInsets: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            self.updateBorders()
        }
    }
    
    public var listMembership: ListMembership = .NotContained {
        didSet {
            self.updateBorders()
        }
    }
    
    public dynamic var borderColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            self.updateBorders()
        }
    }
    
    public var borderStyle: BorderStyle = BorderStyle(top: .None, bottom: .None) {
        didSet {
            self.updateBorders()
        }
    }
    
    lazy private var topBorder: UIView = {
        let view = self.buildBorder()
        view.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
        self.addSubview(view)
        return view
    }()

    lazy private var bottomBorder: UIView = {
        let view = self.buildBorder()
        view.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        var f = view.frame
        f.origin.y = self.bounds.size.height - self.borderThickness
        view.frame = f
        self.addSubview(view)
        return view
    }()
    
    private func buildBorder() -> UIView {
        let view = UIView()
        let x = self.borderInsets.left
        // frame will correctly updated later
        view.frame = CGRect(x: x, y: 0, width: 0, height: self.borderThickness)
        view.hidden = true
        return view
    }
    
    func updateBorders() {

        switch self.borderStyle.top {
        case .None:
            self.topBorder.hidden = true
        case .Always: 
            self.topBorder.hidden = false
        case .Auto:
            self.topBorder.hidden = !(self.listMembership == ListMembership.Contained(position: .Middle) || self.listMembership == ListMembership.Contained(position: .End))
        }
        
        switch self.borderStyle.bottom {
        case .None:
            self.bottomBorder.hidden = true
        case .Always:
            self.bottomBorder.hidden = false
        case .Auto:
            self.bottomBorder.hidden = true
        }
        
        for border in [self.bottomBorder, self.topBorder] {
            border.backgroundColor = self.borderColor
            var f = border.frame
            f.origin.x = self.borderInsets.left
            f.size.width = self.bounds.size.width - f.origin.x - self.borderInsets.right
            border.frame = f
        }
    }
    
    var defaultContentInsets:UIEdgeInsets {
        get {
            let side = self.separatorInset.left
            return UIEdgeInsets(top: self.layoutMargins.top, left: side, bottom: self.layoutMargins.bottom, right: side)
        }
    }
    
    public func useAppearance() -> Bool {
        return true
    }
    
    public dynamic var textLabelFont:UIFont? {
        get {
            return self.textLabel?.font
        }
        set {
            if self.useAppearance() {
                self.textLabel?.font = newValue
            }
        }
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setDefaults()
        self.buildView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setDefaults()
        self.buildView()
    }
    
    public func buildView() {
        self.clipsToBounds = true
        self.textLabel?.numberOfLines = 0
        self.textLabel?.lineBreakMode = .ByWordWrapping
        self.borderInsets = UIEdgeInsets(top: 0, left: self.defaultContentInsets.left, bottom: 0, right: 0)
        self.updateBorders()
    }
    
    public func setDefaults() {
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        self.stylize()
    }
    
    public func stylize() {
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.borderStyle = BorderStyle(top: .None, bottom: .None)
        self.accessoryType = .None
    }
    
    public override var frame:CGRect {
        set {
            var newFrame = newValue
            if let adjust = self.adjustFrame {
                newFrame = adjust(newFrame)
            }
            super.frame = newFrame
        }
        get {
            return super.frame
        }
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