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
    func registerHeader(nibName nibName: String, reuseIdentifier identifier: String)
    func registerHeader(viewClass viewClass: AnyClass?, reuseIdentifier identifier: String)
    
    func registerCell(nibName nibName: String, reuseIdentifier identifier: String)
    func registerCell(viewClass viewClass: AnyClass?, reuseIdentifier identifier: String)
    
    func insertSection(index index: Int, animation: CollectionPresenterAnimation)
    func removeSection(index index: Int, animation: CollectionPresenterAnimation)
    
    func reloadItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation)
    func insertItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation)
    func removeItem(indexPath indexPath: NSIndexPath, animation: CollectionPresenterAnimation)
}
