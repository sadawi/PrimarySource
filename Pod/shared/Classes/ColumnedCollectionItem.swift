//
//  ColumnedCollectionItem.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation

public protocol ColumnedCollectionItemType: CollectionItemType {
    // TODO: should this be its own category?
    var parent: ColumnedCollectionItemType? { get set }
    var children:[ColumnedCollectionItemType] { get }
    var buildChildren: ((ColumnedCollectionItemType)->[ColumnedCollectionItemType])? { get set }
    
    // TODO: move this to CollectionItemType
    func configureIfNecessary()
    
    subscript(columnIdentifier: ColumnIdentifier) -> CollectionItemType? { get }
    var isExpanded: Bool { get set }
    func didCollapse()
    func didExpand()
    func restoreExpansion()
    func reload(columnIdentifiers: [ColumnIdentifier], reloadChildren: Bool)
}

open class ColumnedCollectionItem<ViewType:CollectionItemView>: CollectionItem<ViewType>, ColumnedCollectionItemType {
    public typealias ItemConfiguration = ((ColumnedCollectionItem<ViewType>) -> ())
    public typealias ActionHandler = ((ColumnedCollectionItemType)->())
    
    var configureItem: ItemConfiguration? {
        didSet {
            self.needsConfiguration = true
        }
    }
    var needsConfiguration: Bool = true
    
    // Tree properties.  Not sure they belong here.
    weak open var parent:ColumnedCollectionItemType?
    
    open var buildChildren: ((ColumnedCollectionItemType)->[ColumnedCollectionItemType])?
    
    open var children: [ColumnedCollectionItemType] {
        get {
            if _children == nil {
                _children = self.buildChildren?(self) ?? []
            }
            return _children!
        }
        set {
            _children = newValue
        }
    }
    
    fileprivate var _children:[ColumnedCollectionItemType]? {
        didSet {
            if let children = self._children {
                for child in children {
                    child.parent = self
                }
            }
        }
    }
    open var isExpanded: Bool = false
    
    var didExpandHandler:ActionHandler?
    var didCollapseHandler:ActionHandler?
    override open var presenter: CollectionPresenter? {
        return self.parent?.presenter ?? super.presenter
    }

    open func didCollapse() {
        self.didCollapseHandler?(self)
    }
    open func didExpand() {
        self.didExpandHandler?(self)
    }
    
    open func didCollapse(_ handler: @escaping ActionHandler) -> Self {
        self.didCollapseHandler = handler
        return self
    }

    open func didExpand(_ handler: @escaping ActionHandler) -> Self {
        self.didExpandHandler = handler
        return self
    }
    
    open var columns:[ColumnIdentifier:CollectionItemType] = [:]

    public init(key: String?=nil, nibName: String?=nil, reorderable: Bool=false, storyboardIdentifier: String?=nil, configureItem: ItemConfiguration?) {
        self.configureItem = configureItem
        super.init(key: key, nibName: nibName, reorderable: reorderable, storyboardIdentifier: storyboardIdentifier)
    }
    
    // TODO: rename this method
    open func configureIfNecessary() {
        guard self.needsConfiguration else { return }
        
        if let configure = self.configureItem {
            configure(self)
            self.needsConfiguration = false
        }
    }
    
    open subscript(columnIdentifier: ColumnIdentifier) -> CollectionItemType? {
        get {
            self.configureIfNecessary()
            return self.columns[columnIdentifier]
        }
        set {
            self.columns[columnIdentifier] = newValue
        }
    }
    
    open func reload(columnIdentifiers: [ColumnIdentifier], reloadChildren: Bool = false) {
        if reloadChildren {
            // Forces a rebuild when `children` is accessed
            _children = nil
        }
        if let columnPresenter = self.presenter as? ColumnReloadableCollectionPresenter {
            columnPresenter.reloadItem(self, columnIdentifiers: columnIdentifiers, reloadChildren: reloadChildren)
            self.restoreExpansion()
        }
    }
    
    open func restoreExpansion() {
        self.needsConfiguration = true
        self.configureIfNecessary()
        
        if let expandablePresenter = self.presenter as? ExpandableCollectionPresenter {
            if self.isExpanded {
                expandablePresenter.expandItem(self)
                for child in self.children {
                    child.restoreExpansion()
                }
            }
        }
    }

}
