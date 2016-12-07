//
//  MapCell.swift
//  Pods
//
//  Created by Sam Williams on 12/3/15.
//
//

import Foundation
import MapKit
import UIKit

open class MapCell: TableCell {
    open var mapView:MKMapView?
    
    open var mapHeight:CGFloat {
        get {
            return mapHeightConstraint.constant
        }
        set {
            self.mapHeightConstraint.constant = newValue
        }
    }
    
    fileprivate var mapHeightConstraint:NSLayoutConstraint!
    
    open override func buildView() {
        super.buildView()
        
        let view = MKMapView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        let views = ["v": view]
        let metrics:[String:CGFloat] = [:]
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-|", options: [], metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: [], metrics: metrics, views: views))

        self.mapHeightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        view.addConstraints([self.mapHeightConstraint])

        self.mapView = view
    }
}
