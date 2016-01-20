//
//  ListSection.swift
//  Pods
//
//  Created by Sam Williams on 1/20/16.
//
//

import Foundation

public class ListSection<T:Equatable>: Section {
    public typealias ItemGenerator = ((T, Int) -> CollectionItem)
    
    var values: [T] = []
    var generator: ItemGenerator
    
    public init(values:[T], title: String?=nil, key: String?=nil, reorderable: Bool?=nil, generator:ItemGenerator) {
        self.values = values
        self.generator = generator
        super.init(title: title, key: key, reorderable: reorderable)
        self.generateItems()
    }
    
    func generateItems() {
        var items:[CollectionItem] = []
        for (i, value) in self.values.enumerate() {
            items.append(self.itemForValue(value, index: i))
        }
        self.items = items
    }
    
    func itemForValue(value: T, index:Int) -> CollectionItem {
        return self.generator(value, index)
    }
    
    var index:Int? {
        return self.dataSource?.indexOfSection(self)
    }
    
    public func removeValueAtIndex(index:Int, updateView: Bool = false) {
        self.values.removeAtIndex(index)
        self.items.removeAtIndex(index)
        if updateView {
            if let indexPath = self.indexPathForIndex(self.itemCount-1) {
                self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
    
    func indexPathForIndex(index:Int) -> NSIndexPath? {
        if let section = self.index {
            return NSIndexPath(forRow: index, inSection: section)
        } else {
            return nil
        }
    }
    
    public func addValue(value: T, updateView: Bool = false) -> Section {
        self.values.append(value)
        
        let index = self.itemCount
        let item = self.itemForValue(value, index: index)
        self.addItem(item)
        
        if updateView {
            if let indexPath = self.indexPathForIndex(index) {
                self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        
        return self
    }
}