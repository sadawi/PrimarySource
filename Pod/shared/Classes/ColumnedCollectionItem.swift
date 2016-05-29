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
    
    // TODO: move this to CollectionItemType
    func configureIfNecessary()
    
    subscript(columnIdentifier: ColumnIdentifier) -> CollectionItemType? { get }
    
    func didCollapse()
    func didExpand()
    func reload(columnIdentifiers columnIdentifiers: [ColumnIdentifier], reloadChildren: Bool)
}

public class ColumnedCollectionItem<ViewType:CollectionItemView>: CollectionItem<ViewType>, ColumnedCollectionItemType {
    public typealias ItemConfiguration = ((ColumnedCollectionItem<ViewType>) -> ())
    public typealias ActionHandler = ((ColumnedCollectionItemType)->())
    
    var configureItem: ItemConfiguration? {
        didSet {
            self.needsConfiguration = true
        }
    }
    var needsConfiguration: Bool = true
    
    // Tree properties.  Not sure they belong here.
    weak public var parent:ColumnedCollectionItemType?
    public var children:[ColumnedCollectionItemType] = [] {
        didSet {
            for child in self.children {
                child.parent = self
            }
        }
    }
    var isExpanded: Bool = false
    
    var didExpandHandler:ActionHandler?
    var didCollapseHandler:ActionHandler?
    override public var presenter: CollectionPresenter? {
        return self.parent?.presenter ?? super.presenter
    }

    public func didCollapse() {
        self.didCollapseHandler?(self)
    }
    public func didExpand() {
        self.didExpandHandler?(self)
    }
    
    public func didCollapse(handler: ActionHandler) -> Self {
        self.didCollapseHandler = handler
        return self
    }

    public func didExpand(handler: ActionHandler) -> Self {
        self.didExpandHandler = handler
        return self
    }
    
    public var columns:[ColumnIdentifier:CollectionItemType] = [:]

    public init(key: String?=nil, nibName: String?=nil, reorderable: Bool=false, storyboardIdentifier: String?=nil, configureItem: ItemConfiguration?) {
        self.configureItem = configureItem
        super.init(key: key, nibName: nibName, reorderable: reorderable, storyboardIdentifier: storyboardIdentifier)
    }
    
    // TODO: rename this method
    public func configureIfNecessary() {
        guard self.needsConfiguration else { return }
        
        if let configure = self.configureItem {
            configure(self)
            self.needsConfiguration = false
        }
    }
    
    public subscript(columnIdentifier: ColumnIdentifier) -> CollectionItemType? {
        get {
            self.configureIfNecessary()
            return self.columns[columnIdentifier]
        }
        set {
            self.columns[columnIdentifier] = newValue
        }
    }
    
    public func reload(columnIdentifiers columnIdentifiers: [ColumnIdentifier], reloadChildren: Bool = false) {
        Swift.print("PRESENTER: ", self.presenter)
        if let columnPresenter = self.presenter as? ColumnReloadableCollectionPresenter {
            columnPresenter.reloadItem(self, columnIdentifiers: columnIdentifiers, reloadChildren: reloadChildren)
        }
    }

}