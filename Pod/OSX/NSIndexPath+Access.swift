//
//  DataSource+UITableView.swift
//  Pods
//
//  Created by Sam Williams on 1/28/16.
//
//

import Foundation

extension NSIndexPath {
    convenience init(forRow row:Int, inSection section: Int) {
        self.init(forItem: row, inSection: section)
    }
    
    var row: Int {
        return self.indexAtPosition(1)
    }
}