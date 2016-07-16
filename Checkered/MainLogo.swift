//
//  MainLogo.swift
//  Checkered
//
//  Created by Wing Man Li on 4/7/2016.
//  Copyright © 2016 Victoria Li. All rights reserved.
//

import UIKit

@IBDesignable

class MainLogo: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    @IBInspectable var color: UIColor? {
        didSet {
            layer.backgroundColor = color?.CGColor
        }
    }


}
