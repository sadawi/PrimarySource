//
//  SelectViewController.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import UIKit

public class SelectViewController<T:Equatable>: DataSourceViewController {
    public typealias ValueType = T
    
    // Overloading `==` for your class will not work.
    public var valuesAreEqual:((T?, T?)->Bool)?
    
    public var value:ValueType?
    public var multiple:Bool = false
    public var textForValue:(ValueType -> String) = { value in
        return String(value)
    }
    public var textForNil: String?
    public var includeNil: Bool = false
    public var didSelectValue:(ValueType? -> ())?
    
    var loading = false
    
    /**
     If options need more complicated logic to load (e.g., loading from a server), that can be done with this closure.
     The closure should take a completion block that is to be called when options are ready.
     */
    public var loadOptions: ((([ValueType])->()) -> ())?
    
    public var options:[ValueType] = []
    
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
        if let loadOptions = self.loadOptions {
            self.loading = true
            loadOptions { [weak self] options in
                self?.options = options
                self?.loading = false
                self?.reloadData()
            }
        }
        
        super.viewDidLoad()
    }
    
    public override func configureDataSource(dataSource:DataSource) {
        guard self.loading == false else { return }
        
        var options:[ValueType?] = []
        if self.includeNil {
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
                    } else if let nilText = self.textForNil {
                        text = nilText
                    } else {
                        text = ""
                    }
                    
                    cell.textLabel?.text = text
                    
                    let selected:Bool
                    if let test = self.valuesAreEqual {
                        selected = test(self.value, option)
                    } else {
                        selected = self.value == option
                    }
                    
                    cell.accessoryType = selected ? .Checkmark : .None
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
