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
            return p_maxLength
        }
        set {
            p_maxLength = newValue
            if newValue > 0 {
                addLengthObserver()
            }
        }
    }
}

fileprivate var p_maxLength = 0

private extension UITextField {
    
    func addLengthObserver() {
        self.addTarget(self, action: #selector(observeLength), for: .editingChanged)
    }
    
    @objc func observeLength() {
        guard maxLength > 0 else { return }
        /// deal with Chinese, Japanese,... input, when input somothing like pinyin, we will not judge the length
        let selectedRange = markedTextRange
        if selectedRange == nil || selectedRange?.start == nil {
            if let text = self.text {
                if text.characters.count > maxLength {
                    let index = text.characters.index(text.startIndex, offsetBy: maxLength)
                    self.text = text.substring(to: index)
                }
            }
        }
    }
}
