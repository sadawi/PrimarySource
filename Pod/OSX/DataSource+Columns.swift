//
//  DataSource+Cocoa.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation
import Cocoa

extension DataSource {
    func columnedCollectionItem(item: AnyObject?) -> ColumnedCollectionItemType? {
        return item as? ColumnedCollectionItemType
    }

    func columnIdentifier(tableColumn tableColumn: NSTableColumn?) -> ColumnIdentifier? {
        // TODO: should I round-trip this through the datasource's column list?
        return tableColumn?.identifier
    }
    
    func buildView(tableView tableView: NSTableView, tableColumn: NSTableColumn?, item columnedItem: ColumnedCollectionItemType) -> NSView? {
        columnedItem.configureIfNecessary()
        
        var result: NSView?
        
        if let columnIdentifier = self.columnIdentifier(tableColumn: tableColumn), cellItem = columnedItem[columnIdentifier] {
            if let identifier = cellItem.storyboardIdentifier {
                if let view = tableView.makeViewWithIdentifier(identifier, owner: self) {
                    cellItem.configureView(view)
                    result = view
                }
            } else if let nibName = cellItem.nibName {
                // TODO: load from nib
            }
        }
        
        // TODO: error state?
        return result
    }
    
}