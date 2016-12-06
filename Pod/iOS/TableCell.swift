//
//  TableCell.swift
//  Pods
//
//  Created by Sam Williams on 11/23/15.
//
//

import UIKit

public enum Visibility {
    case never
    case auto
    case always
}

public struct BorderStyle {
    public var top: Visibility = .never
    public var bottom: Visibility = .never
    
    public init(top: Visibility, bottom: Visibility) {
        self.top = top
        self.bottom = bottom
    }
}

protocol TappableTableCell {
    func handleTap()
}

open class TableCell: UITableViewCell, ListMember {
    internal weak var dataSource:DataSource?
    
    open var adjustFrame: ((CGRect)->CGRect)?
    open var showHighlight: ((_ highlighted: Bool, _ animated:Bool)->())? {
        didSet {
            if self.showHighlight == nil {
                self.selectionStyle = .default
            } else {
                self.selectionStyle = .none
            }
        }
    }
    
    fileprivate let borderThickness: CGFloat = 0.5
    open var borderInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.updateBorders()
        }
    }
    
    open var listMembership: ListMembership = .notContained {
        didSet {
            self.updateBorders()
        }
    }
    
    open dynamic var borderColor: UIColor = UIColor.lightGray {
        didSet {
            self.updateBorders()
        }
    }
    
    open var borderStyle: BorderStyle = BorderStyle(top: .never, bottom: .never) {
        didSet {
            self.updateBorders()
        }
    }
    
    lazy fileprivate var topBorder: UIView = {
        let view = self.buildBorder()
        view.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        self.addSubview(view)
        return view
    }()

    lazy fileprivate var bottomBorder: UIView = {
        let view = self.buildBorder()
        view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        var f = view.frame
        f.origin.y = self.bounds.size.height - self.borderThickness
        view.frame = f
        self.addSubview(view)
        return view
    }()
    
    fileprivate func buildBorder() -> UIView {
        let view = UIView()
        let x = self.borderInsets.left
        // frame will correctly updated later
        view.frame = CGRect(x: x, y: 0, width: 0, height: self.borderThickness)
        view.isHidden = true
        return view
    }
    
    func updateBorders() {

        switch self.borderStyle.top {
        case .never:
            self.topBorder.isHidden = true
        case .always: 
            self.topBorder.isHidden = false
        case .auto:
            self.topBorder.isHidden = !(self.listMembership == ListMembership.contained(position: .Middle) || self.listMembership == ListMembership.contained(position: .End))
        }
        
        switch self.borderStyle.bottom {
        case .never:
            self.bottomBorder.isHidden = true
        case .always:
            self.bottomBorder.isHidden = false
        case .auto:
            self.bottomBorder.isHidden = true
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
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if let showHighlight = self.showHighlight {
            showHighlight(highlighted, animated)
        } else {
            super.setHighlighted(highlighted, animated: animated)
        }
    }
    
    open func useAppearance() -> Bool {
        return true
    }
    
    open dynamic var textLabelFont:UIFont? {
        get {
            return self.textLabel?.font
        }
        set {
            if self.useAppearance() {
                self.textLabel?.font = newValue
            }
        }
    }
    
    open dynamic var textLabelColor:UIColor? {
        get {
            return self.textLabel?.textColor
        }
        set {
            if self.useAppearance() {
                self.textLabel?.textColor = newValue
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
    
    open func buildView() {
        self.clipsToBounds = true
        self.textLabel?.numberOfLines = 0
        self.textLabel?.lineBreakMode = .byWordWrapping
        self.borderInsets = UIEdgeInsets(top: 0, left: self.defaultContentInsets.left, bottom: 0, right: 0)
        self.updateBorders()
    }
    
    open func setDefaults() {
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        self.stylize()
    }
    
    open func stylize() {
        self.contentView.backgroundColor = .clear
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.borderStyle = BorderStyle(top: .never, bottom: .never)
        self.accessoryType = .none
    }
    
    open override var frame:CGRect {
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

open class SubtitleCell: TableCell {
    open dynamic var detailTextColor:UIColor? = UIColor(white: 0.5, alpha: 1)
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func stylize() {
        self.detailTextLabel?.textColor = self.detailTextColor
    }
}

open class ActivityIndicatorCell: TableCell {
    open var activityIndicator:UIActivityIndicatorView?
    
    override open func buildView() {
        super.buildView()
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
        activity.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin]
        self.contentView.addSubview(activity)
        self.activityIndicator = activity
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        self.activityIndicator?.startAnimating()
    }
}

open class ButtonCell: ContentCell {
    open var button:UIButton?
    
    open dynamic var buttonFont:UIFont?
    
    open var title:String? {
        set {
            self.button?.setTitle(newValue, for: UIControlState())
        }
        get {
            return self.button?.titleLabel?.text
        }
    }
    
    open override func buildContent() -> UIView {
        let button = UIButton(type: .custom)
        self.button = button
        return button
    }
    
    override open func buildView() {
        super.buildView()
        self.selectionStyle = .none
    }
    
    // Let the CollectionItem handle taps
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.bounds.contains(point) {
            return self
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    override open func stylize() {
        super.stylize()
        if let font = self.buttonFont {
            self.button?.titleLabel?.font = font
        }
        if self.button?.backgroundColor == nil || self.button?.backgroundColor == UIColor.clear || self.button?.backgroundColor == self.button?.titleColor(for: UIControlState()) {
            self.button?.setTitleColor(self.tintColor, for: UIControlState())
        }
    }
}
