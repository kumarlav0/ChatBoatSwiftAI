//
//  CustomButton.swift
//  ChatBoatSwiftAI
//
//  Created by macmini46 on 28/03/23.
//

import UIKit

class CustomButton: UIButton {
    
    @IBInspectable var cornerRadious: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
