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
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.reloadData()
    }
    
    public func configureDataSource(dataSource:DataSource) {
    }
    
    public func reloadData() {
        self.buildDataSource()
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