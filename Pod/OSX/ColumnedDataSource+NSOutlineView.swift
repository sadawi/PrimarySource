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
    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return self.children(item as AnyObject?).count > 0
    }
    public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        // TODO: Build a header item from the section if the presenter is an NSTableView
        return false
    }
    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return self.children(item as AnyObject?).count
    }
    
    func children(_ item: AnyObject?) -> [ColumnedCollectionItemType] {
        if item == nil {
            // TODO: section headers
            var result:[ColumnedCollectionItemType] = []
            for section in self.sections {
                result.append(contentsOf: section.items.map { $0 as? ColumnedCollectionItemType }.flatMap{$0})
            }
            return result
        } else if let item = self.columnedCollectionItem(item) {
            return item.children
        } else {
            return []
        }
    }

    public func outlineView(_ outlineView: NSOutlineView, columnSpanForItem item: AnyObject, column: NSTableColumn) -> Int {
        guard let collectionItem = self.columnedCollectionItem(item) else { return 1 }
        guard let columnItem = collectionItem[column.identifier] as? CollectionColumnItemType else { return 1 }
        return columnItem.columnSpan
    }
    
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item = self.columnedCollectionItem(item) else { return nil }
        return self.buildView(tableView: outlineView, tableColumn: tableColumn, item: item)
    }
    
    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return self.children(item as AnyObject?)[index]
    }
    
    public func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
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
    
    public func outlineViewSelectionDidChange(_ notification: Notification) {
        self.selectionChangedHandler?(self.selectedOutlineValues)
    }
    
    var selectedOutlineValues: [AnyObject] {
        var results: [AnyObject] = []
        if let outlineView = self.presenter as? NSOutlineView {
            for index in outlineView.selectedRowIndexes {
                if let item = outlineView.item(atRow: index) as? ColumnedCollectionItemType, let value = item.value {
                    results.append(value)
                }
            }
        }
        return results
    }
    
    public func outlineViewItemDidExpand(_ notification: Notification) {
        if let item = (notification as NSNotification).userInfo?["NSObject"] as? ColumnedCollectionItemType {
            item.didExpand()
        }
    }
    
    public func outlineViewItemDidCollapse(_ notification: Notification) {
        if let item = (notification as NSNotification).userInfo?["NSObject"] as? ColumnedCollectionItemType {
            item.didCollapse()
        }
    }
    
    public func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        if let item = self.columnedCollectionItem(item), let size = item.desiredSize?() {
            return size.height
        }
        return kDefaultRowHeight
    }

}
