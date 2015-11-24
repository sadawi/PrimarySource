//
//  CollectionDataSource.swift
//  CollectionDataSource
//
//  Created by Sam Williams on 11/23/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation


public class DataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var sections:[Section] = []
    var didRegisterReuseIdentifiers = false
    
    public override init() {
        
    }
    
    public func addSection(section:Section) {
        self.sections.append(section)
    }
    
    func itemForIndexPath(indexPath: NSIndexPath) -> CollectionItem {
        return self.sections[indexPath.section].items[indexPath.row]
    }
    
    // MARK: - UITableViewDataSource methods
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.itemForIndexPath(indexPath).handleTap()
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.registerReuseIdentifiersIfNecessary(tableView)
        
        let item = self.itemForIndexPath(indexPath)
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
        let item = self.itemForIndexPath(indexPath)
        return item.onDelete != nil
    }
    
    private func deleteItemAtIndexPath(indexPath:NSIndexPath) {
        let item = self.itemForIndexPath(indexPath)
        item.handleDelete()
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteItemAtIndexPath(indexPath)

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