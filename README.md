# PrimarySource

## Overview

This is a Swift library for setting up data sources for UITableViews and UICollectionViews.

<!--
## Installation

PrimarySource is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:		
 		 
```ruby
pod "PrimarySource"
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.
-->

## Usage

### Setting up the data source

Create a `DataSource` object and set it as your UITableView/UICollectionView delegate and dataSource.  A DataSource contains Sections, and each section contains items.  Items are responsible for configuring cells, which may have been reused.

You'll probably want a method to rebuild the data source whenever you get new data:

```swift
func loadData()
    self.dataSource = DataSource()
    self.tableView.delegate = self.dataSource
    self.tableView.dataSource = self.dataSource
    
    self.dataSource <<< Section(title: "Form") { section in
        section <<< CollectionItem<TextFieldCell> { cell in
            cell.title = "Name"
            cell.onChange = { [unowned cell] in
                print("New value: \(cell.value)")
            }
        }
    }
    
    self.tableView.reloadData()
}
```

### Cell registration

A cell can be created in several ways:

* By class (instantiated purely from code)
```swift
section <<< CollectionItem<TextFieldCell>()
```

* By storyboard identifier (using dynamic prototypes from the storyboard)
```swift
section <<< CollectionItem<TextFieldCell>(storyboardIdentifier: "NormalTextCell")
```
* From a nib
```swift
section <<< CollectionItem<TextFieldCell>(nibName: "NormalTextCellNib")
```

### Cell types

A number of cell types are included.

Display cells:
* `TableCell`
* `SubtitleCell`
* `ActivityIndicatorCell`

Interactive cells:
* `ButtonCell`

Field cells (each with a field and a strongly typed `value`):
* `TextFieldCell` (UITextField, String)
* `SwitchCell` (UISwitch, Boolean)
* `DateFieldCell` (UIDatePicker, NSDate)
* `PushSelectCell` (typed set of options, selectable in a pushed view controller)
* `EmailAddressCell` (String)
* `PhoneNumberCell` (String)
* `IntegerCell` (Int)
* `PasswordCell` (String)
* `StepperCell` (UIStepper, Int)
* `SliderCell` (UISlider, Float)

### Cell action handlers

Handlers can be added for actions like deleting, tapping, and reordering cells.  Adding a handler will enable the corresponding action in the UI: swipe to delete will become possible, the cells will highlight on tap, and the reordering accessory views will appear in edit mode.

Handlers can be added for cell-level actions:

* `onDelete`
* `onTap`

```swift
section <<< TableViewItem<TextFieldCell> { cell in
    cell.title = "Name"
    // ...
}.onTap { _ in
    print("tapped") 
}.onDelete { _ in 
    print("deleted") 
}
```

And section-level actions:
* `onReorder`

```swift
dataSource <<< Section { section in
    // ...
}.onReorder { sourceIndexPath, destinationIndexPath in 
    // ...
}
```

## TODO

* support for UICollectionViews
