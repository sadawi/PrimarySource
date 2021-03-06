//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation
import Cocoa

public protocol TableDataSourceViewController {
    var dataSource: ColumnedDataSource { get }
    var tableView: NSTableView? { get }
    func configureDataSource(_ dataSource: ColumnedDataSource)
}

extension TableDataSourceViewController {
    public func rebuildData() {
        self.dataSource.reset()
        self.configureDataSource(self.dataSource)
        
        self.tableView?.dataSource = self.dataSource
        self.tableView?.delegate = self.dataSource
        
        self.dataSource.presenter = self.tableView
        self.dataSource.present()
    }
}
