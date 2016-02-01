//
//  Header.swift
//  Pods
//
//  Created by Sam Williams on 11/25/15.
//
//

import Foundation

public protocol HeaderItemType: ReusableItemType {
    var height:CGFloat? { get set }
}

// TODO: genericize for collectionViews too
public class HeaderItem<ViewType:UITableViewHeaderFooterView>: ReusableItem<ViewType>, HeaderItemType {
    public var height:CGFloat?
    
    public init(nibName:String?=nil, storyboardIdentifier:String?=nil, reuseIdentifier:String?=nil, height:CGFloat?=nil, configure:(ViewType -> Void)?=nil) {
        super.init()
        self.nibName = nibName
        self.identifier = reuseIdentifier
        self.storyboardIdentifier = storyboardIdentifier
        self.height = height
        self.configure = configure
    }
}
