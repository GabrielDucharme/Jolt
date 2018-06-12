//
//  UITextFieldExtension.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-06-02.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import Foundation

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
