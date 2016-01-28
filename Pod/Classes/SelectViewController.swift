//
//  SelectViewController.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import UIKit

public class SelectViewController<ValueType:Equatable>: DataSourceViewController {
    public var value:ValueType?
    public var multiple:Bool = false
    public var textForValue:(ValueType -> String?) = { value in
        return String(value)
    }
    public var includeNil: String?
    public var didSelectValue:(ValueType? -> Void)?
    
    public var options:[ValueType] = [] {
        didSet {
            self.buildDataSource()
        }
    }

    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollToValue(animated: false)
    }
    
    public func scrollToValue(animated animated:Bool = false) {
        if let value = self.value, index = self.options.indexOf(value) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.safe_scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: false)
        }
    }

    public init(options:[ValueType], value:ValueType?, didSelectValue:(ValueType? -> Void)?=nil) {
        super.init(nibName: nil, bundle: nil)
        self.options = options
        self.value = value
        self.didSelectValue = didSelectValue
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.buildDataSource()
    }
    
    public override func configureDataSource(dataSource:DataSource) {
        var options:[ValueType?] = []
        if self.includeNil != nil {
            options.append(nil)
        }
        for v in self.options {
            options.append(v)
        }
        
        dataSource <<< Section { section in
            for option in options {
                section <<< CollectionItem<TableCell> { [unowned self] cell in
                    let text:String?
                    if let value = option {
                        text = self.textForValue(value)
                    } else if let nilText = self.includeNil {
                        text = nilText
                    } else {
                        text = ""
                    }
                    
                    cell.textLabel?.text = text
                    cell.accessoryType = self.value == option ? .Checkmark : .None
                    }.onTap { [unowned self] _ in
                        self.value = option
                        self.commit()
                }
            }
        }
    }
    
    public func commit() {
        self.didSelectValue?(self.value)
    }

}
