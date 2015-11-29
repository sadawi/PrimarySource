# PrimarySource

## Overview

**PrimarySource** is a Swift library for setting up data sources for UITableViews and UICollectionViews.

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

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

