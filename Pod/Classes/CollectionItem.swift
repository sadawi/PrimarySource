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
    
    var deleteAction:ItemAction? { get }
    var didDeleteAction:ItemAction? { get }
    var willDeleteAction:ItemAction? { get }
    var onTapAction:ItemAction? { get }
    var onAccessoryTapAction:ItemAction? { get }

    func delete(action: ItemAction) -> CollectionItem
    func didDelete(action: ItemAction) -> CollectionItem
    func willDelete(action: ItemAction) -> CollectionItem
    func onTap(action: ItemAction) -> CollectionItem
    func onAccessoryTap(action: ItemAction) -> CollectionItem

    func delete()
    func didDelete()
    func willDelete()
    func onTap()
    func onAccessoryTap()
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

    public var onTapAction:ItemAction?
    public var onAccessoryTapAction:ItemAction?
    public var deleteAction:ItemAction?
    public var didDeleteAction:ItemAction?
    public var willDeleteAction:ItemAction?
    
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
        self.onTapAction = action
        return self
    }
    
    public func onAccessoryTap(action:ItemAction) -> CollectionItem {
        self.onAccessoryTapAction = action
        return self
    }
    
    public func didDelete(action:ItemAction) -> CollectionItem {
        self.didDeleteAction = action
        return self
    }
    
    public func delete(action:ItemAction) -> CollectionItem {
        self.deleteAction = action
        return self
    }
    
    public func willDelete(action:ItemAction) -> CollectionItem {
        self.willDeleteAction = action
        return self
    }
    
    // MARK: - Handling actions
    
    public func onTap() {
        self.onTapAction?(self)
    }
    
    public func onAccessoryTap() {
        self.onAccessoryTapAction?(self)
    }

    public func delete() {
        self.deleteAction?(self)
    }
    
    public func didDelete() {
        self.didDeleteAction?(self)
    }
    
    public func willDelete() {
        self.willDeleteAction?(self)
    }
}