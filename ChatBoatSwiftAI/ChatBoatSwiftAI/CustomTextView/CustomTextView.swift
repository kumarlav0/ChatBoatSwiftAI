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
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.addPadding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addPadding()
    }
    
    func addPadding () {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 4, right: 4)
    }
    
}
