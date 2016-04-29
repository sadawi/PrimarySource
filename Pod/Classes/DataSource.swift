//
//  PrimarySource.swift
//  PrimarySource
//
//  Created by Sam Williams on 11/23/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import Foundation

public enum ReorderingMode {
    case None
    case Any
    case WithinSections
}

public protocol DataSourceDelegate: class {
    func presentationViewControllerForDataSource(dataSource:DataSource) -> UIViewController?
}

public class DataSource: NSObject {
    var sections:[Section] = []
    var visibleSections:[Section] {
        return self.sections.filter { $0.visible }
    }

    var didRegisterReuseIdentifiers = false
    var defaultHeaderHeight:CGFloat = 30.0
    
    public weak var delegate:DataSourceDelegate?

    var sectionLookup:[String:Section] = [:]
    
    weak var tableView:UITableView?
    weak var collectionView:UICollectionView?

    public var reorderingMode:ReorderingMode = .WithinSections
    public var reorder:((NSIndexPath, NSIndexPath) -> Void)?
    public var didScroll:(Void -> Void)?
    
    public var sectionCount:Int {
        return self.visibleSections.count
    }
    
    public override init() {
        
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        self.didScroll?()
    }
    
    public func serialize() -> [String:AnyObject] {
        let result:[String:AnyObject] = [:]
        // TODO
        return result
    }
    
    internal func presentationViewController() -> UIViewController? {
        return self.delegate?.presentationViewControllerForDataSource(self)
    }
    
    public func addSection(section:Section) {
        section.dataSource = self
        self.sections.append(section)
        if let key = section.key {
            self.sectionLookup[key] = section
        }
        self.didRegisterReuseIdentifiers = false
    }
    
    public func sectionAtIndex(index:Int) -> Section? {
        return self.visibleSections[index]
    }
    
    public func sectionForKey(key:String) -> Section? {
        return self.sectionLookup[key]
    }
    
    public subscript(key:String) -> Section? {
        get {
            return self.sectionForKey(key)
        }
    }
    
    public subscript(index:Int) -> Section? {
        get {
            return self.sectionAtIndex(index)
        }
    }

    func item(atIndexPath indexPath: NSIndexPath) -> CollectionItemType? {
        return self[indexPath.section]?.itemAtIndex(indexPath.row)
    }
    
    func canMoveItem(atIndexPath indexPath:NSIndexPath) -> Bool {
        guard let section = self[indexPath.section] else { return false }
        
        return self.reorderingMode != .None && section.reorderable && section.itemAtIndex(indexPath.row)?.reorderable == true
    }

    func canMoveItem(fromIndexPath fromIndexPath:NSIndexPath, toIndexPath:NSIndexPath) -> Bool {
        guard let toSection = self[toIndexPath.section] else { return false }
        guard self.canMoveItem(atIndexPath: fromIndexPath) else { return false }
        guard toIndexPath.row < toSection.itemCount else { return false }
        guard toSection.reorderable && toSection[toIndexPath.row]?.reorderable == true else { return false }
        
        switch self.reorderingMode {
        case .None: return false
        case .Any: return true
        case .WithinSections: return fromIndexPath.section == toIndexPath.section
        }
    }
    
    
    // MARK: - 
    
    public func registerReuseIdentifiers(view: CollectionViewType) {
        if let collectionView = view as? UICollectionView {
            self.collectionView = collectionView
        } else if let tableView = view as? UITableView {
            self.tableView = tableView
        }
        
        for section in self.sections {
            
            if let header = section.header, identifier = header.reuseIdentifier {
                if let nibName = header.nibName {
                    if NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") != nil {
                        view.registerHeaderNib(UINib(nibName: nibName, bundle: nil), reuseIdentifier: identifier)
                    }
                } else {
                    view.registerHeaderClass(header.viewType, reuseIdentifier: identifier)
                }
            }
            
            section.eachItem(includeHidden: true) { item in
                if let rowClass = item.viewType, identifier = item.reuseIdentifier {
                    
                    // If we've explicitly specified an identifier, we'll just use the storyboard prototype
                    if item.storyboardIdentifier == nil {
                        
                        if let nibName = item.nibName {
                            if NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") != nil {
                                view.registerCellNib(UINib(nibName: nibName, bundle: nil), reuseIdentifier: identifier)
                            }
                        } else {
                            view.registerCellClass(rowClass, reuseIdentifier: identifier)
                        }
                    }
                    
                }
            }
        }
        self.didRegisterReuseIdentifiers = true
    }
    
    public func indexOfSection(section:Section) -> Int? {
        return self.visibleSections.indexOf { $0 === section }
    }
    
    /**
     - parameter sectionHideAnimation: The animation to be used to hide a section
     - parameter sectionShowAnimation: The animation to be used to show a section
     */
    public func refreshDisplay(sectionHideAnimation sectionHideAnimation:UITableViewRowAnimation = .Fade,
                                                    sectionShowAnimation:UITableViewRowAnimation = .Fade,
                                                    rowHideAnimation:UITableViewRowAnimation = .Automatic,
                                                    rowShowAnimation:UITableViewRowAnimation = .Automatic) {
        self.didRegisterReuseIdentifiers = false
        
        for section in self.sections {
            section.refreshDisplay(sectionHideAnimation: sectionHideAnimation, sectionShowAnimation:sectionShowAnimation, rowHideAnimation: rowHideAnimation, rowShowAnimation: rowShowAnimation)
        }
    }
}