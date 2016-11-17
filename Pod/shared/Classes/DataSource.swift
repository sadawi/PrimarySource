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
    dataSource.addSection(section)
}

public func <<<(dataSource:DataSource, section:Section?) {
    if let section = section {
        dataSource.addSection(section)
    }
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
    
    public override init() {
        
    }
        
    open func serialize() -> [String:AnyObject] {
        let result:[String:AnyObject] = [:]
        // TODO
        return result
    }
    
    open func reset() {
        self.sections = []
    }
    
    open func addSection(_ section:Section) {
        section.dataSource = self
        self.sections.append(section)
        if let key = section.key {
            self.sectionLookup[key] = section
        }
        self.didRegisterPresenter = false
    }
    
    open func sectionAtIndex(_ index:Int) -> Section? {
        return self.visibleSections[index]
    }
    
    open func sectionForKey(_ key:String) -> Section? {
        return self.sectionLookup[key]
    }
    
    open subscript(key:String) -> Section? {
        get {
            return self.sectionForKey(key)
        }
    }
    
    open subscript(index:Int) -> Section? {
        get {
            return self.sectionAtIndex(index)
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
