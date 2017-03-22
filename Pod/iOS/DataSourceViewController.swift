//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import UIKit

open class DataSourceViewController: UIViewController, DataSourceDelegate {
    fileprivate var originalBottomMargin: CGFloat = 0
    
    lazy open var dataSource:DataSource = {
        let dataSource = DataSource()
        dataSource.delegate = self
        return dataSource
    }()
    
    open var tableViewStyle: UITableViewStyle = .plain
    
    @IBOutlet lazy open var tableView:UITableView! = {
        UITableView(frame: self.view.bounds, style: self.tableViewStyle)
    }()
    
    public convenience init(title:String?=nil, configure:@escaping ((DataSource) -> Void)) {
        self.init()
        self.title = title
        self.dataSource.initialConfiguration = configure
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.originalBottomMargin = self.tableView.contentInset.bottom
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if self.tableView.superview == nil {
            self.tableView.frame = self.view.bounds
            self.tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.view.addSubview(tableView)
        }
        
        self.tableView.estimatedRowHeight = 44
        
        // Hide trailing separators
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataSourceViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DataSourceViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.reloadData()
    }
    
    open func configure(with closure: @escaping ((DataSource)->())) {
        self.dataSource.initialConfiguration = closure
    }
    
    open func configure(_ dataSource:DataSource) {
    }
    
    open func reloadData() {
        DispatchQueue.main.async {
            self.dataSource.reset()
            self.configure(self.dataSource)
            self.tableView.reloadData()
        }
    }
    
    open func presentationViewControllerForDataSource(_ dataSource: DataSource) -> UIViewController? {
        return self
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(_ notification:Notification) {
        if let navigationController = self.navigationController , navigationController.topViewController !== self {
            return
        }
        
        var userInfo = (notification as NSNotification).userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tableView.contentInset
        self.originalBottomMargin = contentInset.bottom
        contentInset.bottom = keyboardFrame.size.height
        self.tableView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if let navigationController = self.navigationController , navigationController.topViewController !== self {
            return
        }
        
        var contentInset:UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = self.originalBottomMargin
        self.tableView.contentInset = contentInset
    }
    
}
