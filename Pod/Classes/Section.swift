//
//  Section.swift
//  PrimarySource
//
//  Created by Sam Williams on 11/23/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation

public typealias ReorderAction = ((NSIndexPath, NSIndexPath) -> Void)

public class Section {
    var items:[CollectionItem] = []
    var visibleItems:[CollectionItem] {
        return self.items.filter { $0.visible }
    }
    
    var itemLookup: [String: CollectionItem] = [:]
    
    var key:String?
    var title:String?
    var reorderable:Bool = true
    var reorder:ReorderAction?
    
    weak var dataSource: DataSource?
    var tableView: UITableView? {
        return self.dataSource?.tableView
    }

    public var itemCount:Int {
        return self.visibleItems.count
    }
    
    public var header:HeaderItemType?
    
    public init(title:String?=nil, key:String?=nil, reorderable:Bool?=nil, configure:(Section -> Void)?=nil) {
        self.title = title
        self.key = key
        if let configure = configure {
            configure(self)
        }
        if let reorderable = reorderable {
            self.reorderable = reorderable
        }
    }
    
    public func addItem(item:CollectionItem) -> Section {
        self.items.append(item)
        if let key = item.key {
            self.itemLookup[key] = item
        }
        item.section = self
        return self
    }
    
    public func deleteItemAtIndex(index:Int) {
        self.items.removeAtIndex(index)
    }
    
    public func handleReorder(fromIndexPath fromIndexPath:NSIndexPath, toIndexPath:NSIndexPath) {
        guard self.reorderable else { return }
        if let reorder = self.reorder {
            reorder(fromIndexPath, toIndexPath)
        }
    }
    
    public func onReorder(reorder:ReorderAction) -> Section {
        self.reorderable = true
        self.reorder = reorder
        return self
    }
    
    public func itemAtIndex(index:Int) -> CollectionItem? {
        return self.visibleItems[index]
    }
    
    public func itemForKey(key:String) -> CollectionItem? {
        return self.itemLookup[key]
    }
    
    public subscript(index:Int) -> CollectionItem? {
        get {
            return self.itemAtIndex(index)
        }
    }
    
    public subscript(key:String) -> CollectionItem? {
        get {
            return self.itemForKey(key)
        }
    }
    
    public func eachItem(iterator: (CollectionItem -> Void)) {
        for item in self.visibleItems {
            iterator(item)
        }
    }
    
    // MARK: - Indices
    
    func indexOfItem(item: CollectionItem) -> Int? {
        return self.visibleItems.indexOf { $0 === item }
    }
    
    var index:Int? {
        return self.dataSource?.indexOfSection(self)
    }
    
    func indexPathForIndex(index:Int) -> NSIndexPath? {
        if let section = self.index {
            return NSIndexPath(forRow: index, inSection: section)
        } else {
            return nil
        }
    }
    

}
