//
//  DataSource+Presentation.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import UIKit

public protocol DataSourceDelegate: class {
    func presentationViewControllerForDataSource(_ dataSource:DataSource) -> UIViewController?
}

private var delegateAssociationKey: UInt8 = 0

extension DataSource {
    var delegate: DataSourceDelegate? {
        get {
            return objc_getAssociatedObject(self, &delegateAssociationKey) as? DataSourceDelegate
        }
        set(newValue) {
            objc_setAssociatedObject(self, &delegateAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func presentationViewController() -> UIViewController? {
        return self.delegate?.presentationViewControllerForDataSource(self)
    }
}
