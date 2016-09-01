//
//  DataSource+UIScrollView.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import UIKit

extension DataSource: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        self.didScroll?()
    }
}