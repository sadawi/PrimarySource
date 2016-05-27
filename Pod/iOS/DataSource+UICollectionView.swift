//
//  DataSource+UICollectionView.swift
//  Pods
//
//  Created by Sam Williams on 1/28/16.
//
//

import UIKit

extension DataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func registerPresenterIfNeeded(collectionView collectionView:UICollectionView) {
        if self.presenter == nil {
            self.presenter = collectionView
        }
    }

    // MARK: - Delegate methods
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.visibleSections.count
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self[section]?.itemCount ?? 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        self.registerPresenterIfNeeded(collectionView: collectionView)
        
        if let item = self.item(atIndexPath: indexPath), let identifier = item.reuseIdentifier {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
            item.configureView(cell)
            return cell
        } else {
            // This is an error state.  TODO: only on debug
            let cell = UICollectionViewCell()
            cell.backgroundColor = UIColor.redColor()
            return cell
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        self.item(atIndexPath: indexPath)?.onTap()
    }
}