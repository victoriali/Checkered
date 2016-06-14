//
//  Tile.swift
//  Checkered
//
//  Created by Wing Man Li on 12/6/2016.
//  Copyright © 2016 Victoria Li. All rights reserved.
//

import SpriteKit

enum TileType: Int, CustomStringConvertible {
    case Unknown = 0, Black, White

    var spriteName: String {
        let spriteNames = [
            "Black",
            "White"]
        return spriteNames[rawValue - 1]
    }
    
    var description: String {
        return spriteName
    }
    
    static func random() -> TileType {
        return TileType(rawValue: Int(arc4random_uniform(2)) + 1)!
    }
}


class Tile: CustomStringConvertible, Hashable {
    
    var column: Int
    var row: Int
    let tileType: TileType
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