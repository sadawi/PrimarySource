//
//  CollectionDataSource.swift
//  CollectionDataSource
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

public class DataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var sections:[Section] = []
    var didRegisterReuseIdentifiers = false

    public var reorderingMode:ReorderingMode = .WithinSections
    public var reorder:((NSIndexPath, NSIndexPath) -> Void)?
    
    public override init() {
        
    }
    
    public func serialize() -> [String:AnyObject] {
        let result:[String:AnyObject] = [:]
        // TODO
        return result
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
        return self.item(atIndexPath: indexPath).onTap != nil
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
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.item(atIndexPath: indexPath).handleTap()
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.registerReuseIdentifiersIfNecessary(tableView)
        
        let item = self.item(atIndexPath: indexPath)
        if let identifier = item.reuseIdentifier, cell = tableView.dequeueReusableCellWithIdentifier(identifier) {
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
    
    func registerReuseIdentifiersIfNecessary(tableView:UITableView) {
        if !self.didRegisterReuseIdentifiers {
            self.registerReuseIdentifiers(tableView)
        }
    }
    
    public func registerReuseIdentifiers(tableView:UITableView) {
        for section in self.sections {
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


infix operator <<< { associativity left precedence 95 }
public func <<<(left:DataSource, right:Section) {
    left.addSection(right)
}