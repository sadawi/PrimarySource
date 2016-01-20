//
//  AnimationsViewController.swift
//  PrimarySource
//
//  Created by Sam Williams on 1/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import PrimarySource

class AnimationsViewController: DataSourceViewController {
    var numbers:[Int] = [0, 1, 2]
    var numbersSection:ListSection<Int>?
    
    override func configureDataSource(dataSource: DataSource) {

        self.numbersSection = ListSection(values: self.numbers) { value, index in
            return TableViewItem<UITableViewCell> { cell in
                cell.textLabel?.text = "Value \(value)"
                }.onTap { [weak self] _ in
                    self?.removeNumber(value)
                }.delete { [weak self] _ in
                    self?.removeNumber(value)
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
    }

    func removeNumber(number:Int) {
        if let index = self.numbers.indexOf(number) {
            self.numbers.removeAtIndex(index)
            self.numbersSection?.removeValueAtIndex(index, updateView: true)
        }
    }
    
    func addNumber() {
        let number = (self.numbers.last ?? -1) + 1
        self.numbers.append(number)
        self.numbersSection?.addValue(number, updateView: true)
    }
    
}