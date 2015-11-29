# PrimarySource

## Overview

This is a Swift library for setting up data sources for UITableViews and UICollectionViews.

```swift
dataSource <<< Section(title: "Form") { section in
    section <<< TableViewItem<TextFieldCell> { cell in
        cell.title = "Name"
        cell.onChange = { [weak cell] in
            print("New value: \(cell?.value)")
        }
    }
}
```

## Installation

CollectionDataSource is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:		
 		 
```ruby
pod "PrimarySource"
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

### Setting up the data source

Data sources should be set as your UITableView/UICollectionView delegate and dataSource.  A DataSource contains Sections, and each section contains items.

Items are responsible for configuring cells, which may have been reused.

### Cell registration

A cell can be created in several ways:

* By class (instantiated purely from code)
```swift
section <<< TableViewItem<TextFieldCell>()
```

* By storyboard identifier (using dynamic prototypes from the storyboard)
```swift
section <<< TableViewItem<TextFieldCell>(storyboardIdentifier: "NormalTextCell")
```
* From a nib
```swift
section <<< TableViewItem<TextFieldCell>(nibName: "NormalTextCellNib")
```
