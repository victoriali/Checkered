//
//  TileView.swift
//  Checkered
//
//  Created by Wing Man Li on 14/6/2016.
//  Copyright © 2016 Victoria Li. All rights reserved.
//

import Foundation
import UIKit

class TileView: UIView {
    unowned let delegate : TileAppearanceProtocol
    
    init(position: CGPoint, tileWidthInner: CGFloat, value: Int, delegate d: TileAppearanceProtocol) {
        delegate = d
        
        super.init(frame: CGRectMake(position.x, position.y,tileWidthInner, tileWidthInner))
        self.value = value
        backgroundColor = delegate.tileColor(value)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var value : Int = 0 {
        didSet {
            backgroundColor = delegate.tileColor(value)
        }
    }
}