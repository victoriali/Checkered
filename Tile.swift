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

protocol TileAppearanceProtocol: class{
    func tileColor(value: Int) -> UIColor
}

enum TileObject {
    case Empty
    case Tile(Int)
}

class TileAppearance: TileAppearanceProtocol {
    func tileColor(value: Int) -> UIColor {
        switch value {
        case 1: //black
            return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        case 2: //brown
            return UIColor(red: 182.0/255.0, green: 85.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        default:
            return UIColor.whiteColor()
        }
    }
}

















//enum TileType: Int, CustomStringConvertible {
//    
//    case Unknown = 0, Black, Brown
//
//    var spriteName: String {
//        let spriteNames = [
//            "Black",
//            "Brown"]
//        return spriteNames[rawValue]
//    }
//    
//    var description: String {
//        return spriteName
//    }
//    
//    static func random() -> TileType {
//        return TileType(rawValue: Int(arc4random_uniform(2)) + 1)!
//    }
//}
//
//
//class Tile: CustomStringConvertible, Hashable {
//    
//    var column: Int
//    var row: Int
//    let tileType: TileType
//    var sprite: SKSpriteNode?
//    
//    init(column: Int, row: Int, tileType: TileType) {
//        self.column = column
//        self.row = row
//        self.tileType = tileType
//    }
//    
//    var description: String {
//        return "type:\(tileType) square:(\(column),\(row))"
//    }
//    
//    var hashValue: Int {
//        return row*10 + column
//    }
//}
//
//func ==(lhs: Tile, rhs: Tile) -> Bool {
//    return lhs.column == rhs.column && lhs.row == rhs.row
//}