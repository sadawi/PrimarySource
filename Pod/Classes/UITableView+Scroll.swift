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
    func safe_scrollToRowAtIndexPath(indexPath: NSIndexPath, atScrollPosition scrollPosition: UITableViewScrollPosition, animated: Bool) {
        if self.numberOfSections > indexPath.section && self.numberOfRowsInSection(indexPath.section) > indexPath.row  {
            self.correct_scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: animated)
        }
    }
    
    /**
     Attempting to scroll to a row can result in an incorrect offset.  This is a hacky fix for that.
     
     http://stackoverflow.com/questions/20892661/uitableview-scrolltorowatindexpath-scrolls-to-wrong-offset-with-estimatedrowheig
     */
    func correct_scrollToRowAtIndexPath(indexPath: NSIndexPath, atScrollPosition scrollPosition: UITableViewScrollPosition, animated: Bool) {
        self.setContentOffset(CGPoint.zero, animated: true)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: animated)
        }
    }
}