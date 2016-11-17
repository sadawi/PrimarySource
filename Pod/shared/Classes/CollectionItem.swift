//
//  CollectionItem.swift
//  Pods
//
//  Created by Sam Williams on 1/20/16.
//
//

import Foundation

open class CollectionItem<ViewType:CollectionItemView>: ReusableItem<ViewType>, CollectionItemType {
    weak open var section: Section?
    
    internal(set) open var key:String?
    internal(set) open var visible: Bool = true

    open var value: AnyObject?
    
    var visibleCondition:((Void) -> Bool)?
    
    open var hasVisibilityCondition:Bool {
        return self.visibleCondition != nil
    }
    
    open var reorderable:Bool = false
    
    open var isSelected: ((CollectionItemType)->Bool)?
    
    var onTapAction:ItemAction?
    var onAccessoryTapAction:ItemAction?
    var deleteAction:ItemAction?
    var didDeleteAction:ItemAction?
    var willDeleteAction:ItemAction?
    
    open var editActionList: ActionList?
    
    open var listMembership = ListMembership.contained(position: .Middle)
    
    open var desiredSize: ((Void) -> CGSize)?
    
    open var handlesDelete: Bool {
        return self.deleteAction != nil
    }
    
    open var deletable: Bool {
        return self.deleteAction != nil || self.willDeleteAction != nil || self.didDeleteAction != nil
    }
    
    open var tappable: Bool {
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
    
    open func onTap(_ action:@escaping ItemAction) -> CollectionItemType {
        self.onTapAction = action
        return self
    }
    
    open func onAccessoryTap(_ action:@escaping ItemAction) -> CollectionItemType {
        self.onAccessoryTapAction = action
        return self
    }
    
    open func didDelete(_ action:@escaping ItemAction) -> CollectionItemType {
        self.didDeleteAction = action
        return self
    }
    
    open func delete(_ action:@escaping ItemAction) -> CollectionItemType {
        self.deleteAction = action
        return self
    }
    
    open func willDelete(_ action:@escaping ItemAction) -> CollectionItemType {
        self.willDeleteAction = action
        return self
    }
    
    open func edit(_ configureActionList: ((CollectionItemType, ActionList)->())) -> CollectionItemType {
        let actionList = ActionList()
        self.editActionList = actionList
        
        // TODO: might call this later, not sure
        configureActionList(self, actionList)
        
        return self
    }
    
    // MARK: - Handling actions
    
    open func onTap() {
        self.onTapAction?(self)
    }
    
    open func onAccessoryTap() {
        self.onAccessoryTapAction?(self)
    }
    
    open func delete() {
        self.deleteAction?(self)
    }
    
    open func didDelete() {
        self.didDeleteAction?(self)
    }
    
    open func willDelete() {
        self.willDeleteAction?(self)
    }
    
    // MARK: - Indices etc.
    
    open var presenter: CollectionPresenter? {
        return self.section?.presenter
    }
    
    var index:Int? {
        return self.section?.indexOfItem(self)
    }
    
    /**
     The indexPath of this item in its collection/table view, if possible.
     */
    open var indexPath: IndexPath? {
        if let index = self.index {
            return self.section?.indexPathForIndex(index)
        } else {
            return nil
        }
    }
    
    open func reload() {
        self.reload(animation: .automatic)
    }
    
    open func reload(animation: CollectionPresenterAnimation) {
        if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
            if let indexPath = self.indexPath {
                animatablePresenter.reloadItem(indexPath: indexPath, animation: animation)
            }
        }
    }
    
    // MARK: - Visibility
    open func show() {
        self.show(animation: .automatic)
    }
    
    open func show(animation: CollectionPresenterAnimation) {
        if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
            let oldIndexPath = self.indexPath
            self.visible = true
            let newIndexPath = self.indexPath
            if newIndexPath != nil && oldIndexPath == nil {
                animatablePresenter.insertItem(indexPath: newIndexPath!, animation: animation)
            }
        }
    }
    
    open func hide() {
        self.hide(animation: .automatic)
    }
    
    open func hide(animation: CollectionPresenterAnimation) {
        if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
            let oldIndexPath = self.indexPath
            self.visible = false
            let newIndexPath = self.indexPath
            if newIndexPath == nil && oldIndexPath != nil {
                animatablePresenter.removeItem(indexPath: oldIndexPath!, animation: animation)
            }
        }
    }
    
    open func show(_ condition: @escaping ((Void) -> Bool)) -> CollectionItemType {
        self.visibleCondition = condition
        self.visible = condition()
        return self
    }
    
    open func updateVisibility(hideAnimation:CollectionPresenterAnimation, showAnimation:CollectionPresenterAnimation) {
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
    
    open override func configureView(_ view: CollectionItemView) {
        if let listMember = view as? ListMember {
            listMember.listMembership = self.listMembership
        }
        super.configureView(view)
    }
}
