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
    typealias ViewControllerGenerator = (()->UIViewController?)
    
    var presentationViewController: UIViewController? { get }
    var buildNextViewController: ViewControllerGenerator? { get }
}

extension NavigationCell {
    public func handleTap() {
        self.pushNextViewController()
    }
    
    public func pushNextViewController() {
        if let presenter = self.presentationViewController, let controller = buildNextViewController?() {
            presenter.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

/**
 A concrete example of a NavigationCell
 */
open class PushCell: TableCell, NavigationCell {
    
    open override func buildView() {
        super.buildView()
        self.accessoryType = .disclosureIndicator
    }
    
    // MARK: - NavigationCell
    
    open var buildNextViewController: NavigationCell.ViewControllerGenerator?
    
    public var presentationViewController: UIViewController? {
        return self.dataSource?.presentationViewController()
    }
    
}
