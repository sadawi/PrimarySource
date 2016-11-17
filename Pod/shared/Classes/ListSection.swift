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
open class ListSection<T:Equatable>: Section {
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
    public init(values:[T]?, title: String?=nil, key: String?=nil, reorderable: Bool?=nil, generator:@escaping ItemGenerator) {
        self.values = values ?? []
        self.generator = generator
        super.init(title: title, key: key, reorderable: reorderable)
        self.generateItems()
    }
    
    func generateItems() {
        var items:[CollectionItemType] = []
        for (i, value) in self.values.enumerated() {
            items.append(self.itemForValue(value, index: i))
        }
        self.items = items
    }
    
    func itemForValue(_ value: T, index:Int) -> CollectionItemType {
        return self.generator(value, index)
    }

    /**
     Removes a value from this section.
     */
    open func removeValueAtIndex(_ index:Int, updateView: Bool = false) {
        self.values.remove(at: index)
        self.items.remove(at: index)
        if updateView {
            if let indexPath = self.indexPathForIndex(index) {
                if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
                    animatablePresenter.removeItem(indexPath: indexPath, animation: .automatic)
                }
            }
        }
    }
    
    /**
     Removes a value from this section.
     
     - parameter value: The value to be removed
     - parameter updateView: Whether the value's corresponding item should be removed from the view
     */
    open func removeValue(_ value:T, updateView: Bool = false) {
        if let index = self.values.index(of: value) {
            self.removeValueAtIndex(index, updateView: updateView)
        }
    }
    
    /**
     Appends a value to this section.
     
     - parameter value: A new value
     - parameter updateView: Whether the value's corresponding item should be added to the view
     */
    open func addValue(_ value: T, updateView: Bool = false) -> Section {
        self.values.append(value)
        
        let index = self.itemCount
        let item = self.itemForValue(value, index: index)
        self.addItem(item)
        
        if updateView {
            if let indexPath = self.indexPathForIndex(index) {
                if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
                    animatablePresenter.insertItem(indexPath: indexPath, animation: .automatic)
                }
            }
        }
        
        return self
    }
}
