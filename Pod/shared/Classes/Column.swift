//
//  Column.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation

public typealias ColumnIdentifier = String

open class Column {
    open var identifier: ColumnIdentifier
    open var title: String
    
    public init(identifier: ColumnIdentifier, title: String) {
        self.identifier = identifier
        self.title = title
    }
}
