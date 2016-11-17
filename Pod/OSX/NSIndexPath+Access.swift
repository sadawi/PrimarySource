//
//  DataSource+UITableView.swift
//  Pods
//
//  Created by Sam Williams on 1/28/16.
//
//

import Foundation

extension IndexPath {
    init(row row:Int, section section: Int) {
        self.init(item: row, section: section)
    }
    
    var row: Int {
        // was indexPath(atPosition: row) in Swift 2
        return self.index(row, offsetBy: 0)
    }
}
