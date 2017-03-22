//
//  SelectCell.swift
//  Pods
//
//  Created by Sam Williams on 11/30/15.
//
//

import UIKit

open class PushSelectCell<Value: Equatable>: PushFieldCell<Value> {
    
    open var includeNil:Bool = false
    
    open var configureSelectViewController: ((SelectViewController<Value>) -> ())?
    
    open override func buildNextViewController() -> UIViewController? {
        let controller = SelectViewController(options: self.options, value:self.value) { [unowned self] value in
            self.value = value
            _ = self.presentationViewController?.navigationController?.popViewController(animated: true)
        }
        controller.title = self.title
        controller.options = self.options
        controller.includeNil = self.includeNil
        controller.textForNil = self.textForNil
        if let textForValue = self.textForValue {
            controller.textForValue = textForValue
        }
        self.configureSelectViewController?(controller)
        return controller
    }
}
