//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import UIKit

public class DataSourceViewController: UITableViewController {
    var dataSource = DataSource()

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.buildDataSource()
    }
    
    public func configureDataSource(dataSource:DataSource) {
    }

    func buildDataSource() {
        let dataSource = DataSource()
        self.configureDataSource(dataSource)
        self.dataSource = dataSource
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
}