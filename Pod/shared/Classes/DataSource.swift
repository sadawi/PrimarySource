//
//  PrimarySource.swift
//  PrimarySource
//
//  Created by Sam Williams on 11/23/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import Foundation

public enum ReorderingMode {
    case none
    case any
    case withinSections
}

public func <<<(dataSource:DataSource, section:Section) {
    dataSource.add(section)
}

public func <<<(dataSource:DataSource, section:Section?) {
    if let section = section {
        dataSource.add(section)
    }
}

/**
 Adds a CollectionItem to the last section in a DataSource (creating a section if none exists)
 */
public func <<<(dataSource: DataSource, item: CollectionItemType?) {
    dataSource.add(item)
}

public func <<<(dataSource: DataSource, item: CollectionItemType) {
    dataSource.add(item)
}


open class DataSource: NSObject {
    open var selectionChangedHandler: (([AnyObject])->())?
    
    open var sections:[Section] = []
    var visibleSections:[Section] {
        return self.sections.filter { $0.visible }
    }

    var didRegisterPresenter = false
    
    static let defaultSectionHeaderHeight:CGFloat = 30.0
    
    open var defaultSectionHeaderHeight:CGFloat?
    open var defaultSectionFooterHeight:CGFloat?
    
    var sectionLookup:[String:Section] = [:]
    
    open weak var presenter:CollectionPresenter?

    open var reorderingMode:ReorderingMode = .withinSections
    open var reorder:((IndexPath, IndexPath) -> Void)?
    open var didScroll:((Void) -> Void)?
    
    open var defaultItemSize = CGSize(width: 40, height: 40)
    
    open var sectionCount:Int {
        return self.visibleSections.count
    }
    
    open var configureView: ((CollectionItemView)->())?
    
    public override init() {
        
    }

    open func reset() {
        self.sections = []
    }

    open func add(_ item: CollectionItemType?) {
        guard let item = item else { return }
        
        var section = self.sections.last
        if section == nil {
            section = Section()
            self.add(section)
        }
        if let section = section {
            section.add(item)
        }
    }
    
    open func add(_ section:Section?) {
        guard let section = section else { return }
        
        section.dataSource = self
        self.sections.append(section)
        if let key = section.key {
            self.sectionLookup[key] = section
        }
        self.didRegisterPresenter = false
    }
    
    open func section(at index:Int) -> Section? {
        return self.visibleSections[index]
    }
    
    open func section(forKey key:String) -> Section? {
        return self.sectionLookup[key]
    }
    
    open subscript(key:String) -> Section? {
        get {
            return self.section(forKey: key)
        }
    }
    
    open subscript(index:Int) -> Section? {
        get {
            return self.section(at: index)
        }
    }

    func item(at indexPath: IndexPath) -> CollectionItemType? {
        return self[(indexPath as NSIndexPath).section]?.itemAtIndex(indexPath.row)
    }
    
    func canMoveItem(at indexPath:IndexPath) -> Bool {
        guard let section = self[(indexPath as NSIndexPath).section] else { return false }
        
        return self.reorderingMode != .none && section.reorderable && section.itemAtIndex(indexPath.row)?.reorderable == true
    }

    func canMoveItem(from fromIndexPath:IndexPath, to toIndexPath:IndexPath) -> Bool {
        guard let toSection = self[(toIndexPath as NSIndexPath).section] else { return false }
        guard self.canMoveItem(at: fromIndexPath) else { return false }
        guard toIndexPath.row < toSection.itemCount else { return false }
        guard toSection.reorderable && toSection[toIndexPath.row]?.reorderable == true else { return false }
        
        switch self.reorderingMode {
        case .none: return false
        case .any: return true
        case .withinSections: return (fromIndexPath as NSIndexPath).section == (toIndexPath as NSIndexPath).section
        }
    }
    
    
    // MARK: - 
    
    open func registerPresenter(_ presenter: RegisterableCollectionPresenter) {
        self.presenter = presenter
        
        for section in self.sections {
            
            if let header = section.header, let identifier = header.reuseIdentifier {
                if let nibName = header.nibName {
                    if Bundle.main.path(forResource: nibName, ofType: "nib") != nil {
                        presenter.registerHeader(nibName: nibName, reuseIdentifier: identifier)
                    }
                } else {
                    presenter.registerHeader(viewClass: header.viewType, reuseIdentifier: identifier)
                }
            }
            
            section.eachItem(includeHidden: true) { item in
                if let rowClass = item.viewType, let identifier = item.reuseIdentifier {
                    
                    // If we've explicitly specified an identifier, we'll just use the storyboard prototype
                    if item.storyboardIdentifier == nil {
                        
                        if let nibName = item.nibName {
                            if Bundle.main.path(forResource: nibName, ofType: "nib") != nil {
                                presenter.registerCell(nibName: nibName, reuseIdentifier: identifier)
                            }
                        } else {
                            presenter.registerCell(viewClass: rowClass, reuseIdentifier: identifier)
                        }
                    }
                    
                }
            }
        }
        self.didRegisterPresenter = true
    }
    
    open func index(of section:Section) -> Int? {
        return self.visibleSections.index { $0 === section }
    }
    
    /**
     - parameter sectionHideAnimation: The animation to be used to hide a section
     - parameter sectionShowAnimation: The animation to be used to show a section
     */
    open func refreshDisplay(sectionHideAnimation:CollectionPresenterAnimation = .fade,
                                                    sectionShowAnimation:CollectionPresenterAnimation = .fade,
                                                    rowHideAnimation:CollectionPresenterAnimation = .automatic,
                                                    rowShowAnimation:CollectionPresenterAnimation = .automatic) {
        self.didRegisterPresenter = false
        
        for section in self.sections {
            section.refreshDisplay(sectionHideAnimation: sectionHideAnimation, sectionShowAnimation:sectionShowAnimation, rowHideAnimation: rowHideAnimation, rowShowAnimation: rowShowAnimation)
        }
    }
}
