//
//  PushCell.swift
//  Pods
//
//  Created by Sam Williams on 3/14/17.
//
//

import UIKit

open class PushCell<ValueType: Equatable>: ValueFieldCell<ValueType>, TappableTableCell {
    private var presentationViewController: UIViewController? {
        return self.dataSource?.presentationViewController()
    }
    
    open var controllerGenerator: ((UIViewController)->UIViewController?)?
    
    open func buildController(presentedBy presenter: UIViewController) -> UIViewController? {
        return self.controllerGenerator?(presenter)
    }
    
    public func push() {
        if let presenter = self.presentationViewController, let controller = self.buildController(presentedBy: presenter) {
            self.presentationViewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleTap() {
        self.push()
    }
}
