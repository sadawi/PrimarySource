//
//  CollectionItem.swift
//  Pods
//
//  Created by Sam Williams on 11/23/15.
//
//

import Foundation

public typealias ItemAction = (CollectionItem -> Void)

public protocol CollectionItem {
    var storyboardIdentifier:String? { get set }
    var nibName:String? { get set }
    var reorderable:Bool { get set }
    
    var reuseIdentifier:String? { get }
    var viewType:AnyClass? { get }
    
    var onTap:ItemAction? { get }
    var onDelete:ItemAction? { get }
    
    func onTap(action: ItemAction) -> CollectionItem
    func onDelete(action: ItemAction) -> CollectionItem
    
    func handleTap()
    func handleDelete()
    func configureView(view:UIView)
}

public class TableViewItem<ViewType:UIView>: CollectionItem {
    var key:String?
    var configure: (ViewType -> Void)?
    
    
    public var reorderable:Bool = true

    public var onTap:ItemAction?
    public var onDelete:ItemAction?
    
    public var storyboardIdentifier:String?
    public var nibName:String?
    
    public var reuseIdentifier:String? {
        get {
            return storyboardIdentifier ?? generateReuseIdentifier()
        }
    }
    
    public init(key:String?=nil, nibName:String?=nil, storyboardIdentifier:String?=nil, configure:(ViewType -> Void)?=nil) {
        self.key = key
        self.nibName = nibName
        self.storyboardIdentifier = storyboardIdentifier
        self.configure = configure
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
    
    // MARK: - Actions

    public func onTap(action:ItemAction) -> CollectionItem {
        self.onTap = action
        return self
    }

    public func onDelete(action:ItemAction) -> CollectionItem {
        self.onDelete = action
        return self
    }
    
    public func handleDelete() {
        if let action = self.onDelete { action(self) }
    }
    public func handleTap() {
        if let action = self.onTap { action(self) }
    }
}