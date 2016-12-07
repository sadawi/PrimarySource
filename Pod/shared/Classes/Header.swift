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
open class HeaderItem<ViewType:CollectionHeaderView>: ReusableItem<ViewType>, HeaderItemType {
    open var height:CGFloat?
    
    public init(nibName:String?=nil, storyboardIdentifier:String?=nil, reuseIdentifier:String?=nil, height:CGFloat?=nil, configure:((ViewType) -> Void)?=nil) {
        super.init()
        self.nibName = nibName
        self.identifier = reuseIdentifier
        self.storyboardIdentifier = storyboardIdentifier
        self.height = height
        self.configure = configure
    }
}
