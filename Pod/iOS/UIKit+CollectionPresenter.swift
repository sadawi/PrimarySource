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
        case .Automatic:
            return .Automatic
        case .Fade:
            return .Fade
        default:
            return .None
        }
    }
}

extension UICollectionView: CollectionPresenter {
    public func registerHeader(nibName nibName: String, reuseIdentifier identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    public func registerHeader(viewClass viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.registerClass(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
    }

    public func registerCell(viewClass viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.registerClass(viewClass, forCellWithReuseIdentifier: identifier)
    }

    public func registerCell(nibName nibName: String, reuseIdentifier identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.registerNib(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public func insertSection(index index: Int, animation: CollectionPresenterAnimation) {
        // TODO
    }
    
    public func removeSection(index index: Int, animation: CollectionPresenterAnimation) {
        // TODO
    }

    public func reloadItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation) {
        // TODO
    }

    public func insertItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation) {
        // TODO
    }

    public func removeItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation) {
        // TODO
    }
}

extension UITableView: CollectionPresenter {
    public func registerHeader(nibName nibName: String, reuseIdentifier identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.registerNib(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func registerHeader(viewClass viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.registerClass(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    public func registerCell(nibName nibName: String, reuseIdentifier identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.registerNib(nib, forCellReuseIdentifier: identifier)
    }
    
    public func registerCell(viewClass viewClass: AnyClass?, reuseIdentifier identifier: String) {
        self.registerClass(viewClass, forCellReuseIdentifier: identifier)
    }
    
    public func insertSection(index index: Int, animation: CollectionPresenterAnimation) {
        self.insertSections(NSIndexSet(index: index), withRowAnimation: animation.tableAnimation)
    }

    public func removeSection(index index: Int, animation: CollectionPresenterAnimation) {
        self.deleteSections(NSIndexSet(index: index), withRowAnimation: animation.tableAnimation)
    }

    public func reloadItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation) {
        self.reloadRowsAtIndexPaths([indexPath], withRowAnimation: animation.tableAnimation)
    }

    public func insertItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation) {
        self.insertRowsAtIndexPaths([indexPath], withRowAnimation: animation.tableAnimation)
    }

    public func removeItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation) {
        self.deleteRowsAtIndexPaths([indexPath], withRowAnimation: animation.tableAnimation)
    }
    
}

