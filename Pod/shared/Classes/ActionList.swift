//
//  ActionList.swift
//  Pods
//
//  Created by Sam Williams on 8/1/16.
//
//

import Foundation

public protocol Color {
}

open class ActionItem {
    open var title: String?
    open var action: (()->())?
    open var color: Color?
    
    public init(title: String, color: Color?=nil, action: @escaping (()->())) {
        self.title = title
        self.action = action
        self.color = color
    }
}

open class ActionList {
    var actionItems: [ActionItem] = []
    
    func add(actionItem: ActionItem?) {
        if let actionItem = actionItem {
            self.actionItems.append(actionItem)
        }
    }
}

public func <<<(actionList: ActionList, actionItem: ActionItem?) {
    actionList.add(actionItem: actionItem)
}
