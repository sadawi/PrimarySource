//
//  ListMembership.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation

/**
 An option set representing relative positions in a list.  An item may be at the .Beginning or .End of a list, or both;
 if it is neither, it is considered to be in the .Middle.
 */
public struct ListPosition: OptionSet, CustomStringConvertible {
    public let rawValue:Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let Middle    = ListPosition(rawValue: 0)
    public static let Beginning = ListPosition(rawValue: 1 << 1)
    public static let End       = ListPosition(rawValue: 1 << 2)
    
    public var description: String {
        var parts: [String] = []
        if self == .Middle {
            parts.append("middle")
        }
        if self.contains(.Beginning) {
            parts.append("beginning")
        }
        if self.contains(.End) {
            parts.append("end")
        }
        return parts.joined(separator: ", ")
    }
}

/**
 List membership determines whether this item participates in ListPosition tracking.  If it does not, consider it .NotContained.
 Otherwise, it is .Contained with an associated type of where in the list (or rather, sub-list of other contiguous .Contained items) it lives.
 */
public enum ListMembership: Equatable {
    case notContained
    case contained(position: ListPosition)
    
    public func addingPosition(_ addedPosition: ListPosition) -> ListMembership {
        switch self {
        case .notContained:
            return self
        case .contained(let position):
            return .contained(position: position.union(addedPosition))
        }
    }
    
}
public func ==(left:ListMembership, right:ListMembership) -> Bool {
    switch (left, right) {
    case (.notContained, .notContained):
        return true
    case (.contained(let leftPosition), .contained(let rightPosition)):
        return leftPosition == rightPosition
    default:
        return false
    }
}

public protocol ListMember: class {
    var listMembership: ListMembership { get set }
}
