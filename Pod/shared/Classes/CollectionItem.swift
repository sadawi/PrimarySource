//
//  CollectionItem.swift
//  Pods
//
//  Created by Sam Williams on 1/20/16.
//
//

import Foundation

public class CollectionItem<ViewType:CollectionItemView>: ReusableItem<ViewType>, CollectionItemType {
    weak public var section: Section?
    
    internal(set) public var key:String?
    internal(set) public var visible: Bool = true

    public var value: AnyObject?
    
    var visibleCondition:(Void -> Bool)?
    
    public var hasVisibilityCondition:Bool {
        return self.visibleCondition != nil
    }
    
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
    
    public init(key:String?=nil, nibName:String?=nil, reorderable:Bool=false, storyboardIdentifier:String?=nil, configure:ViewConfiguration?=nil) {
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
    
    public var presenter: CollectionPresenter? {
        return self.section?.presenter
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
    
    public func reload() {
        self.reload(animation: .Automatic)
    }
    
    public func reload(animation animation: CollectionPresenterAnimation) {
        if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
            if let indexPath = self.indexPath {
                animatablePresenter.reloadItem(indexPath: indexPath, animation: animation)
            }
        }
    }
    
    // MARK: - Visibility
    public func show() {
        self.show(animation: .Automatic)
    }
    
    public func show(animation animation: CollectionPresenterAnimation) {
        if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
            let oldIndexPath = self.indexPath
            self.visible = true
            let newIndexPath = self.indexPath
            if newIndexPath != nil && oldIndexPath == nil {
                animatablePresenter.insertItem(indexPath: newIndexPath!, animation: animation)
            }
        }
    }
    
    public func hide() {
        self.hide(animation: .Automatic)
    }
    
    public func hide(animation animation: CollectionPresenterAnimation) {
        if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
            let oldIndexPath = self.indexPath
            self.visible = false
            let newIndexPath = self.indexPath
            if newIndexPath == nil && oldIndexPath != nil {
                animatablePresenter.removeItem(indexPath: oldIndexPath!, animation: animation)
            }
        }
    }
    
    public func show(condition: (Void -> Bool)) -> CollectionItemType {
        self.visibleCondition = condition
        self.visible = condition()
        return self
    }
    
    public func updateVisibility(hideAnimation hideAnimation:CollectionPresenterAnimation, showAnimation:CollectionPresenterAnimation) {
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
    
    public override func configureView(view: CollectionItemView) {
        if let listMember = view as? ListMember {
            listMember.listMembership = self.listMembership
        }
        super.configureView(view)
    }
}