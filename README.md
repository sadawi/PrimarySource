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
 		 
```swift
pod "PrimarySource"
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

