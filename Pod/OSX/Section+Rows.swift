//
//  Section+Rows.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation

extension Section {
    func lookupRow(offset offset: Int, ifSectionHeader:((Section)->())?=nil, ifItem:((CollectionItemType)->())?=nil) -> Bool {
        if self.showsHeader {
            if offset == 0 {
                ifSectionHeader?(self)
                return true
            } else {
                if let item = self.itemAtIndex(offset-1) {
                    ifItem?(item)
                    return true
                }
            }
        } else if let item = self.itemAtIndex(offset) {
            ifItem?(item)
            return true
        }
        return false
    }
    var rowCount: Int {
        var count = self.visibleItems.count
        if self.showsHeader {
            count += 1
        }
        return count
    }
}
