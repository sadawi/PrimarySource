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

public class MapCell: TableCell {
    public var mapView:MKMapView?
    
    public var mapHeight:CGFloat {
        get {
            return mapHeightConstraint.constant
        }
        set {
            self.mapHeightConstraint.constant = newValue
        }
    }
    
    private var mapHeightConstraint:NSLayoutConstraint!
    
    public override func buildView() {
        super.buildView()
        
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        let views = ["v": view]
        let metrics:[String:CGFloat] = [:]
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v]-|", options: [], metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[v]-|", options: [], metrics: metrics, views: views))

        self.mapHeightConstraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraints([self.mapHeightConstraint])

        self.mapView = view
    }
}