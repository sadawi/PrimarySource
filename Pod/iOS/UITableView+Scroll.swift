//
//  UITableView+Scroll.swift
//  Pods
//
//  Created by Sam Williams on 1/21/16.
//
//

import UIKit

extension UITableView {
    /**
     Scrolls to a row, but only if that row exists.
     */
    func safe_scrollToRowAtIndexPath(_ indexPath: IndexPath, atScrollPosition scrollPosition: UITableViewScrollPosition, animated: Bool) {
        if self.numberOfSections > (indexPath as NSIndexPath).section && self.numberOfRows(inSection: (indexPath as NSIndexPath).section) > (indexPath as NSIndexPath).row  {
            self.correct_scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: animated)
        }
    }
    
    /**
     Attempting to scroll to a row can result in an incorrect offset.  This is a hacky fix for that.
     
     http://stackoverflow.com/questions/20892661/uitableview-scrolltorowatindexpath-scrolls-to-wrong-offset-with-estimatedrowheig
     */
    func correct_scrollToRowAtIndexPath(_ indexPath: IndexPath, atScrollPosition scrollPosition: UITableViewScrollPosition, animated: Bool) {
        self.setContentOffset(CGPoint.zero, animated: true)
        let delayTime = DispatchTime.now() + Double(Int64(0.05 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.scrollToRow(at: indexPath, at: .middle, animated: animated)
        }
    }
}
