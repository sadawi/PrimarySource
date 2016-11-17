//
//  Section.swift
//  PrimarySource
//
//  Created by Sam Williams on 11/23/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation

public typealias ReorderAction = ((IndexPath, IndexPath) -> Void)

public func <<<(section:Section, item:CollectionItemType) {
    section.addItem(item)
}

public func <<<(section:Section, item:CollectionItemType?) {
    if let item = item {
        section.addItem(item)
    }
}

public func <<<(section:Section, items:[CollectionItemType]) {
    for item in items {
        section.addItem(item)
    }
}

open class Section {
    var visible: Bool = true
    var visibleCondition:((Void) -> Bool)?
    
    var items:[CollectionItemType] = []
    var visibleItems:[CollectionItemType] {
        return self.items.filter { $0.visible }
    }
    
    var itemLookup: [String: CollectionItemType] = [:]
    
    var key:String?
    var title:String?
    var reorderable:Bool = true
    var reorder:ReorderAction?
    var didSetListPositions = false
    
    open weak var dataSource: DataSource?
    var presenter: CollectionPresenter? {
        return self.dataSource?.presenter
    }
    
    var showsHeader: Bool {
        return self.title != nil || self.header != nil
    }

    open var itemCount:Int {
        return self.visibleItems.count
    }
    
    open var header:HeaderItemType?
    
    public init(title:String?=nil, key:String?=nil, reorderable:Bool?=nil, configure:((Section) -> Void)?=nil) {
        self.title = title
        self.key = key
        if let configure = configure {
            configure(self)
        }
        if let reorderable = reorderable {
            self.reorderable = reorderable
        }
    }
    
    open func addItem(_ item:CollectionItemType) -> Section {
        self.items.append(item)
        if let key = item.key {
            self.itemLookup[key] = item
        }
        item.section = self
        self.didSetListPositions = false
        return self
    }
    
    func setListPositionsIfNeeded() {
        if !self.didSetListPositions {
            self.setListPositions()
        }
    }
    
    /**
     Go through the visible items in the section and assign list positions.  That is, tell the items whether they are at the .Beginning
     or .End (or both) of their list.
     
     Items whose list membership is set to .NotContained will be considered terminators; any items immediately before or after them
     will be given positions .End or .Beginning, respectively.
     */
    func setListPositions() {
        var start = true
        for (i, item) in self.visibleItems.enumerated() {
            switch item.listMembership {
            case .notContained:
                start = true
            case .contained:
                var position:ListPosition = .Middle
                
                if start {
                    position = position.union(.Beginning)
                }
                var end = false
                if i+1 < self.itemCount {
                    let next = self.visibleItems[i+1]
                    if next.listMembership == .notContained {
                        end = true
                    }
                }
                if i+1 == self.itemCount {
                    end = true
                }
                if end {
                    position = position.union(.End)
                }
                
                item.listMembership = ListMembership.contained(position: position)
                start = false
            }
        }
        self.didSetListPositions = true
    }
    
    open func deleteItemAtIndex(_ index:Int) {
        self.items.remove(at: index)
    }
    
    open func handleReorder(fromIndexPath:IndexPath, toIndexPath:IndexPath) {
        guard self.reorderable else { return }
        if let reorder = self.reorder {
            reorder(fromIndexPath, toIndexPath)
        }
    }
    
    open func onReorder(_ reorder:@escaping ReorderAction) -> Section {
        self.reorderable = true
        self.reorder = reorder
        return self
    }
    
    open func itemAtIndex(_ index:Int) -> CollectionItemType? {
        self.setListPositionsIfNeeded()
        if self.visibleItems.count > index {
            return self.visibleItems[index]
        } else {
            return nil
        }
    }
    
    open func itemForKey(_ key:String) -> CollectionItemType? {
        self.setListPositionsIfNeeded()
        return self.itemLookup[key]
    }
    
    open subscript(index:Int) -> CollectionItemType? {
        get {
            return self.itemAtIndex(index)
        }
    }
    
    open subscript(key:String) -> CollectionItemType? {
        get {
            return self.itemForKey(key)
        }
    }
    
    open func eachItem(includeHidden:Bool = false, iterator: ((CollectionItemType) -> Void)) {
        self.setListPositionsIfNeeded()
        if includeHidden {
            for item in self.items {
                iterator(item)
            }
        } else {
            for item in self.visibleItems {
                iterator(item)
            }
        }
    }
    
    // MARK: - Indices
    
    func index(of item: CollectionItemType) -> Int? {
        return self.visibleItems.index { $0 === item }
    }
    
    var index:Int? {
        return self.dataSource?.index(of: self)
    }
    
    func indexPath(index:Int) -> IndexPath? {
        if let section = self.index {
//            return IndexPath(item: index, section: section)
            return IndexPath(row: index, section: section)
        } else {
            return nil
        }
    }
    
    // MARK: - 
    
    open func refreshDisplay(sectionHideAnimation:CollectionPresenterAnimation = .fade,
                                                    sectionShowAnimation:CollectionPresenterAnimation = .fade,
                                                    rowHideAnimation:CollectionPresenterAnimation = .automatic,
                                                    rowShowAnimation:CollectionPresenterAnimation = .automatic
        ) {
        self.updateVisibility(hideAnimation: sectionHideAnimation, showAnimation: sectionShowAnimation)
        if self.visible {
            for item in self.items {
                item.updateVisibility(hideAnimation: rowHideAnimation, showAnimation: rowShowAnimation)
            }
        }
    }

    // MARK: - Visibility
    
    open func show(animation:CollectionPresenterAnimation = .fade) {
        if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
            let oldIndex = self.index
            self.visible = true
            let newIndex = self.index
            if newIndex != nil && oldIndex == nil {
                animatablePresenter.insertSection(index: newIndex!, animation: animation)
            }
        }
    }
    
    open func hide(animation:CollectionPresenterAnimation = .fade) {
        if let animatablePresenter = self.presenter as? AnimatableCollectionPresenter {
            let oldIndex = self.index
            self.visible = false
            let newIndex = self.index
            if newIndex == nil && oldIndex != nil {
                animatablePresenter.removeSection(index: oldIndex!, animation: animation)
            }
        }
    }
    
    open func show(_ condition: @escaping ((Void) -> Bool)) -> Section {
        self.visibleCondition = condition
        self.visible = condition()
        return self
    }
    
    open func updateVisibility(hideAnimation:CollectionPresenterAnimation = .fade, showAnimation:CollectionPresenterAnimation = .fade) {
        if let condition = self.visibleCondition {
            let value = condition()
            if value {
                self.show(animation: showAnimation)
            } else {
                self.hide(animation: hideAnimation)
            }
        }
    }

}
