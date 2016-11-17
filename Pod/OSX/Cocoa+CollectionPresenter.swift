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
    public func reloadItem(_ item: AnyObject?, columnIdentifiers: [String], reloadChildren: Bool = false) {
        if let item = item {
            let row = self.row(forItem: item)
            let rowIndexes = IndexSet(integer: row)
            for identifier in columnIdentifiers {
                let column = self.column(withIdentifier: identifier)
                    let columnIndexes = IndexSet(integer: column)
                    self.reloadData(forRowIndexes: rowIndexes, columnIndexes: columnIndexes)
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
    func outlineView(_ outlineView: NSOutlineView, columnSpanForItem item: AnyObject, column: NSTableColumn) -> Int
}

@IBDesignable open class OutlineView: NSOutlineView, ColumnSpannable {
    var outlineViewDataSource: OutlineViewDataSource? {
        return self.dataSource as? OutlineViewDataSource
    }
    
    @IBInspectable var hidesOutlineTriangles: Bool = false
    
    let kOutlineColumnWidth:CGFloat = 11 // TODO: don't hardcode
    
    override open func frameOfOutlineCell(atRow row: Int) -> NSRect {
        if self.hidesOutlineTriangles {
            return NSRect.zero
        } else {
            return super.frameOfOutlineCell(atRow: row)
        }
    }
    
    override open func frameOfCell(atColumn column: Int, row: Int) -> NSRect {
        var superFrame = super.frameOfCell(atColumn: column, row: row)
        
        let tableColumn = self.tableColumns[column]
        let indent = self.indentationPerLevel
        
        if self.hidesOutlineTriangles {
            if tableColumn === self.outlineTableColumn {
                superFrame = NSRect(x: superFrame.origin.x - kOutlineColumnWidth, y: superFrame.origin.y, width: superFrame.size.width + kOutlineColumnWidth, height: superFrame.size.height)
            }
        }
        
        guard let dataSource = self.outlineViewDataSource else { return superFrame }
        guard let item = self.item(atRow: row) else { return superFrame }
        
        let colspan = dataSource.outlineView(self, columnSpanForItem: item as AnyObject, column: tableColumn)
        
        if colspan == 1 {
            return superFrame
        } else if colspan > 1 && colspan <= self.numberOfColumns {
            var mergedFrames = superFrame
            for i in 0..<colspan {
                let nextFrame = super.frameOfCell(atColumn: column + i, row: row)
                mergedFrames = NSUnionRect(mergedFrames, nextFrame)
            }
            return mergedFrames
        }
        
        return superFrame
    }

}
