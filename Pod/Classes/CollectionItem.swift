//
//  CollectionItem.swift
//  Pods
//
//  Created by Sam Williams on 11/23/15.
//
//

import Foundation

public typealias ItemAction = (CollectionItem -> Void)

public protocol ReusableItemType {
    var storyboardIdentifier:String? { get set }
    var nibName:String? { get set }
    
    var reuseIdentifier:String? { get }
    var viewType:AnyClass? { get }
    
    func configureView(view:UIView)
}

public protocol CollectionItem: ReusableItemType {
    var reorderable:Bool { get set }
    var onDelete:ItemAction? { get }
    var onTap:ItemAction? { get }
    var onAccessoryTap:ItemAction? { get }

    func onDelete(action: ItemAction) -> CollectionItem
    func handleDelete()
    
    func onTap(action: ItemAction) -> CollectionItem
    func handleTap()

    func onAccessoryTap(action: ItemAction) -> CollectionItem
    func handleAccessoryTap()
}

public class ReusableItem<ViewType:UIView>: ReusableItemType {
    var configure: (ViewType -> Void)?
    public var storyboardIdentifier:String?
    public var nibName:String?
    
    public var reuseIdentifier:String? {
        get {
            return storyboardIdentifier ?? generateReuseIdentifier()
        }
    }

    func generateReuseIdentifier() -> String {
        if let viewType = self.viewType {
            return NSStringFromClass(viewType)
        } else {
            return "CollectionItem"
        }
    }
    
    public var viewType:AnyClass? {
        return ViewType.self
    }
    
    public func configureView(view: UIView) {
        if let view = view as? ViewType {
            self.configureView(view)
        }
    }
    
    func configureView(view:ViewType) {
        if let configure = self.configure {
            configure(view)
        }
    }
    
}

public class TableViewItem<ViewType:UIView>: ReusableItem<ViewType>, CollectionItem {
    var key:String?
    
    public var reorderable:Bool = false

    public var onTap:ItemAction?
    public var onAccessoryTap:ItemAction?
    public var onDelete:ItemAction?
    
    public init(key:String?=nil, nibName:String?=nil, reorderable:Bool=false, storyboardIdentifier:String?=nil, configure:(ViewType -> Void)?=nil) {
        super.init()
        self.key = key
        self.nibName = nibName
        self.storyboardIdentifier = storyboardIdentifier
        self.configure = configure
        self.reorderable = reorderable
    }
    // MARK: - Actions

    public func onTap(action:ItemAction) -> CollectionItem {
        self.onTap = action
        return self
    }

    public func onAccessoryTap(action:ItemAction) -> CollectionItem {
        self.onAccessoryTap = action
        return self
    }

    public func onDelete(action:ItemAction) -> CollectionItem {
        self.onDelete = action
        return self
    }
    
    public func handleDelete() {
        self.onDelete?(self)
    }
    public func handleTap() {
        self.onTap?(self)
    }

    public func handleAccessoryTap() {
        self.onAccessoryTap?(self)
    }
}