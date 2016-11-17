//
//  DataSource+Cocoa.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation
import Cocoa

extension ColumnedDataSource {
    func columnedCollectionItem(_ item: Any?) -> ColumnedCollectionItemType? {
        return item as? ColumnedCollectionItemType
    }

    func columnIdentifier(tableColumn: NSTableColumn?) -> ColumnIdentifier? {
        // TODO: should I round-trip this through the datasource's column list?
        return tableColumn?.identifier
    }
    
    func buildView(tableView: NSTableView, tableColumn: NSTableColumn?, item columnedItem: ColumnedCollectionItemType) -> NSView? {
        columnedItem.configureIfNecessary()
        
        var result: NSView?
        
        if let columnIdentifier = self.columnIdentifier(tableColumn: tableColumn), let cellItem = columnedItem[columnIdentifier] {
            if let identifier = cellItem.storyboardIdentifier {
                if let view = tableView.make(withIdentifier: identifier, owner: self) {
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
