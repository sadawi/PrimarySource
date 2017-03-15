//
//  DataSource+UITableView.swift
//  Pods
//
//  Created by Sam Williams on 1/28/16.
//
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension DataSource: UITableViewDelegate, UITableViewDataSource {
    
    func registerPresenterIfNeeded(tableView:UITableView) {
        if !self.didRegisterPresenter {
            self.registerPresenter(tableView)
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.canMoveItem(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if self.canMoveItem(from: sourceIndexPath, to: destinationIndexPath) {
            if self.reorderingMode == .withinSections {
                self[(sourceIndexPath as NSIndexPath).section]?.handleReorder(fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
            } else if let reorder = self.reorder {
                reorder(sourceIndexPath, destinationIndexPath)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return self.canMoveItem(from: sourceIndexPath, to: proposedDestinationIndexPath) ? proposedDestinationIndexPath : sourceIndexPath
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if self.item(at: indexPath)?.tappable == true {
            return true
        }
        
        if tableView.cellForRow(at: indexPath) is TappableTableCell {
            return true
        }
        
        return false
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self[section]?.title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section]?.itemCount ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.visibleSections.count
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.item(at: indexPath)?.onAccessoryTap()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        
        self.item(at: indexPath)?.onTap()
        
        if let tappable = tableView.cellForRow(at: indexPath) as? TappableTableCell {
            tappable.handleTap()
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = self[section] else { return nil }
        
        if let headerItem = section.header, let identifier = headerItem.reuseIdentifier {
            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) {
                headerItem.configure(header)
                return header
            }
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sizeClosure = self.item(at: indexPath)?.desiredSize {
            return sizeClosure().height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footerHeight = self.defaultSectionFooterHeight {
            if footerHeight == 0 {
                // Forced min
                return CGFloat.leastNormalMagnitude
            } else {
                return footerHeight
            }
        } else {
            // Default
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = self[section] else { return 0 }
        
        if let headerItem = section.header, let height = headerItem.height {
            return height
        }
        
        if let defaultHeaderHeight = self.defaultSectionHeaderHeight {
            return defaultHeaderHeight
        }
        
        if section.title == nil {
            return CGFloat.leastNormalMagnitude
        }
        return DataSource.defaultSectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.registerPresenterIfNeeded(tableView: tableView)
        
        if let item = self.item(at: indexPath), let identifier = item.reuseIdentifier, let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            if let tableCell = cell as? TableCell {
                tableCell.dataSource = self
            }
            item.configure(cell)
            self.configureView?(cell)
            
            // Might be nice to have this handled by cell or item somehow
            if let isSselected = item.isSelected {
                let selected = isSselected(item)
                if selected {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            
            return cell
        } else {
            // This is an error state.  TODO: only on debug
            let cell = UITableViewCell()
            cell.textLabel?.text = "Error: can't instantiate cell"
            cell.backgroundColor = UIColor.red
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.canMoveItem(at: indexPath) || self.canEditItem(atIndexPath: indexPath)
    }
    
    fileprivate func canEditItem(atIndexPath indexPath:IndexPath) -> Bool {
        let item = self.item(at: indexPath)
        
        return self.canDeleteItem(atIndexPath: indexPath) || item?.editActionList?.actionItems.count > 0
    }
    
    fileprivate func canDeleteItem(atIndexPath indexPath:IndexPath) -> Bool {
        let item = self.item(at: indexPath)
        return item?.deletable == true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = self.item(at: indexPath) {
                item.willDelete()
                
                if !item.handlesDelete {
                    if let section = self[(indexPath as NSIndexPath).section] {
                        section.deleteItemAtIndex((indexPath as NSIndexPath).row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                } else {
                    item.delete()
                }
                
                item.didDelete()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let item = self.item(at: indexPath) {
            if let actionList = item.editActionList {
                var result: [UITableViewRowAction] = []
                for actionItem in actionList.actionItems {
                    let rowAction = UITableViewRowAction(style: .normal, title: actionItem.title, handler: { (action, indexPath) in
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
