//
//  CollectionItem.swift
//  Pods
//
//  Created by Sam Williams on 1/20/16.
//
//

import Foundation

/**
 An option set representing relative positions in a list.  An item may be at the .Beginning or .End of a list, or both;
 if it is neither, it is considered to be in the .Middle.
*/
public struct ListPosition: OptionSetType, CustomStringConvertible {
    public let rawValue:Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let Middle    = ListPosition(rawValue: 0)
    public static let Beginning = ListPosition(rawValue: 1 << 1)
    public static let End       = ListPosition(rawValue: 1 << 2)
    
    public var description: String {
        var parts: [String] = []
        if self == .Middle {
            parts.append("middle")
        }
        if self.contains(.Beginning) {
            parts.append("beginning")
        }
        if self.contains(.End) {
            parts.append("end")
        }
        return parts.joinWithSeparator(", ")
    }
}

/**
 List membership determines whether this item participates in ListPosition tracking.  If it does not, consider it .NotContained.
 Otherwise, it is .Contained with an associated type of where in the list (or rather, sub-list of other contiguous .Contained items) it lives.
 */
public enum ListMembership: Equatable {
    case NotContained
    case Contained(position: ListPosition)
    
    public func addingPosition(addedPosition: ListPosition) -> ListMembership {
        switch self {
        case .NotContained:
            return self
        case .Contained(let position):
            return .Contained(position: position.union(addedPosition))
        }
    }
    
}
public func ==(left:ListMembership, right:ListMembership) -> Bool {
    switch (left, right) {
    case (.NotContained, .NotContained):
        return true
    case (.Contained(let leftPosition), .Contained(let rightPosition)):
        return leftPosition == rightPosition
    default:
        return false
    }
}

public protocol ListMember: class {
    var listMembership: ListMembership { get set }
}

public class CollectionItem<ViewType:UIView>: ReusableItem<ViewType>, CollectionItemType {
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
    
    public var listMembership = ListMembership.Contained(position: .Middle)
    
    public var desiredSize: (Void -> CGSize)?
    
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
    
    public func onTap(action:ItemAction) -> CollectionItemType {
        self.onTapAction = action
        return self
    }
    
    public func onAccessoryTap(action:ItemAction) -> CollectionItemType {
        self.onAccessoryTapAction = action
        return self
    }
    
    public func didDelete(action:ItemAction) -> CollectionItemType {
        self.didDeleteAction = action
        return self
    }
    
    public func delete(action:ItemAction) -> CollectionItemType {
        self.deleteAction = action
        return self
    }
    
    public func willDelete(action:ItemAction) -> CollectionItemType {
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
    
    var collectionView:UICollectionView? {
        return self.section?.collectionView
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
        self.show(animation: .Automatic)
    }
    
    public func show(animation animation: UITableViewRowAnimation) {
        let oldIndexPath = self.indexPath
        self.visible = true
        let newIndexPath = self.indexPath
        if newIndexPath != nil && oldIndexPath == nil {
            self.tableView?.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: animation)
            // TODO: collectionView
        }
    }
    
    public func hide() {
        self.hide(animation: .Automatic)
    }
    
    public func hide(animation animation: UITableViewRowAnimation) {
        let oldIndexPath = self.indexPath
        self.visible = false
        let newIndexPath = self.indexPath
        if newIndexPath == nil && oldIndexPath != nil {
            self.tableView?.deleteRowsAtIndexPaths([oldIndexPath!], withRowAnimation: animation)
            // TODO: collectionView
        }
    }
    
    
    public func show(condition: (Void -> Bool)) -> CollectionItemType {
        self.visibleCondition = condition
        self.visible = condition()
        return self
    }
    
    public func updateVisibility(hideAnimation hideAnimation:UITableViewRowAnimation, showAnimation:UITableViewRowAnimation) {
        if let condition = self.visibleCondition {
            let value = condition()
            if value {
                self.show(animation: showAnimation)
            } else {
                self.hide(animation: hideAnimation)
            }
        }
    }
    
    // MARK: - Configuration
    
    public override func configureView(view: UIView) {
        if let listMember = view as? ListMember {
            listMember.listMembership = self.listMembership
        }
        super.configureView(view)
    }
}