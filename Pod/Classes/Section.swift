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
    
    var key:String?
    var title:String?
    var reorderable:Bool = true
    var reorder:ReorderAction?
    
    weak var dataSource: DataSource?
    var tableView: UITableView? {
        return self.dataSource?.tableView
    }

    public var itemCount:Int {
        return self.items.count
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
        return self.items[index]
    }
    
    public subscript(index:Int) -> CollectionItem? {
        get {
            return self.itemAtIndex(index)
        }
    }
    
    public func eachItem(iterator: (CollectionItem -> Void)) {
        for item in self.items {
            iterator(item)
        }
    }
}
