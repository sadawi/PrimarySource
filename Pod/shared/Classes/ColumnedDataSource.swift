//
//  ColumnedDataSource.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation


public func <<<(dataSource:ColumnedDataSource, column:Column) {
    dataSource.addColumn(column)
}

public func <<<(dataSource:ColumnedDataSource, column:Column?) {
    if let column = column {
        dataSource.addColumn(column)
    }
}


open class ColumnedDataSource: DataSource {
    fileprivate(set) var columns: [Column] = []
    var columnLookup: [ColumnIdentifier:Column] = [:]
    
    open func addColumn(_ column: Column) {
        self.columns.append(column)
        self.columnLookup[column.identifier] = column
    }
    
    func columnForIdentifier(_ identifier: ColumnIdentifier) -> Column? {
        return self.columnLookup[identifier]
    }
    
    func present() {
        self.presenter?.reloadData()
        
        if self.presenter is ExpandableCollectionPresenter {
            for section in self.sections {
                for item in section.items {
                    // This is weird.  Why is it columned?  Probably should make another protocol for expandable items.
                    if let item = item as? ColumnedCollectionItemType {
                        item.restoreExpansion()
                    }
                }
            }
        }
    }
}
