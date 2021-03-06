//
//  UITextField+LimitLength.swift
//  UITextField-InputLimit
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

public extension UITextField {
    
    @IBInspectable public var maxLength: Int {//    maxLength<=0    <=>     no limit
        get {
            if let associated = objc_getAssociatedObject(self, &AssociatedKeys.maxLengthKey) as? Int {
                return associated
            }
            let associated: Int = 0
            objc_setAssociatedObject(self, &AssociatedKeys.maxLengthKey, associated, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return associated
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.maxLengthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue > 0 {
                addLengthObserver()
            }
        }
    }
}

private extension UITextField {
    
    func addLengthObserver() {
        self.addTarget(self, action: #selector(observeLength), for: .editingChanged)
    }
    
    @objc func observeLength() {
        guard maxLength > 0 else { return }
        /// deal with Chinese, Japanese,... input, when input somothing like pinyin, we will not judge the length
        let selectedRange = markedTextRange
        guard selectedRange == nil || selectedRange?.start == nil else { return }
        guard let text = self.text, text.characters.count > maxLength else { return }
        let index = text.characters.index(text.startIndex, offsetBy: maxLength)
        self.text = text.substring(to: index)
    }
    struct AssociatedKeys {
        static var maxLengthKey = "maxLengthKey"
    }
    
}
