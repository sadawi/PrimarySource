//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import UIKit

public class DataSourceViewController: UITableViewController, DataSourceDelegate {
    public var dataSource = DataSource()
    public var configure:(DataSource -> Void)?
    
    public convenience init(title:String?=nil, configure:(DataSource -> Void)) {
        self.init()
        self.title = title
        self.configure = configure
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        // Hide trailing separators
        self.tableView.tableFooterView = UIView()

        self.reloadData()
    }
    
    public func configureDataSource(dataSource:DataSource) {
        if let configure = self.configure {
            configure(dataSource)
        }
    }
    
    public func reloadData() {
        self.buildDataSource()
    }

    func buildDataSource() {
        let dataSource = DataSource()
        self.configureDataSource(dataSource)
        self.dataSource = dataSource
        
        self.dataSource.delegate = self
        
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
    public func presentationViewControllerForDataSource(dataSource: DataSource) -> UIViewController? {
        return self
    }
    
}