//
//  operators.swift
//  Pods
//
//  Created by Sam Williams on 11/24/15.
//
//

import Foundation

precedencegroup DataSourcePrecedence {
    associativity: left
}

infix operator <<<: DataSourcePrecedence

