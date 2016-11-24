//
//  UITextField+RegulateMoneyInput.swift
//  UITextField-InputLimit
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

public extension UITextField {
    
    @IBInspectable public var isMoney: Bool {
        get {
            if let associated = objc_getAssociatedObject(self, &AssociatedKeys.isMonewKey)
                as? Bool {
                return associated
            }
            let associated = false
            objc_setAssociatedObject(self, &AssociatedKeys.isMonewKey, associated, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return associated
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isMonewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                keyboardType = .decimalPad   //  We should set key type as decimalPad at first
                addMoneyObserver()
            }
        }
    }
}


private extension UITextField {
    
    func addMoneyObserver() {
        self.addTarget(self, action: #selector(observeMoney), for: .editingChanged)
    }
    
    @objc func observeMoney() {
        guard isMoney else { return }
        
        let allText = text
        
        var newText = allText
        if let correctText = correctText {
            if let oldTextRange = allText?.range(of: correctText) {
                newText = allText?.substring(from: oldTextRange.upperBound)
            }
        }
        
        let set = CharacterSet(charactersIn: "0123456789.").inverted
        let fitered = (newText?.components(separatedBy: set))?.joined(separator: "")
        
        if fitered == nil || fitered?.characters.count == 0 {
            if newText == "" {//inputed backSpace
                correctText = newText
            }
            text = correctText
            return
        }
        
        if let correctText = correctText {
            if correctText.contains(".") {
                if newText == "." {//only one "."
                    text = correctText
                    return
                }
                //2 charactors limited after "."
                let array = correctText.components(separatedBy: ".")
                if array.count == 2 {
                    if ((array.last)! as String).characters.count >= 2 {
                        let newStringArray = newText?.components(separatedBy: ".")
                        if newStringArray?.count == 2 && ((newStringArray?.last)! as String).characters.count == 1 {//inputed backSpace
                            self.correctText = newText
                        }
                        text = self.correctText
                        return
                    }
                }
            } else if correctText.characters.count == 1 {
                if newText == "0" && correctText == "0" {
                    text = correctText
                    return
                }
            }
        }
        
        if (correctText == nil || correctText?.characters.count == 0) && newText == "." {//"."->"0."
            correctText = "0."
            text = "0."
            return
        }
        if correctText?.characters.count == 1 && correctText == "0" {
            if newText != "." && Int(newText!)! > 0 {//'0'->other numbers
                correctText = newText
                text = newText
                return
            }
        }
        correctText = allText
    }
    
    var correctText: String? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.correctTextKey) as? String)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.correctTextKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    struct AssociatedKeys {
        static var isMonewKey = "isMonewKey"
        static var correctTextKey = "correctTextKey"
    }
}
