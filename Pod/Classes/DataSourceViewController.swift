//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import UIKit

public class DataSourceViewController: UIViewController, DataSourceDelegate {
    lazy public var dataSource:DataSource = {
        let dataSource = DataSource()
        dataSource.delegate = self
        return dataSource
    }()
    
    public var configure:(DataSource -> Void)?
    
    @IBOutlet lazy public var tableView:UITableView! = {
        UITableView(frame: self.view.bounds)
    }()
    
    public convenience init(title:String?=nil, configure:(DataSource -> Void)) {
        self.init()
        self.title = title
        self.configure = configure
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if self.tableView.superview == nil {
            self.tableView.frame = self.view.bounds
            self.tableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            self.view.addSubview(tableView)
        }
        
        self.tableView.estimatedRowHeight = 44
        
        // Hide trailing separators
        self.tableView.tableFooterView = UIView()

        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource

        self.reloadData()
    }
    
    public func configureDataSource(dataSource:DataSource) {
        if let configure = self.configure {
            configure(dataSource)
        }
    }
    
    public func reloadData() {
        self.buildDataSource()
        self.tableView.reloadData()
    }

    public func buildDataSource() {
        self.dataSource.sections = []
        self.configureDataSource(dataSource)
    }
    
    public func presentationViewControllerForDataSource(dataSource: DataSource) -> UIViewController? {
        return self
    }
    
}