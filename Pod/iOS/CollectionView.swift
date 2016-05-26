//
//  CollectionView.swift
//  Pods
//
//  Created by Sam Williams on 1/28/16.
//
//

import Foundation

public protocol CollectionViewType {
    func registerHeaderNib(nib: UINib?, reuseIdentifier identifier: String)
    func registerHeaderClass(viewClass: AnyClass?, reuseIdentifier identifier: String)

    func registerCellNib(nib: UINib?, reuseIdentifier identifier: String)
    func registerCellClass(viewClass: AnyClass?, reuseIdentifier identifier: String)
}

extension UICollectionView: CollectionViewType {
    public func registerHeaderNib(nib: UINib?, reuseIdentifier identifier: String) {
        self.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    public func registerHeaderClass(viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.registerClass(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
    }

    public func registerCellClass(viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.registerClass(viewClass, forCellWithReuseIdentifier: identifier)
    }

    public func registerCellNib(nib: UINib?, reuseIdentifier identifier: String) {
        self.registerNib(nib, forCellWithReuseIdentifier: identifier)
    }

}

extension UITableView: CollectionViewType {
    public func registerHeaderNib(nib: UINib?, reuseIdentifier identifier: String) {
        self.registerNib(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func registerHeaderClass(viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.registerClass(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    public func registerCellNib(nib: UINib?, reuseIdentifier identifier: String) {
        self.registerNib(nib, forCellReuseIdentifier: identifier)
    }
    
    public func registerCellClass(viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.registerClass(viewClass, forCellReuseIdentifier: identifier)
    }
}

