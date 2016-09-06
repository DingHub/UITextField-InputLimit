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
            return (objc_getAssociatedObject(self, &AssociatedKeys.isMoneyKey) as? Bool)!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isMoneyKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                keyboardType = .DecimalPad   //  We should set key type as decimalPad at first
                addMoneyObserver()
            }
        }
    }
}

private extension UITextField {
    
    func addMoneyObserver() {
        self.addTarget(self, action: #selector(observeMoney), forControlEvents: .EditingChanged)
    }
    
    @objc func observeMoney() {
        guard isMoney else { return }
        
        let allText = text
        
        var newText = allText
        if let correctText = correctText {
            if let oldTextRange = allText?.rangeOfString(correctText) {
                newText = allText?.substringFromIndex(oldTextRange.endIndex)
            }
        }
        
        let set = NSCharacterSet(charactersInString: "0123456789.").invertedSet
        let fitered = (newText?.componentsSeparatedByCharactersInSet(set))?.joinWithSeparator("")
        if fitered == nil || fitered?.characters.count == 0 {
            if newText == "" {//inputed backSpace
                correctText = newText
            }
            text = correctText
            return
        }
        
        if let correctText = correctText {
            if correctText.containsString(".") {
                if newText == "." {//only one "."
                    text = correctText
                    return
                }
                //2 charactors limited after "."
                let array = correctText.componentsSeparatedByString(".")
                if array.count == 2 {
                    if ((array.last)! as String).characters.count >= 2 {
                        let newStringArray = newText?.componentsSeparatedByString(".")
                        if newStringArray?.count == 2 && ((newStringArray?.last)! as String).characters.count == 1 {//inputed backSpace
                            self.correctText = newText
                        }
                        text = self.correctText
                        return
                    }
                }
            } else if correctText.characters.count == 1 {
                if newText == "0" && self.correctText == "0" {
                    text = self.correctText
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
            if newText != "." && Int(newText!) > 0 {//'0'->other numbers
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
        static var isMoneyKey = "isMoneyKey"
        static var correctTextKey = "correctTextKey"
    }
}
