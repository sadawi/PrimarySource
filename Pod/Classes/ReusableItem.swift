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
    
    func configureView(view:UIView)
}

public class ReusableItem<ViewType:UIView>: ReusableItemType {
    var configure: (ViewType -> Void)?
    public var storyboardIdentifier:String?
    public var nibName:String?
    
    public var reuseIdentifier:String? {
        get {
            return storyboardIdentifier ?? generateReuseIdentifier()
        }
    }
    
    func generateReuseIdentifier() -> String {
        if let viewType = self.viewType {
            return NSStringFromClass(viewType)
        } else {
            return "CollectionItemType"
        }
    }
    
    public var viewType:AnyClass? {
        return ViewType.self
    }
    
    public func configureView(view: UIView) {
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