//
//  UITextField+RegulateMoneyInput.swift
//  UITextField-InputLimit
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

extension UITextField {
    
    @IBInspectable public var isMoney: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.isMoneyKey) as? Bool)!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isMoneyKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                keyboardType = .NumberPad   //  We should set key type as decimalPad at first
                addMoneyObserver()
            }
        }
    }
    
    private func addMoneyObserver() {
        self.addTarget(self,
                       action: #selector(observeMoney),
                       forControlEvents: .EditingChanged)
    }
    
    @objc private func observeMoney() {
        guard isMoney else { return }
        
        let allText = text
        
        var newText = allText
        if let correctText = HelperValues.correctText {
            if let oldTextRange = allText?.rangeOfString(correctText) {
                newText = allText?.substringFromIndex(oldTextRange.endIndex)
            }
        }
        
        let set = NSCharacterSet(charactersInString: "0123456789.").invertedSet
        let fitered = (newText?.componentsSeparatedByCharactersInSet(set))?.joinWithSeparator("")
        if fitered == nil || fitered?.characters.count == 0 {
            if newText == "" {//inputed backSpace
                HelperValues.correctText = newText
            }
            text = HelperValues.correctText
            return
        }
        
        if let correctText = HelperValues.correctText {
            if correctText.containsString(".") {
                if newText == "." {//only one "."
                    text = HelperValues.correctText
                    return
                }
                //2 charactors limited after "."
                let array = HelperValues.correctText?.componentsSeparatedByString(".")
                if array?.count == 2 {
                    if ((array?.last)! as String).characters.count >= 2 {
                        let newStringArray = newText?.componentsSeparatedByString(".")
                        if newStringArray?.count == 2 && ((newStringArray?.last)! as String).characters.count == 1 {//inputed backSpace
                            HelperValues.correctText = newText
                        }
                        text = HelperValues.correctText
                        return
                    }
                }
            } else if correctText.characters.count == 1 {
                if newText == "0" && HelperValues.correctText == "0" {
                    text = HelperValues.correctText
                    return
                }
            }
        }
        
        if HelperValues.correctText?.characters.count == 0 && newText == "." {//"."->"0."
            HelperValues.correctText = "0."
            text = "0."
            return
        }
        if HelperValues.correctText?.characters.count == 1 && HelperValues.correctText == "0" {
            if newText != "." && Int(newText!) > 0 {//'0'->other numbers
                HelperValues.correctText = newText
                text = newText
                return
            }
        }
        HelperValues.correctText = allText
    }
    
    private struct HelperValues {
        static var correctText: String?
    }
    
    private struct AssociatedKeys {
        static var isMoneyKey = "isMoneyKey"
    }
}
