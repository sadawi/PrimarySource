//
//  Section.swift
//  CollectionDataSource
//
//  Created by Sam Williams on 11/23/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}

public class Section {
    var key:String?
    var title:String?
    var items:[CollectionItem] = []
    
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
}

infix operator <<< { associativity left precedence 95 }
public func <<<(left:Section, right:CollectionItem) {
    left.addItem(right)
}