//
//  UITextField+ForbidEmojiInput.swift
//  UITextField-InputLimit
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

public extension UITextField {
    
    @IBInspectable public var noEmoji: Bool {
        get {
            if let associated = objc_getAssociatedObject(self, &AssociatedKeys.noEmojiKey)
                as? Bool { return associated }
            let associated = false
            objc_setAssociatedObject(self, &AssociatedKeys.noEmojiKey, associated,
                                     .OBJC_ASSOCIATION_ASSIGN)
            return associated
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.noEmojiKey, newValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                addEmojiObserver()
            }
        }
    }
}


private extension UITextField {
    func addEmojiObserver() {
        self.addTarget(self, action: #selector(observeEmoji), for: .editingChanged)
    }
    
    @objc func observeEmoji() {
        
        guard noEmoji else { return }
        
        let primaryLaguage = textInputMode?.primaryLanguage
        if primaryLaguage == nil || primaryLaguage == "emoji" {
            text = oldText
            return
        }
        oldText = text
    }
    
    var oldText: String? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.oldTextKey) as? String)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.oldTextKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    struct AssociatedKeys {
        static var oldTextKey = "oldTextKey"
        static var noEmojiKey = "noEmojiKey"
    }
}
