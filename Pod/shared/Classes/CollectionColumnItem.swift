//
//  CollectionColumnItem.swift
//  Pods
//
//  Created by Sam Williams on 5/29/16.
//
//

import Foundation

public protocol CollectionColumnItemType {
    var columnSpan: Int { get set }
}

open class CollectionColumnItem<ViewType: CollectionItemView>: CollectionItem<ViewType>, CollectionColumnItemType {
    open var columnSpan: Int = 1

    public init(key:String?=nil, nibName:String?=nil, reorderable:Bool=false, storyboardIdentifier:String?=nil, columnSpan: Int=1, configure:ViewConfiguration?=nil) {
        self.columnSpan = columnSpan
        super.init(key: key, nibName: nibName, reorderable: reorderable, storyboardIdentifier: storyboardIdentifier, configure: configure)
    }
}
