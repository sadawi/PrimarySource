//
//  SelectViewController.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import UIKit

class SelectViewController<ValueType:Equatable>: DataSourceViewController {
    var value:ValueType?
    var multiple:Bool = false
    
    var didSelectValue:(ValueType? -> Void)?
    
    var options:[ValueType] = [] {
        didSet {
            self.buildDataSource()
        }
    }

    init(options:[ValueType], value:ValueType?, didSelectValue:(ValueType? -> Void)?=nil) {
        super.init(nibName: nil, bundle: nil)
        self.options = options
        self.value = value
        self.didSelectValue = didSelectValue
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildDataSource()
    }
    
    override func configureDataSource(dataSource:DataSource) {
        dataSource <<< Section { section in
            for option in self.options {
                section <<< TableViewItem<TableCell> { [unowned self] cell in
                    cell.textLabel?.text = String(option)
                    cell.accessoryType = self.value == option ? .Checkmark : .None
                    }.onTap { [unowned self] _ in
                        self.value = option
                        self.commit()
                }
            }
        }
    }
    
    func commit() {
        self.didSelectValue?(self.value)
    }

}
