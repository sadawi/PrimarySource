//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation
import Cocoa
import PrimarySource

public protocol TableDataSourceViewController {
    var dataSource: ColumnedDataSource { get }
    var tableView: NSTableView? { get }
    func configureDataSource(dataSource: ColumnedDataSource)
}

extension TableDataSourceViewController {
    public func rebuildData() {
        self.dataSource.reset()
        self.configureDataSource(self.dataSource)
        
        self.tableView?.setDataSource(self.dataSource)
        self.tableView?.setDelegate(self.dataSource)
        
        self.dataSource.presenter = self.tableView
        self.dataSource.present()
    }
}