//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import UIKit

public class DataSourceViewController: UIViewController, DataSourceDelegate {
    private var originalBottomMargin: CGFloat = 0
    
    lazy public var dataSource:DataSource = {
        let dataSource = DataSource()
        dataSource.delegate = self
        return dataSource
    }()
    
    public var configure:(DataSource -> Void)?
    public var tableViewStyle: UITableViewStyle = .Plain
    
    @IBOutlet lazy public var tableView:UITableView! = {
        UITableView(frame: self.view.bounds, style: self.tableViewStyle)
    }()
    
    public convenience init(title:String?=nil, configure:(DataSource -> Void)) {
        self.init()
        self.title = title
        self.configure = configure
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.originalBottomMargin = self.tableView.contentInset.bottom
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        
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
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification:NSNotification) {
        if let navigationController = self.navigationController where navigationController.topViewController !== self {
            return
        }
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.tableView.contentInset
        self.originalBottomMargin = contentInset.bottom
        contentInset.bottom = keyboardFrame.size.height
        self.tableView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification) {
        if let navigationController = self.navigationController where navigationController.topViewController !== self {
            return
        }
        
        var contentInset:UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = self.originalBottomMargin
        self.tableView.contentInset = contentInset
    }
    
}