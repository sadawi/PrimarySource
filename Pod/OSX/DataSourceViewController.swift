//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Sam Williams on 5/26/16.
//
//

import Foundation
import Cocoa
import PrimarySource

protocol DataSourceViewController {
    var presenterView: CollectionPresenter? { get }
    func configureDataSource(dataSource: ColumnedDataSource)
}