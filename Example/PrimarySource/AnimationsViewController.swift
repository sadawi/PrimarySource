//
//  AnimationsViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 1/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import PrimarySource

class AnimationsViewController: DataSourceViewController {
    var numbers:[Int] = [0, 1, 1]
    var numbersSection:Section?
    
    override func configureDataSource(dataSource: DataSource) {

        self.numbersSection = ListSection(values: self.numbers) { value in
            return TableViewItem<UITableViewCell> { cell in
                cell.textLabel?.text = "Value \(value)"
            }
        }
        dataSource <<< self.numbersSection
        
        dataSource <<< Section { section in
            section <<< TableViewItem<ButtonCell> { cell in
                cell.title = "Add"
                cell.onTap = { [weak self] in
                    self?.addNumber()
                }
            }
        }

//        self.numbersSection = Section(title: "List", key: "list") { section in
//            for i in self.numbers {
//                section <<< TableViewItem<UITableViewCell> { cell in
//                    cell.textLabel?.text = "Value \(i)"
//                }
//            }
//        }
//        dataSource <<< self.numbersSection
//        
//        dataSource <<< Section { section in
//            section <<< TableViewItem<ButtonCell> { cell in
//                cell.title = "Add"
//                cell.onTap = { [weak self] in
//                    self?.addNumber()
//                }
//            }
//        }
    }
    
    func addNumber() {
        let count = self.numbers.count
        self.numbers.append(count)
        let indexPath = NSIndexPath(forRow: count, inSection: self.dataSource.sectionCount-2)
        self.buildDataSource()
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
}