//
//  DataSource+UITableView.swift
//  Pods
//
//  Created by Sam Williams on 1/28/16.
//
//

import UIKit

extension DataSource: UITableViewDelegate, UITableViewDataSource {
    
    func registerPresenterIfNeeded(tableView tableView:UITableView) {
        if !self.didRegisterPresenter {
            self.registerPresenter(tableView)
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.canMoveItem(atIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if self.canMoveItem(fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath) {
            if self.reorderingMode == .WithinSections {
                self[sourceIndexPath.section]?.handleReorder(fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
            } else if let reorder = self.reorder {
                reorder(sourceIndexPath, destinationIndexPath)
            }
        }
    }
    
    public func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        return self.canMoveItem(fromIndexPath: sourceIndexPath, toIndexPath: proposedDestinationIndexPath) ? proposedDestinationIndexPath : sourceIndexPath
    }
    
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.item(atIndexPath: indexPath)?.tappable == true {
            return true
        }
        
        if tableView.cellForRowAtIndexPath(indexPath) is TappableTableCell {
            return true
        }
        
        return false
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self[section]?.title
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section]?.itemCount ?? 0
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.visibleSections.count
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.item(atIndexPath: indexPath)?.onAccessoryTap()
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        
        self.item(atIndexPath: indexPath)?.onTap()
        
        if let tappable = tableView.cellForRowAtIndexPath(indexPath) as? TappableTableCell {
            tappable.handleTap()
        }
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = self[section] else { return nil }
        
        if let headerItem = section.header, identifier = headerItem.reuseIdentifier {
            if let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) {
                headerItem.configureView(header)
                return header
            }
        }
        return nil
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let sizeClosure = self.item(atIndexPath: indexPath)?.desiredSize {
            return sizeClosure().height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = self[section] else { return 0 }
        
        if let headerItem = section.header, height = headerItem.height {
            return height
        }
        if section.title == nil {
            return 0
        }
        return defaultHeaderHeight
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.registerPresenterIfNeeded(tableView: tableView)
        
        if let item = self.item(atIndexPath: indexPath), let identifier = item.reuseIdentifier, cell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            if let tableCell = cell as? TableCell {
                tableCell.dataSource = self
            }
            item.configureView(cell)
            return cell
        } else {
            // This is an error state.  TODO: only on debug
            let cell = UITableViewCell()
            cell.textLabel?.text = "Error: can't instantiate cell"
            cell.backgroundColor = UIColor.redColor()
            return cell
        }
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.canMoveItem(atIndexPath: indexPath) || self.canEditItem(atIndexPath: indexPath)
    }
    
    private func canEditItem(atIndexPath indexPath:NSIndexPath) -> Bool {
        let item = self.item(atIndexPath: indexPath)
        
        return self.canDeleteItem(atIndexPath: indexPath) || item?.editActionList?.actionItems.count > 0
    }
    
    private func canDeleteItem(atIndexPath indexPath:NSIndexPath) -> Bool {
        let item = self.item(atIndexPath: indexPath)
        return item?.deletable == true
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let item = self.item(atIndexPath: indexPath) {
                item.willDelete()
                
                if !item.handlesDelete {
                    if let section = self[indexPath.section] {
                        section.deleteItemAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                } else {
                    item.delete()
                }
                
                item.didDelete()
            }
        }
    }
    
    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if let item = self.item(atIndexPath: indexPath) {
            if let actionList = item.editActionList {
                var result: [UITableViewRowAction] = []
                for actionItem in actionList.actionItems {
                    let rowAction = UITableViewRowAction(style: .Normal, title: actionItem.title, handler: { (action, indexPath) in
                        actionItem.action?()
                    })
                    if let color = actionItem.color as? UIColor {
                        rowAction.backgroundColor = color
                    }
                    result.append(rowAction)
                }
                return result
            }
        }
        return nil
    }
}