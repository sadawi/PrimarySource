//
//  PushCell.swift
//  Pods
//
//  Created by Sam Williams on 3/14/17.
//
//

import UIKit

public protocol NavigationCell: TappableTableCell {
    var presentationViewController: UIViewController? { get }
    var buildNextViewController: ((UIViewController)->UIViewController?)? { get }
}

extension NavigationCell {
    public func handleTap() {
        self.push()
    }
    
    public func push() {
        if let presenter = self.presentationViewController, let controller = buildNextViewController?(presenter) {
            self.presentationViewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
