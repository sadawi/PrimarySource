//
//  ListSection.swift
//  Pods
//
//  Created by Sam Williams on 1/20/16.
//
//

import Foundation

/**
 A collection section that is built from a list of objects.
 */
public class ListSection<T:Equatable>: Section {
    public typealias ItemGenerator = ((T, Int) -> CollectionItemType)
    
    var values: [T] = []
    var generator: ItemGenerator
    
    /**
     - parameter values: An array of item values from which to build this section.
     - parameter title: Section header title
     - parameter key: A unique identifier for this section, used to look up the section from its datasource.
     - parameter reorderable: Reorderability flag
     - parameter generator: A closure that generates a collection item from a value.
     */
    public init(values:[T]?, title: String?=nil, key: String?=nil, reorderable: Bool?=nil, generator:ItemGenerator) {
        self.values = values ?? []
        self.generator = generator
        super.init(title: title, key: key, reorderable: reorderable)
        self.generateItems()
    }
    
    func generateItems() {
        var items:[CollectionItemType] = []
        for (i, value) in self.values.enumerate() {
            items.append(self.itemForValue(value, index: i))
        }
        self.items = items
    }
    
    func itemForValue(value: T, index:Int) -> CollectionItemType {
        return self.generator(value, index)
    }

    /**
     Removes a value from this section.
     */
    public func removeValueAtIndex(index:Int, updateView: Bool = false) {
        self.values.removeAtIndex(index)
        self.items.removeAtIndex(index)
        if updateView {
            if let indexPath = self.indexPathForIndex(index) {
                self.presenter?.removeItem(indexPath: indexPath, animation: .Automatic)
            }
        }
    }
    
    /**
     Removes a value from this section.
     
     - parameter value: The value to be removed
     - parameter updateView: Whether the value's corresponding item should be removed from the view
     */
    public func removeValue(value:T, updateView: Bool = false) {
        if let index = self.values.indexOf(value) {
            self.removeValueAtIndex(index, updateView: updateView)
        }
    }
    
    /**
     Appends a value to this section.
     
     - parameter value: A new value
     - parameter updateView: Whether the value's corresponding item should be added to the view
     */
    public func addValue(value: T, updateView: Bool = false) -> Section {
        self.values.append(value)
        
        let index = self.itemCount
        let item = self.itemForValue(value, index: index)
        self.addItem(item)
        
        if updateView {
            if let indexPath = self.indexPathForIndex(index) {
                self.presenter?.insertItem(indexPath: indexPath, animation: .Automatic)
            }
        }
        
        return self
    }
}