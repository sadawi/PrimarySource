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

public class DataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var sections:[Section] = []
    var didRegisterReuseIdentifiers = false
    var defaultHeaderHeight:CGFloat = 30.0
    
    public weak var delegate:DataSourceDelegate?

    public var reorderingMode:ReorderingMode = .WithinSections
    public var reorder:((NSIndexPath, NSIndexPath) -> Void)?
    public var didScroll:(Void -> Void)?
    
    public var sectionCount:Int {
        return self.sections.count
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
        self.sections.append(section)
    }
    
    func item(atIndexPath indexPath: NSIndexPath) -> CollectionItem {
        return self.sections[indexPath.section].items[indexPath.row]
    }
    
    func canMoveItem(atIndexPath indexPath:NSIndexPath) -> Bool {
        let section = self.sections[indexPath.section]
        return self.reorderingMode != .None && section.reorderable && section.items[indexPath.row].reorderable
    }

    func canMoveItem(fromIndexPath fromIndexPath:NSIndexPath, toIndexPath:NSIndexPath) -> Bool {
        let toSection = self.sections[toIndexPath.section]
        
        guard self.canMoveItem(atIndexPath: fromIndexPath) else { return false }
        guard toIndexPath.row < toSection.items.count else { return false }
        guard toSection.reorderable && toSection.items[toIndexPath.row].reorderable else { return false }
        
        switch self.reorderingMode {
        case .None: return false
        case .Any: return true
        case .WithinSections: return fromIndexPath.section == toIndexPath.section
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.canMoveItem(atIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if self.canMoveItem(fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath) {
            if self.reorderingMode == .WithinSections {
                self.sections[sourceIndexPath.section].handleReorder(fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
            } else if let reorder = self.reorder {
                reorder(sourceIndexPath, destinationIndexPath)
            }
        }
    }
    
    public func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        return self.canMoveItem(fromIndexPath: sourceIndexPath, toIndexPath: proposedDestinationIndexPath) ? proposedDestinationIndexPath : sourceIndexPath
    }
    
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.item(atIndexPath: indexPath).onTap != nil {
            return true
        }
        
        if tableView.cellForRowAtIndexPath(indexPath) is TappableTableCell {
            return true
        }

        return false
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.item(atIndexPath: indexPath).handleAccessoryTap()
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.item(atIndexPath: indexPath).handleTap()
        
        if let tappable = tableView.cellForRowAtIndexPath(indexPath) as? TappableTableCell {
            tappable.handleTap()
        }
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.sections[section]
        if let headerItem = section.header, identifier = headerItem.reuseIdentifier {
            if let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) {
                headerItem.configureView(header)
                return header
            }
        }
        return nil
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = self.sections[section]
        if let headerItem = section.header, height = headerItem.height {
            return height
        }
        if section.title == nil {
            return 0
        }
        return defaultHeaderHeight
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.registerReuseIdentifiersIfNeeded(tableView)
        
        let item = self.item(atIndexPath: indexPath)
        if let identifier = item.reuseIdentifier, cell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            if let tableCell = cell as? TableCell {
                tableCell.dataSource = self
            }
            item.configureView(cell)
            return cell
        } else {
            // This is an error state.  TODO: only on debug
            let cell = UITableViewCell()
            cell.textLabel?.text = "Error: can't instantiate cell (\(item.reuseIdentifier))"
            cell.backgroundColor = UIColor.redColor()
            return cell
        }
    }
   
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.canMoveItem(atIndexPath: indexPath) || self.canDeleteItem(atIndexPath: indexPath)
    }
    
    private func canDeleteItem(atIndexPath indexPath:NSIndexPath) -> Bool {
        return self.item(atIndexPath: indexPath).onDelete != nil
    }
    
    private func deleteItem(atIndexPath indexPath:NSIndexPath) {
        let item = self.item(atIndexPath: indexPath)
        item.handleDelete()
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteItem(atIndexPath: indexPath)

            let section = self.sections[indexPath.section]
            section.deleteItemAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            if section.items.count == 0 {
                self.sections.removeAtIndex(indexPath.section)
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
        }
    }
    
    // MARK: - 
    
    func registerReuseIdentifiersIfNeeded(tableView:UITableView) {
        if !self.didRegisterReuseIdentifiers {
            self.registerReuseIdentifiers(tableView)
        }
    }
    
    public func registerReuseIdentifiers(tableView:UITableView) {
        for section in self.sections {
            
            if let header = section.header, identifier = header.reuseIdentifier {
                if let nibName = header.nibName {
                    if NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") != nil {
                        tableView.registerNib(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
                    }
                } else {
                    tableView.registerClass(header.viewType, forHeaderFooterViewReuseIdentifier: identifier)
                }
            }
            
            for item in section.items {
                if let rowClass = item.viewType, identifier = item.reuseIdentifier {
                    
                    // If we've explicitly specified an identifier, we'll just use the storyboard prototype
                    if item.storyboardIdentifier == nil {
                        
                        if let nibName = item.nibName {
                            if NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") != nil {
                                tableView.registerNib(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier)
                            }
                        } else {
                            tableView.registerClass(rowClass, forCellReuseIdentifier: identifier)
                        }
                    }
                    
                }
            }
        }
        self.didRegisterReuseIdentifiers = true
    }
}