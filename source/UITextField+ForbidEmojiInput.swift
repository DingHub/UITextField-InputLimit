//
//  UITextField+ForbidEmojiInput.swift
//  UITextField-InputLimit
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

extension UITextField {
    
    @IBInspectable public var noEmoji: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.noEmojiKey) as? Bool)!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.noEmojiKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                addEmojiObserver()
            }
        }
    }
    
    private func addEmojiObserver() {
        self.addTarget(self,
                       action: #selector(observeEmoji),
                       forControlEvents: .EditingChanged)
    }
    
    @objc private func observeEmoji() {
        
        guard noEmoji else { return }
        
        let primaryLaguage = textInputMode?.primaryLanguage
        if primaryLaguage == nil || primaryLaguage == "emoji" {
            text = helperValues.oldText
            return
        }
        helperValues.oldText = text
    }
    
    private struct helperValues {
        static var oldText: String?
    }
    
    private struct AssociatedKeys {
        static var noEmojiKey = "noEmojiKey"
    }

}
