//
//  operators.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import Foundation

infix operator <<< { associativity left precedence 95 }

public func <<<(left:DataSource, right:Section) {
    left.addSection(right)
}

public func <<<(left:DataSource, right:Section?) {
    if let right = right {
        left.addSection(right)
    }
}

public func <<<(left:Section, right:CollectionItem) {
    left.addItem(right)
}

public func <<<(left:Section, right:CollectionItem?) {
    if let right = right {
        left.addItem(right)
    }
}