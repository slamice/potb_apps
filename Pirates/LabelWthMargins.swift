//
//  LabelWithMargins.swift
//  Pirates Of Tokyo Bay
//
//  Created by Issam Zeibak on 9/13/16.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//

import Foundation

class LabelWithMargins:UILabel {
    
    var top = 0
    var left = 5
    var bottom = 5
    var right = 5
    
    func setupMargins(top: Int, left: Int, bottom: Int, right: Int){
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: CGFloat(self.top), left: CGFloat(self.left),
            bottom: CGFloat(self.bottom), right: CGFloat(self.right))
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}
