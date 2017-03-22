//
//  SelectViewController.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import UIKit

public protocol CollectionItemViewable {
    func buildViewCollectionItem() -> CollectionItemType?
}

open class SelectViewController<T:Equatable>: DataSourceViewController {
    public typealias ValueType = T
    
    // Overloading `==` for your class will not work.
    open var valuesAreEqual:((T?, T?)->Bool)?
    
    open var value:ValueType?
    open var multiple:Bool = false
    open var textForValue:((ValueType) -> String) = { value in
        return String(describing: value)
    }
    open var textForNil: String?
    open var includeNil: Bool = false
    open var didSelectValue:((ValueType?) -> ())?
    
    var loading = false
    
    /**
     If options need more complicated logic to load (e.g., loading from a server), that can be done with this closure.
     The closure should take a completion block that is to be called when options are ready.
     */
    open var loadOptions: ((([ValueType])->()) -> ())?
    
    open var options:[ValueType] = []
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollToValue(animated: false)
    }
    
    open func scrollToValue(animated:Bool = false) {
        if let value = self.value, let index = self.options.index(of: value) {
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.safe_scrollToRowAtIndexPath(indexPath, atScrollPosition: .middle, animated: false)
        }
    }

    public init(options:[ValueType], value:ValueType?, didSelectValue:((ValueType?) -> Void)?=nil) {
        super.init(nibName: nil, bundle: nil)
        self.options = options
        self.value = value
        self.didSelectValue = didSelectValue
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
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
    
    open override func configure(_ dataSource:DataSource) {
        guard self.loading == false else { return }
        
        var options:[ValueType?] = []
        if self.includeNil {
            options.append(nil)
        }
        for v in self.options {
            options.append(v)
        }
        
        dataSource <<< Section { [weak self] section in
            for option in options {
                let item = self?.buildCollectionItem(option: option)
                
                item?.isSelected = { _ in
                    if let test = self?.valuesAreEqual {
                        return test(self?.value, option)
                    } else {
                        return self?.value == option
                    }
                }
                
                item?.onTap { _ in
                    self?.value = option
                    self?.commit()
                }
                section <<< item
            }
        }
    }
    
    open func commit() {
        self.didSelectValue?(self.value)
    }

    func buildCollectionItem(option: ValueType?) -> CollectionItemType? {
        if let viewable = option as? CollectionItemViewable {
            return viewable.buildViewCollectionItem()
        } else {
            return CollectionItem<TableCell> { [unowned self] cell in
                let text:String?
                if let value = option {
                    text = self.textForValue(value)
                } else if let nilText = self.textForNil {
                    text = nilText
                } else {
                    text = ""
                }
                
                cell.textLabel?.text = text
            }
        }
    }
    
}
