//
//  CollectionItem.swift
//  Pods
//
//  Created by Sam Williams on 11/23/15.
//
//

import Foundation

public typealias ItemAction = ((CollectionItemType) -> Void)

public protocol CollectionItemType: class, ReusableItemType, ListMember {
    var reorderable:Bool { get set }
    var key: String? { get }
    var visible: Bool { get }
    var hasVisibilityCondition:Bool { get }
    var section: Section? { get set }
    var value: AnyObject? { get set }
    
    var deletable: Bool { get }
    var handlesDelete: Bool { get }
    var tappable: Bool { get }
    var isSelected: ((CollectionItemType)->Bool)? { get set }
    
    var desiredSize: ((Void) -> CGSize)? { get set }
    
    var editActionList: ActionList? { get set }
    
    func edit(_ configureActionList: ((CollectionItemType, ActionList)->())) -> CollectionItemType
    func delete(_ action: ItemAction) -> CollectionItemType
    func didDelete(_ action: ItemAction) -> CollectionItemType
    func willDelete(_ action: ItemAction) -> CollectionItemType
    func onTap(_ action: ItemAction) -> CollectionItemType
    func onAccessoryTap(_ action: ItemAction) -> CollectionItemType
    
    /**
     Sets a visibility condition for this collection item.
     
     The `visible` flag is set immediately, and will be updated again whenever the datasource's `refreshDisplay` method is called.
     
     - parameter condition: A closure determining whether this item should be visible or not.
     */
    func show(_ condition: ((Void) -> Bool)) -> CollectionItemType

    func delete()
    func didDelete()
    func willDelete()
    func onTap()
    func onAccessoryTap()
    
    /**
     Sets this item's `visible` flag to true, and animates it into the view.
     */
    func show()
    func show(animation: CollectionPresenterAnimation)

    /**
     Sets this item's `visible` flag to false, and animates it out of the view.
     */
    func hide()
    func hide(animation: CollectionPresenterAnimation)

    /**
     Reloads this item's view
     */
    func reload()
    func reload(animation: CollectionPresenterAnimation)

    
    /**
     Updates the visible state of this item, and propagates that to the view with the appropriate animation.
     */
    func updateVisibility(hideAnimation:CollectionPresenterAnimation, showAnimation:CollectionPresenterAnimation)
    
    var presenter: CollectionPresenter? { get }
}
