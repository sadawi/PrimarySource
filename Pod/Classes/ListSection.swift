//
//  ListSection.swift
//  Pods
//
//  Created by Sam Williams on 1/20/16.
//
//

import Foundation

public class ListSection<T:Equatable>: Section {
    public typealias ItemGenerator = (T -> CollectionItem?)
    
    var values: [T] = []
    var generator: ItemGenerator
    
    public init(values:[T], title: String?=nil, key: String?=nil, reorderable: Bool?=nil, generator:ItemGenerator) {
        self.values = values
        self.generator = generator
        super.init(title: title, key: key, reorderable: reorderable)
        self.generateItems()
    }
    
    func generateItems() {
        self.items = self.values.map { self.itemForValue($0) }.flatMap { $0 }
    }
    
    func itemForValue(value: T) -> CollectionItem? {
        return self.generator(value)
    }
    
    var index:Int? {
        return self.dataSource?.indexOfSection(self)
    }
    
    public func addValue(value: T, updateView: Bool = false) -> Section {
        self.values.append(value)
        
        if let item = self.itemForValue(value) {
            self.addItem(item)
            
            if updateView {
                let row = self.itemCount - 1
                if let section = self.index {
                    let indexPath = NSIndexPath(forRow: row, inSection: section)
                    self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        
        }
        return self
    }
}