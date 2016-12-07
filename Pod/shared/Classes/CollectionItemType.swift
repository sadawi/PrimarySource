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
    
    @discardableResult func edit(_ configureActionList: @escaping ((CollectionItemType, ActionList)->())) -> CollectionItemType
    @discardableResult func delete(_ action: @escaping ItemAction) -> CollectionItemType
    @discardableResult func didDelete(_ action: @escaping ItemAction) -> CollectionItemType
    @discardableResult func willDelete(_ action: @escaping ItemAction) -> CollectionItemType
    @discardableResult func onTap(_ action: @escaping ItemAction) -> CollectionItemType
    @discardableResult func onAccessoryTap(_ action: @escaping ItemAction) -> CollectionItemType
    
    /**
     Sets a visibility condition for this collection item.
     
     The `visible` flag is set immediately, and will be updated again whenever the datasource's `refreshDisplay` method is called.
     
     - parameter condition: A closure determining whether this item should be visible or not.
     */
    func show(_ condition: @escaping ((Void) -> Bool)) -> CollectionItemType

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

