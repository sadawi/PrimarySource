//
//  CollectionPresentable.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation

public enum CollectionPresenterAnimation {
    case Automatic
    case Fade
}

public protocol CollectionPresenter: class {
    func reloadData()
}

public protocol RegisterableCollectionPresenter: CollectionPresenter {
    func registerHeader(nibName nibName: String, reuseIdentifier identifier: String)
    func registerHeader(viewClass viewClass: AnyClass?, reuseIdentifier identifier: String)
    
    func registerCell(nibName nibName: String, reuseIdentifier identifier: String)
    func registerCell(viewClass viewClass: AnyClass?, reuseIdentifier identifier: String)
}

public protocol AnimatableCollectionPresenter: CollectionPresenter {
    func insertSection(index index: Int, animation: CollectionPresenterAnimation)
    func removeSection(index index: Int, animation: CollectionPresenterAnimation)
    
    func reloadItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation)
    func insertItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation)
    func removeItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation)
}

public protocol ColumnReloadableCollectionPresenter: CollectionPresenter {
    func reloadItem(item: AnyObject?, columnIdentifiers:[String], reloadChildren:Bool)
}

public protocol ExpandableCollectionPresenter: CollectionPresenter {
    func expandItem(item: AnyObject?)
    func collapseItem(item: AnyObject?)
}