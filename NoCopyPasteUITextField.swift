//
//  NoCopyPasteUITextField.swift
//  ReportToDGDA
//
//  Created by user on 3/31/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation


class NoCopyPasteUITextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)){
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
