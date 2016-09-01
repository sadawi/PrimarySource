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

public class ActionItem {
    public var title: String?
    public var action: (()->())?
    public var color: Color?
    
    public init(title: String, color: Color?=nil, action: (()->())) {
        self.title = title
        self.action = action
        self.color = color
    }
}

public class ActionList {
    var actionItems: [ActionItem] = []
    
    func add(actionItem actionItem: ActionItem?) {
        if let actionItem = actionItem {
            self.actionItems.append(actionItem)
        }
    }
}

public func <<<(actionList: ActionList, actionItem: ActionItem?) {
    actionList.add(actionItem: actionItem)
}