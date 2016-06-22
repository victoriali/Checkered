//
//  Tile.swift
//  Checkered
//
//  Created by Wing Man Li on 12/6/2016.
//  Copyright © 2016 Victoria Li. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


enum TileType: Int, CustomStringConvertible {
    case Black
    case Red

    var tileColor: String {
        let tileColors = ["Black","Red"]
        return tileColors[rawValue]
    }
    
    var description: String {
        return tileColor
    }
    
    static func random() -> TileType {
        
        let val = Int(arc4random_uniform(2))
        
        let type = TileType(rawValue: val)
  
        return type!
        
    }
}


class Tile: CustomStringConvertible, Hashable {
    
    var column: Int
    var row: Int
    var tileType: TileType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, tileType: TileType) {
        self.column = column
        self.row = row
        self.tileType = tileType
    }
    
    var description: String {
        return "type:\(tileType) square:(\(column),\(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
    
}

func ==(lhs: Tile, rhs: Tile) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}