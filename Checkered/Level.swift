//
//  Level.swift
//  Checkered
//
//  Created by Wing Man Li on 12/6/2016.
//  Copyright © 2016 Victoria Li. All rights reserved.
//

import Foundation
import UIKit

let NumColumns = 4
let NumRows = 4

class Level {
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
//    
//    func InsertTwoRandomTiles() -> Set<Tile> {
//        return createInitialTiles()
//    }
//    
//    private func createInitialTiles() -> Set<Tile> {
//        var set = Set<Tile>()
//        var tileType = TileType.random()
//        
//        for
//        
//        repeat {
//            var column = Int(arc4random_uniform((NumColumns)) + 1
//            var row = Int(arc4random_uniform((NumRows)) + 1
//        } while tiles[column, row] == TileType(1) || tiles[column, row] == TileType(2)
//        
//        let tile = Tile(column: column, row: row, tileType: tileType)
//        tiles[column, row] = tile
//        
//        set.insert(tile)
//        
//    }
    
}