//
//  Cocoa+CollectionPresenter.swift
//  Pods
//
//  Created by Sam Williams on 5/27/16.
//
//

import Foundation
import Cocoa

extension NSTableView: CollectionPresenter {
}

extension NSOutlineView: ColumnReloadableCollectionPresenter {
    public func reloadItem(item: AnyObject?, columnIdentifiers: [String], reloadChildren: Bool = false) {
        if let item = item {
            let row = self.rowForItem(item)
            let rowIndexes = NSIndexSet(index: row)
            for identifier in columnIdentifiers {
                let column = self.columnWithIdentifier(identifier)
                    let columnIndexes = NSIndexSet(index: column)
                    self.reloadDataForRowIndexes(rowIndexes, columnIndexes: columnIndexes)
            }
            
            if reloadChildren {
                // TODO: tell datasource to regenerate children, then reload
            }
        }
    }
}