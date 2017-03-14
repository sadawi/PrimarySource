//
//  PushCell.swift
//  Pods
//
//  Created by Sam Williams on 3/14/17.
//
//

import UIKit

/**
 A cell that can push another view controller when tapped.
 */
public protocol NavigationCell: TappableTableCell {
    var presentationViewController: UIViewController? { get }
    var buildNextViewController: ((UIViewController)->UIViewController?)? { get }
}

extension NavigationCell {
    public func handleTap() {
        self.pushNextViewController()
    }
    
    public func pushNextViewController() {
        if let presenter = self.presentationViewController, let controller = buildNextViewController?(presenter) {
            self.presentationViewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

/**
 A concrete example of a NavigationCell
 */
open class PushCell: TableCell {
    // MARK: - NavigationCell
    
    open var buildNextViewController: ((UIViewController)->UIViewController?)?
    
    public var presentationViewController: UIViewController? {
        return self.dataSource?.presentationViewController()
    }
    
}
