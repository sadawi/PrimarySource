//
//  ColumnedCollectionItem.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation

public protocol ColumnedCollectionItemType: CollectionItemType {
    var columnSpan:Int { get }
    
    // TODO: move this to CollectionItemType
    func configureIfNecessary()
    
    subscript(columnIdentifier: ColumnIdentifier) -> CollectionItemType? { get }
}

public class ColumnedCollectionItem<ViewType:CollectionItemView>: CollectionItem<ViewType>, ColumnedCollectionItemType {
    public typealias ItemConfiguration = ((ColumnedCollectionItem<ViewType>) -> ())
    
    public var columnSpan:Int
    
    var configureItem: ItemConfiguration? {
        didSet {
            self.needsConfiguration = true
        }
    }
    var needsConfiguration: Bool = true
    
    public var columns:[ColumnIdentifier:CollectionItemType] = [:]

    public init(key: String?=nil, nibName: String?=nil, reorderable: Bool=false, storyboardIdentifier: String?=nil, columnSpan: Int=1, configureItem: ItemConfiguration?) {
        self.columnSpan = columnSpan
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
}