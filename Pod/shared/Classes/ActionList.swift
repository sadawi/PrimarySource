//
//  ActionList.swift
//  Pods
//
//  Created by Sam Williams on 8/1/16.
//
//

import Foundation

public class ActionItem {
    public var title: String?
    public var action: (()->())?
}

public class ActionList {
    var actions: [ActionItem] = []
}