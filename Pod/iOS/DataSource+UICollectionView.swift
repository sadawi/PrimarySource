//
//  DataSource+UICollectionView.swift
//  Pods
//
//  Created by Sam Williams on 1/28/16.
//
//

import UIKit

extension DataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func registerPresenterIfNeeded(collectionView:UICollectionView) {
        if !self.didRegisterPresenter {
            self.registerPresenter(collectionView)
        }
    }

    // MARK: - Delegate methods
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.visibleSections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self[section]?.itemCount ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.registerPresenterIfNeeded(collectionView: collectionView)
        
        if let item = self.item(at: indexPath), let identifier = item.reuseIdentifier {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            item.configureView(cell)
            return cell
        } else {
            // This is an error state.  TODO: only on debug
            let cell = UICollectionViewCell()
            cell.backgroundColor = UIColor.red
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.item(at: indexPath)?.onTap()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = self.item(at: indexPath), let size = item.desiredSize?() {
            return size
        } else {
            return self.defaultItemSize
        }
    }
}
