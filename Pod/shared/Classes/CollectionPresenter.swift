//
//  CollectionPresentable.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation

public enum CollectionPresenterAnimation {
    case automatic
    case fade
}

public protocol CollectionPresenter: class {
    func reloadData()
}

public protocol RegisterableCollectionPresenter: CollectionPresenter {
    func registerHeader(nibName: String, reuseIdentifier identifier: String)
    func registerHeader(viewClass: AnyClass?, reuseIdentifier identifier: String)
    
    func registerCell(nibName: String, reuseIdentifier identifier: String)
    func registerCell(viewClass: AnyClass?, reuseIdentifier identifier: String)
}

public protocol AnimatableCollectionPresenter: CollectionPresenter {
    func insertSection(index: Int, animation: CollectionPresenterAnimation)
    func removeSection(index: Int, animation: CollectionPresenterAnimation)
    
    func reloadItem(indexPath: IndexPath, animation: CollectionPresenterAnimation)
    func insertItem(indexPath: IndexPath, animation: CollectionPresenterAnimation)
    func removeItem(indexPath: IndexPath, animation: CollectionPresenterAnimation)
}

public protocol ColumnReloadableCollectionPresenter: CollectionPresenter {
    func reloadItem(_ item: Any?, columnIdentifiers:[String], reloadChildren:Bool)
}

public protocol ExpandableCollectionPresenter: CollectionPresenter {
    func expandItem(_ item: Any?)
    func collapseItem(_ item: Any?)
}
