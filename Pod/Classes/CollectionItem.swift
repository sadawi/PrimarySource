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

public protocol CollectionItem: class, ReusableItemType {
    var reorderable:Bool { get set }
    var key: String? { get }
    var visible: Bool { get }
    var section: Section? { get set }
    
    var deletable: Bool { get }
    var handlesDelete: Bool { get }
    var tappable: Bool { get }

    func delete(action: ItemAction) -> CollectionItem
    func didDelete(action: ItemAction) -> CollectionItem
    func willDelete(action: ItemAction) -> CollectionItem
    func onTap(action: ItemAction) -> CollectionItem
    func onAccessoryTap(action: ItemAction) -> CollectionItem
    func show(condition: (Void -> Bool)) -> CollectionItem

    func delete()
    func didDelete()
    func willDelete()
    func onTap()
    func onAccessoryTap()
    
    func show()
    func hide()
    func updateVisibility()
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
    weak public var section: Section?
    
    internal(set) public var key:String?
    internal(set) public var visible: Bool = true

    var visibleCondition:(Void -> Bool)?
    
    public var reorderable:Bool = false

    var onTapAction:ItemAction?
    var onAccessoryTapAction:ItemAction?
    var deleteAction:ItemAction?
    var didDeleteAction:ItemAction?
    var willDeleteAction:ItemAction?
    
    public var handlesDelete: Bool {
        return self.deleteAction != nil
    }
    
    public var deletable: Bool {
        return self.deleteAction != nil || self.willDeleteAction != nil || self.didDeleteAction != nil
    }
    
    public var tappable: Bool {
        return self.onTapAction != nil
    }
    
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
    
    // MARK: - Indices etc.
    
    var tableView:UITableView? {
        return self.section?.tableView
    }
    
    var index:Int? {
        return self.section?.indexOfItem(self)
    }
    
    /**
     The indexPath of this item in its collection/table view, if possible.
     */
    public var indexPath: NSIndexPath? {
        if let index = self.index {
            return self.section?.indexPathForIndex(index)
        } else {
            return nil
        }
    }
    
    // MARK: - Visibility
    
    /**
    Sets this item's `visible` flag to true, and animates it into the view.
    */
    public func show() {
        let oldIndexPath = self.indexPath
        self.visible = true
        let newIndexPath = self.indexPath
        if newIndexPath != nil && oldIndexPath == nil {
            self.tableView?.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    /**
     Sets this item's `visible` flag to false, and animates it out of the view.
     */
    public func hide() {
        let oldIndexPath = self.indexPath
        self.visible = false
        let newIndexPath = self.indexPath
        if newIndexPath == nil && oldIndexPath != nil {
            self.tableView?.deleteRowsAtIndexPaths([oldIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    
    /**
     Sets a visibility condition for this collection item.
     
     The `visible` flag is set immediately, and will be updated again whenever the datasource's `refreshDisplay` method is called.
     
     - parameter condition: A closure determining whether this item should be visible or not.
     */
    public func show(condition: (Void -> Bool)) -> CollectionItem {
        self.visibleCondition = condition
        self.visible = condition()
        return self
    }
    
    /**
     Updates the visible state of this item, and propagates that to the view with the appropriate animation.
     */
    public func updateVisibility() {
        if let condition = self.visibleCondition {
            let value = condition()
            if value {
                self.show()
            } else {
                self.hide()
            }
        }
    }

}