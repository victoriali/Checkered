//
//  Level.swift
//  Checkered
//
//  Created by Wing Man Li on 12/6/2016.
//  Copyright © 2016 Victoria Li. All rights reserved.
//

import Foundation
import UIKit

var NumColumns = 4
var NumRows = 4

protocol LevelProtocol: class {
    func insertTile(location: (Int, Int), value: Int)
}

class Level {
    
    var gameboard: Array2D<TileObject>
    unowned let delegate : LevelProtocol
    
    init(NumColumns NOC: Int, NumRows NOR: Int, delegate: LevelProtocol){
        NumColumns = NOC
        NumRows = NOR
        self.delegate = delegate
        gameboard = Array2D(NumColumns: NOC, NumRows: NOR, initialValue: .Empty)
    }
    
//------------------------------------------------------------------------------//
    // List of empty spots
    func emptySpots() -> [(Int, Int)]{
        var emptyList: [(Int, Int)] = []
        for i in 0..<NumColumns{
            for j in 0..<NumRows{
                if case .Empty = gameboard[i,j]{
                    emptyList += [(i,j)]
                }
            }
        }
        print ("emptyList: \(emptyList)" )
        return emptyList
    }
    
    // Given empty- insert a tile
    func insertTileRandomly(value: Int){
        let openSpots = emptySpots()
        if openSpots.isEmpty {
            return
        }
        let index = Int(arc4random_uniform(UInt32(openSpots.count-1)))
        let (i,j) = openSpots[index]
        print ("i, j: \(i,j)" )
        insertTile((i,j), value: value)
    }
    
    func insertTile(position: (Int, Int), value: Int){
        let (x, y) = position
        if case .Empty = gameboard[x, y]{
            gameboard[x, y] = TileObject.Tile(value)
            delegate.insertTile(position, value: value)
        }
    }
}







