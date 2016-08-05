//
//  UITextField+LimitLength.swift
//  UITextField-InputLimit
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

extension UITextField {
    
    @IBInspectable public var maxLength: Int {//    maxLength<=0    <=>     no limit
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.maxLengthKey) as? Int)!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.maxLengthKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            addLengthObserver()
        }
    }
    
    private func addLengthObserver() {
        self.addTarget(self,
                       action: #selector(observeLength),
                       forControlEvents: .EditingChanged)
    }
    
    @objc private func observeLength() {
        guard maxLength > 0 else { return }
        /// deal with Chinese, Japanese,... input, when input somothing like pinyin, we will not judge the length
        let selectedRange = markedTextRange
        if selectedRange == nil || selectedRange?.start == nil {
            if let text = self.text {
                if text.characters.count > maxLength {
                    let index = text.startIndex.advancedBy(maxLength)
                    self.text = text.substringToIndex(index)
                }
            }
        }
    }
    
    private struct AssociatedKeys {
        static var maxLengthKey = "maxLengthKey"
    }
    
}
