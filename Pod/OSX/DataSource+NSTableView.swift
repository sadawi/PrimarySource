//
//  DataSource+NSTableView.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation
import Cocoa

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


extension ColumnedDataSource: NSTableViewDataSource, NSTableViewDelegate {
    func columnForTableColumn(tableColumn: NSTableColumn?) -> Column? {
        if let identifier = tableColumn?.identifier {
            return self.columnForIdentifier(identifier)
        }
        return nil
    }
    
    func lookupRow(index: Int, ifSectionHeader:((Section)->())?=nil, ifItem:((CollectionItemType)->())?=nil) {
        var i = index
        
        for section in self.visibleSections {
            if section.lookupRow(offset: i, ifSectionHeader: ifSectionHeader, ifItem: ifItem) {
                return
            } else {
                let count = section.rowCount
                if i >= count {
                    i -= count
                } else {
                    return
                }
            }
        }
    }
    
    public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        var count = 0
        for section in self.visibleSections {
            if section.showsHeader {
                count += 1
            }
            count += section.visibleItems.count
        }
        return count
    }
    
    public func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        var isHeader = false
        self.lookupRow(row, ifSectionHeader: { _ in isHeader = true })
        return isHeader
    }
    
//    public func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
//        return nil
//        // TODO
//    }
    
    public func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var result: NSView?
        
        self.lookupRow(row) { item in
            if let columnedItem = item as? ColumnedCollectionItemType {
                columnedItem.configureIfNecessary()
                
                // TODO: should I round-trip this through the datasource's column list?
                if let columnIdentifier = tableColumn?.identifier, cellItem = columnedItem[columnIdentifier] {
                    if let identifier = cellItem.storyboardIdentifier {
                        if let view = tableView.makeViewWithIdentifier(identifier, owner: self) {
                            cellItem.configureView(view)
                            result = view
                        }
                    } else if let nibName = cellItem.nibName {
                        // TODO: load from nib
                    }
                }
            }
        }
        // TODO: error state?
        
        return result
    }
}