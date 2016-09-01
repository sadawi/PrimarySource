//
//  Column.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation

public typealias ColumnIdentifier = String

public class Column {
    public var identifier: ColumnIdentifier
    public var title: String
    
    public init(identifier: ColumnIdentifier, title: String) {
        self.identifier = identifier
        self.title = title
    }
}