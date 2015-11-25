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


//infix operator <<< { associativity left precedence 95 }
public func <<<(left:Section, right:CollectionItem) {
    left.addItem(right)
}