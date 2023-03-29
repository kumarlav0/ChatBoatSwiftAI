//
//  CustomTextView.swift
//  ChatBoatSwiftAI
//
//  Created by macmini46 on 28/03/23.
//

import UIKit

class CustomTextField: UITextView {
    
    @IBInspectable  var cornerRadius: CGFloat {
        
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
