//
//  OutlineViewController.swift
//  PrimarySourceExample-OSX
//
//  Created by Sam Williams on 5/26/16.
//  Copyright © 2016 Sam Williams. All rights reserved.
//

import Foundation
import Cocoa
import PrimarySource

private let kNameColumnIdentifier = "Name"
private let kAgeColumnIdentifier = "Age"

class OutlineViewController: NSViewController {
    @IBOutlet var outlineView: NSOutlineView?
}