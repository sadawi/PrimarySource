//
//  DataSource+NSOutlineView.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Cocoa

private let kDefaultRowHeight:CGFloat = 20

extension ColumnedDataSource: NSOutlineViewDelegate, OutlineViewDataSource {
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

    public func outlineView(outlineView: NSOutlineView, columnSpanForItem item: AnyObject, column: NSTableColumn) -> Int {
        guard let collectionItem = self.columnedCollectionItem(item) else { return 1 }
        guard let columnItem = collectionItem[column.identifier] as? CollectionColumnItemType else { return 1 }
        return columnItem.columnSpan
    }
    
    public func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        guard let item = self.columnedCollectionItem(item) else { return nil }
        return self.buildView(tableView: outlineView, tableColumn: tableColumn, item: item)
    }
    
    public func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        return self.children(item)[index]
    }
    
    public func outlineView(outlineView: NSOutlineView, rowViewForItem item: AnyObject) -> NSTableRowView? {
        guard let item = self.columnedCollectionItem(item) else { return nil }
        
        item.configureIfNecessary()
        
        var view: NSTableRowView?
        
        if let viewType = item.viewType as? NSTableRowView.Type {
            let itemView = viewType.init()
            item.configureView(itemView)
            view = itemView
        }
        return view
    }
    
    public func outlineViewSelectionDidChange(notification: NSNotification) {
        self.selectionChangedHandler?(self.selectedOutlineValues)
    }
    
    var selectedOutlineValues: [AnyObject] {
        var results: [AnyObject] = []
        if let outlineView = self.presenter as? NSOutlineView {
            for index in outlineView.selectedRowIndexes {
                if let item = outlineView.itemAtRow(index) as? ColumnedCollectionItemType, let value = item.value {
                    results.append(value)
                }
            }
        }
        return results
    }
    
    public func outlineViewItemDidExpand(notification: NSNotification) {
        if let item = notification.userInfo?["NSObject"] as? ColumnedCollectionItemType {
            item.didExpand()
        }
    }
    
    public func outlineViewItemDidCollapse(notification: NSNotification) {
        if let item = notification.userInfo?["NSObject"] as? ColumnedCollectionItemType {
            item.didCollapse()
        }
    }
    
    public func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
        if let item = self.columnedCollectionItem(item), size = item.desiredSize?() {
            return size.height
        }
        return kDefaultRowHeight
    }

}