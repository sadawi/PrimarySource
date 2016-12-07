//
//  CollectionView.swift
//  Pods
//
//  Created by Sam Williams on 1/28/16.
//
//

import Foundation

extension CollectionPresenterAnimation {
    var tableAnimation: UITableViewRowAnimation {
        switch self {
        case .automatic:
            return .automatic
        case .fade:
            return .fade
        }
    }
}

extension UICollectionView: CollectionPresenter {
}

extension UICollectionView: AnimatableCollectionPresenter {
    public func insertSection(index: Int, animation: CollectionPresenterAnimation) {
        // TODO
    }
    
    public func removeSection(index: Int, animation: CollectionPresenterAnimation) {
        // TODO
    }

    public func reloadItem(indexPath: IndexPath, animation: CollectionPresenterAnimation) {
        // TODO
    }

    public func insertItem(indexPath: IndexPath, animation: CollectionPresenterAnimation) {
        // TODO
    }

    public func removeItem(indexPath: IndexPath, animation: CollectionPresenterAnimation) {
        // TODO
    }
}

extension UICollectionView: RegisterableCollectionPresenter {
    public func registerHeader(nibName: String, reuseIdentifier identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    public func registerHeader(viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    public func registerCell(viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.register(viewClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func registerCell(nibName: String, reuseIdentifier identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

extension UITableView: CollectionPresenter {
}

extension UITableView: AnimatableCollectionPresenter {
    public func insertSection(index: Int, animation: CollectionPresenterAnimation) {
        self.insertSections(IndexSet(integer: index), with: animation.tableAnimation)
    }

    public func removeSection(index: Int, animation: CollectionPresenterAnimation) {
        self.deleteSections(IndexSet(integer: index), with: animation.tableAnimation)
    }

    public func reloadItem(indexPath: IndexPath, animation: CollectionPresenterAnimation) {
        self.reloadRows(at: [indexPath], with: animation.tableAnimation)
    }

    public func insertItem(indexPath: IndexPath, animation: CollectionPresenterAnimation) {
        self.insertRows(at: [indexPath], with: animation.tableAnimation)
    }

    public func removeItem(indexPath: IndexPath, animation: CollectionPresenterAnimation) {
        self.deleteRows(at: [indexPath], with: animation.tableAnimation)
    }
}

extension UITableView: RegisterableCollectionPresenter {
    public func registerHeader(nibName: String, reuseIdentifier identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func registerHeader(viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func registerCell(nibName: String, reuseIdentifier identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func registerCell(viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.register(viewClass, forCellReuseIdentifier: identifier)
    }
}

