//
//  PushFieldCell.swift
//  Pods
//
//  Created by Sam Williams on 12/11/15.
//
//

import UIKit
import MagneticFields

//public protocol FieldCellEditor {
//    typealias ValueType
//    
//    var value:ValueType? { get set }
//    var didSelectValue:(ValueType? -> Void)? { get set }
//}

/**
 A cell that pushes another view controller for data entry.
*/
public class PushFieldCell<ValueType:Equatable>: FieldCell, Observable {
    public var value:ValueType? {
        didSet {
            self.update()
            self.notifyObservers()
        }
    }
    
    public var observations = ObservationRegistry<ValueType>()
    
    public var valueLabel:UILabel?
//    public var showEditor:(Void -> Void)?
    
    override public func buildView() {
        super.buildView()
        
        let valueLabel = UILabel(frame: CGRect.zero)
        self.addControl(valueLabel)
        self.valueLabel = valueLabel
    }
    
    override public func stylize() {
        super.stylize()
        
        self.valueLabel?.font = self.contentFont
        self.valueLabel?.textColor = self.valueTextColor
        self.accessoryType = .DisclosureIndicator
    }
    
    override func update() {
        super.update()
        if let value = self.value {
            self.valueLabel?.text = String(value)
        } else {
            self.valueLabel?.text = nil
        }
        self.userInteractionEnabled = !self.readonly
    }
//    
//    func buildController<T where T:FieldCellEditor, T:UIViewController, T.ValueType == ValueType>() -> T? {
//        return nil
//    }
    
//    func handleTap() {
//        self.showEditor?()
//        
////        if let presenter = self.dataSource?.presentationViewController() {
////            if let controller = self.buildController() {
////                
//////                self.value = value
//////                self.valueChanged()
//////                presenter.navigationController?.popViewControllerAnimated(true)
////                
////                controller.title = self.title
////                presenter.navigationController?.pushViewController(controller, animated: true)
////            }
////        }
//    }
}
