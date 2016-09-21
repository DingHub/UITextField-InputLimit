//
//  ViewController.swift
//  UITextField-InputLimit
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

let kMaxMoney: Double = 100.00

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTopTextField()
    }
    
    func addTopTextField() {
        let screenWidth = UIScreen.main.bounds.size.width
        let textFrame = CGRect(x: 15, y: 80, width: screenWidth - 30, height: 30)
        let topTextField = UITextField(frame: textFrame)
        topTextField.borderStyle = .roundedRect
        topTextField.placeholder = String(format: "Money && amount <= %.2f", kMaxMoney)
        topTextField.delegate = self
        view.addSubview(topTextField)
        // We hope input only money in this textField.
        topTextField.isMoney = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let fullText = textField.text {
            let newString = (fullText as NSString).replacingCharacters(in: range, with: string)
            if let value = Double(newString) {
                if value - kMaxMoney > 0.009999 {// amount should <= kMaxMoney
                    return false
                }
            }
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

