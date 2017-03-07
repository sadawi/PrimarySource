//
//  ReusableItem.swift
//  Pods
//
//  Created by Sam Williams on 1/20/16.
//
//

import Foundation

public protocol ReusableItemType {
    var storyboardIdentifier:String? { get set }
    var nibName:String? { get set }
    
    var reuseIdentifier:String? { get }
    var viewType:AnyClass? { get }
    
    func configure(_ view:CollectionItemView)
}

open class ReusableItem<ViewType:CollectionItemView>: ReusableItemType {
    public typealias ViewConfiguration = ((ViewType) -> ())

    public var configurations = [ViewConfiguration]()
    
    open var storyboardIdentifier:String?
    open var nibName:String?
    open var identifier:String?
    
    public func addConfiguration(_ configuration: @escaping ViewConfiguration) {
        self.configurations.append(configuration)
    }
    
    open var reuseIdentifier: String? {
        if let identifier = self.identifier {
            return identifier
        }
        
        if let storyboardIdentifier = self.storyboardIdentifier {
            return storyboardIdentifier
        }
        
        if let viewType = self.viewType {
            return NSStringFromClass(viewType)
        } else {
            return "CollectionItemType"
        }
    }
    
    open var viewType:AnyClass? {
        return ViewType.self
    }
    
    open func configure(_ view: CollectionItemView) {
        if let view = view as? ViewType {
            self.configure(view)
        }
    }
    
    func configure(_ view:ViewType) {
        for closure in self.configurations {
            closure(view)
        }
    }
    
}
