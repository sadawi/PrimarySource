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
    var numbersSection: ListSection<Int>? {
        return self.dataSource["numbers"] as? ListSection<Int>
    }
    
    var visible:Bool? = true {
        didSet {
            if let item = self.dataSource["visibility"]?["item"] {
                self.visible==true ? item.show() : item.hide()
            }
        }
    }
    
    override func configureDataSource(dataSource: DataSource) {

        dataSource <<< ListSection(values: self.numbers, title: "Numbers", key: "numbers") { value, index in
            return TableViewItem<UITableViewCell> { cell in
                cell.textLabel?.text = "Value \(value)"
                }.onTap { [weak self] _ in
                    self?.removeNumber(value)
                }.delete { [weak self] _ in
                    self?.removeNumber(value)
            }
        }
        
        dataSource <<< Section { section in
            section <<< TableViewItem<ButtonCell> { cell in
                cell.title = "Add"
                cell.onTap = { [weak self] in
                    self?.addNumber()
                }
            }
        }
        
        dataSource <<< Section(title: "Visibility", key: "visibility") { section in
            section <<< TableViewItem<SwitchCell> { [weak self] cell in
                cell.title = "Visible"
                cell.value = self?.visible
                cell.onChange = { [weak cell] in
                    self?.visible = cell?.value
                }
            }
            section <<< TableViewItem<TableCell>(key: "item") { cell in
                cell.textLabel?.text = "Some item"
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