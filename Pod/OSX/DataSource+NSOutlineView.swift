//
//  DataSource+NSOutlineView.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Cocoa

extension ColumnedDataSource: NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    public func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return self.children(item).count > 0
    }
    public func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
        // TODO: Build a header item from the section if the presenter is an NSTableView
        return false
    }
    public func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        return self.children(item).count
    }
    
    func children(item: AnyObject?) -> [ColumnedCollectionItemType] {
        if item == nil {
            // TODO: section headers
            var result:[ColumnedCollectionItemType] = []
            for section in self.sections {
                result.appendContentsOf(section.items.map { $0 as? ColumnedCollectionItemType }.flatMap{$0})
            }
            return result
        } else if let item = self.columnedCollectionItem(item) {
            return item.children
        } else {
            return []
        }
    }
    
//    public func outlineView(outlineView: NSOutlineView, rowViewForItem item: AnyObject) -> NSTableRowView? {
//        return nil
//    }
    
    public func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        guard let item = self.columnedCollectionItem(item) else { return nil }
        return self.buildView(tableView: outlineView, tableColumn: tableColumn, item: item)
    }
    
    public func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        return self.children(item)[index]
    }
    
//    public func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
//    }
}