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
    var visible2:Bool? = false {
        didSet {
            self.dataSource.refreshDisplay()
        }
    }
    var sectionVisible:Bool? = true {
        didSet {
            self.dataSource.refreshDisplay()
        }
    }
    
    override func configure(_ dataSource: DataSource) {

        dataSource <<< ListSection(values: self.numbers, title: "Numbers", key: "numbers") { value, index in
            return CollectionItem<UITableViewCell> { cell in
                cell.textLabel?.text = "Value \(value)"
                }.onTap { [weak self] _ in
                    self?.removeNumber(value)
                }.delete { [weak self] _ in
                    self?.removeNumber(value)
            }
        }
        
        dataSource <<< Section { section in
            section <<< CollectionItem<ButtonCell> { cell in
                cell.title = "Add"
                }.onTap { [weak self] _ in
                    self?.addNumber()
            }
        }
        
        dataSource <<< Section(title: "Visibility", key: "visibility") { section in
            section <<< CollectionItem<SwitchCell> { [weak self] cell in
                cell.title = "Visible"
                cell.value = self?.visible
                cell.onChange = { _, newValue in
                    self?.visible = newValue
                }
            }
            section <<< CollectionItem<TableCell>(key: "item") { cell in
                cell.textLabel?.text = "Item toggled by key"
            }
            section <<< CollectionItem<SwitchCell> { [weak self] cell in
                cell.title = "Visible 2"
                cell.value = self?.visible2
                cell.onChange = { _, newValue in
                    self?.visible2 = newValue
                }
            }
            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "Item created with visibility condition"
                }.show { [weak self] in
                    return self?.visible2 == true
            }
            
            section <<< CollectionItem<SwitchCell> { [weak self] cell in
                cell.title = "Section Visible"
                cell.value = self?.sectionVisible
                cell.onChange = {  _, newValue in
                    self?.sectionVisible = newValue
                }
            }
        }
        
        dataSource <<< Section(title: "Disappearing Section", key: "disappearing") { section in
            section <<< CollectionItem<TableCell> { cell in
                cell.textLabel?.text = "Some item"
            }
            }.show { [weak self] in
                return self?.sectionVisible == true
        }
    }

    func removeNumber(_ number:Int) {
        if let index = self.numbers.index(of: number) {
            self.numbers.remove(at: index)
            self.numbersSection?.removeValueAtIndex(index, updateView: true)
        }
    }
    
    func addNumber() {
        let number = (self.numbers.last ?? -1) + 1
        self.numbers.append(number)
        self.numbersSection?.addValue(number, updateView: true)
    }
    
}
