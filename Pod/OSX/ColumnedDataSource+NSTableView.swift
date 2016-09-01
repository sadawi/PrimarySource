//
//  DataSource+NSTableView.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation
import Cocoa

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
            if let columnedItem = self.columnedCollectionItem(item) {
                result = self.buildView(tableView: tableView, tableColumn: tableColumn, item: columnedItem)
            }
        }
        return result
    }
    
    public func tableViewSelectionDidChange(notification: NSNotification) {
        self.selectionChangedHandler?(self.selectedTableValues)
    }
    
    var selectedTableValues: [AnyObject] {
        var results: [AnyObject] = []
        if let tableView = self.presenter as? NSTableView {
            for index in tableView.selectedRowIndexes {
                self.lookupRow(index) { item in
                    if let value = item.value {
                        results.append(value)
                    }
                }
            }
        }
        return results
    }


}