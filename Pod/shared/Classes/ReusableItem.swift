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
    
    func configureView(view:CollectionItemView)
}

public class ReusableItem<ViewType:CollectionItemView>: ReusableItemType {
    var configure: (ViewType -> Void)?
    public var storyboardIdentifier:String?
    public var nibName:String?
    public var identifier:String?
    
    public var reuseIdentifier: String? {
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
    
    public var viewType:AnyClass? {
        return ViewType.self
    }
    
    public func configureView(view: CollectionItemView) {
        if let view = view as? ViewType {
            self.configureView(view)
        }
    }
    
    func configureView(view:ViewType) {
        if let configure = self.configure {
            configure(view)
        }
    }
    
}