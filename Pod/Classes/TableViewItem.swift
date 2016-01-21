//
//  TableViewItem.swift
//  Pods
//
//  Created by Sam Williams on 1/20/16.
//
//

import Foundation

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
    
    public func show() {
        let oldIndexPath = self.indexPath
        self.visible = true
        let newIndexPath = self.indexPath
        if newIndexPath != nil && oldIndexPath == nil {
            self.tableView?.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    public func hide() {
        let oldIndexPath = self.indexPath
        self.visible = false
        let newIndexPath = self.indexPath
        if newIndexPath == nil && oldIndexPath != nil {
            self.tableView?.deleteRowsAtIndexPaths([oldIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    
    public func show(condition: (Void -> Bool)) -> CollectionItem {
        self.visibleCondition = condition
        self.visible = condition()
        return self
    }
    
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