//
//  Section.swift
//  CollectionDataSource
//
//  Created by Sam Williams on 11/23/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation

public typealias ReorderAction = ((NSIndexPath, NSIndexPath) -> Void)

public class Section {
    var key:String?
    var title:String?
    var items:[CollectionItem] = []
    var reorderable:Bool = false
    var reorder:ReorderAction?
    
    public init(title:String?=nil, key:String?=nil, configure:(Section -> Void)?=nil) {
        self.title = title
        self.key = key
        if let configure = configure {
            configure(self)
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
        self.reorder = reorder
        return self
    }
}

infix operator <<< { associativity left precedence 95 }
public func <<<(left:Section, right:CollectionItem) {
    left.addItem(right)
}