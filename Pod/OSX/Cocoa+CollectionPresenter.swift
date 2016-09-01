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
//                self.reloadData()
                // TODO: which?
                self.reloadItem(item, reloadChildren: true)
                
            }
        }
    }
}

extension NSOutlineView: ExpandableCollectionPresenter {
    // Already implements the methods
}

protocol ColumnSpannable {
    
}

protocol OutlineViewDataSource: NSOutlineViewDataSource {
    func outlineView(outlineView: NSOutlineView, columnSpanForItem item: AnyObject, column: NSTableColumn) -> Int
}

@IBDesignable public class OutlineView: NSOutlineView, ColumnSpannable {
    var outlineViewDataSource: OutlineViewDataSource? {
        return self.dataSource() as? OutlineViewDataSource
    }
    
    @IBInspectable var hidesOutlineTriangles: Bool = false
    
    let kOutlineColumnWidth:CGFloat = 11 // TODO: don't hardcode
    
    override public func frameOfOutlineCellAtRow(row: Int) -> NSRect {
        if self.hidesOutlineTriangles {
            return NSRect.zero
        } else {
            return super.frameOfOutlineCellAtRow(row)
        }
    }
    
    override public func frameOfCellAtColumn(column: Int, row: Int) -> NSRect {
        var superFrame = super.frameOfCellAtColumn(column, row: row)
        
        let tableColumn = self.tableColumns[column]
        let indent = self.indentationPerLevel
        
        if self.hidesOutlineTriangles {
            if tableColumn === self.outlineTableColumn {
                superFrame = NSRect(x: superFrame.origin.x - kOutlineColumnWidth, y: superFrame.origin.y, width: superFrame.size.width + kOutlineColumnWidth, height: superFrame.size.height)
            }
        }
        
        guard let dataSource = self.outlineViewDataSource else { return superFrame }
        guard let item = self.itemAtRow(row) else { return superFrame }
        
        let colspan = dataSource.outlineView(self, columnSpanForItem: item, column: tableColumn)
        
        if colspan == 1 {
            return superFrame
        } else if colspan > 1 && colspan <= self.numberOfColumns {
            var mergedFrames = superFrame
            for i in 0..<colspan {
                let nextFrame = super.frameOfCellAtColumn(column + i, row: row)
                mergedFrames = NSUnionRect(mergedFrames, nextFrame)
            }
            return mergedFrames
        }
        
        return superFrame
    }

}