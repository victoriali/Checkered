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
var set = Set<Tile>()

enum InputDirection {
    case Left
    case Right
    case Up
    case Down
}

class Level {
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    var displacements:[TileDisplacement] = []
    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    func initialTiles() -> Set<Tile>{
        return createInitialTiles()
    }
    
    private func createInitialTiles() -> Set<Tile>{
        let tile1 = createNewTile()
        tiles[tile1.column, tile1.row] = tile1
        set.insert(tile1)
        
        let tile2 = createNewTile()
        tiles[tile2.column, tile2.row] = tile2
        set.insert(tile2)
        
        return set
    }
    
    func insertOneTile() -> Set<Tile>{
        let tile3 = createNewTile()
        tiles[tile3.column, tile3.row] = tile3
        set.insert(tile3)
        
        return set
    }
    
    func createNewTile() -> Tile {
        var row = Int(arc4random_uniform(UInt32(NumRows)))
        var col = Int(arc4random_uniform(UInt32(NumColumns)))
     
        while (tiles[col, row] != nil) {
            row = Int(arc4random_uniform(UInt32(NumRows)))
            col = Int(arc4random_uniform(UInt32(NumColumns)))
        }
        
        let tileType = TileType.random()
        
        let tile = Tile(column: col, row: row, tileType: tileType)
        print("random Tile")
        print(tile)
        
        return tile
    }
   
    func removeTiles(column: Int, row: Int, tileType: TileType) -> Set<Tile>{
//        print("what is level- removeTiles")
//        print("******************************************")
//        print(set)
//        print("******************************************")
//        let subtractedBy: Set<Tile> = [Tile(column: column, row: row, tileType: tileType)]
//        print(subtractedBy)
//        print("******************************************")
//        set = set.subtract(subtractedBy)
//        print(set)
//        print("******************************************")
        for tile in set {
            if tile.hashValue == (row*10 + column + ((tileType == .Black) ? 1000 : 0)) {
                print(tile.hashValue)
                print(row*10 + column + ((tileType == .Black) ? 1000 : 0))
                print("******************************************")
                print(set)
                print("******************************************")
//                print(set.remove(tile))
                print(set.removeAll())
                print("******************************************")
                print(set)
                print("******************************************")
                break
            }
        }
//        let tile = Tile(column: column, row: row, tileType: tileType)
//        print(tile)
//        tiles[tile.column, tile.row] = tile
//        print("set BEFORE removed")
//        print(set)
//        print("*************")
//        print(set.remove())
//        print("*************")
//        print("set AFTER removed")
//        print (set)
        return set
    }
    
    func userMoved(direction:InputDirection) {
        switch direction {
        case .Left:
            moveLeft()
        default:
            break
        }
    }
    
    func moveLeft() {
        
        var displacements:[TileDisplacement] = []
        
        for row in 0..<NumRows {
            var hasMerged = false
            for colMax in 1..<NumColumns {
                for col in colMax.stride(through: 1, by: -1) {

                    if let tile = tiles[col, row] {
                        
                        if tiles[col-1, row] == nil {
                            print ("First session")
                            tiles[col-1, row] = tile
                            tiles[col, row] = nil
                            tile.column = col - 1
                            
//                            displacements.indexOf({ displacement -> Bool in
//                                return displacement.fromCol == colMax && displacement.fromRow == row
//                            })
                            
                            if let index = displacements.indexOf({ $0.fromCol == colMax && $0.fromRow == row }) {
                                displacements[index].toCol = col - 1
                                displacements[index].toRow = row
                                displacements[index].tileType = tile.tileType
                                
                                print("if let")
                                print(displacements)
                                
                            } else {
                                
                                let displacement = TileDisplacement(fromCol: colMax, fromRow: row, toCol: col - 1, toRow: row, tileType: tile.tileType, disappear: false, newTile: true)
                                
                                displacements.append(displacement)
                                
                                print("else")
                                print(displacements)
                            }
                            
                        } else if tiles[col-1, row]?.tileType == tiles[col, row]!.tileType && hasMerged == false{
                            print ("Second session")
                            tiles[col-1, row] = nil
                            tiles[col, row] = nil
                            tiles[col-1, row] = tile
                            
                            if tiles[col-1, row]!.tileType == .Red {
                                tiles[col-1, row]!.tileType = .Black
                            } else if tiles[col-1, row]!.tileType == .Black{
                                tiles[col-1, row]!.tileType = .Red
                            }
                            tile.column = col - 1
                            
                            
                            if let index = displacements.indexOf({ $0.fromCol == colMax && $0.fromRow == row }) {
                                displacements[index].disappear = true
                                displacements[index].toCol = col - 1
                                displacements[index].toRow = row
                                displacements[index].tileType = tile.tileType
                                print("if let merge")
                                print(displacements)
                               
                            } else {
                                let displacement = TileDisplacement(fromCol: colMax, fromRow: row, toCol: col-1, toRow: row, tileType: tile.tileType, disappear: true, newTile: true)
                                displacements.append(displacement)
                                print("else merge")
                                print(displacements)
                            }
                            hasMerged = true
                        }
                        print ("\(col), \(row), \(colMax), \(tile.tileType)")
                        print (tiles)
                    }
                }
            }
        }
        
        
        if displacements.count > 1 {
            var index = 0
            while index <= displacements.count - 2 {
                displacements[index].newTile = false
                index += 1
            }
        }
        
        for var displacement in displacements {
            if displacement.disappear == true {
                if displacement.tileType == .Red {
                    displacement.tileType = .Black
                } else if displacement.tileType == .Black {
                    displacement.tileType = .Red
                }
            }
        }
        
        self.displacements = displacements
        print(displacements)
        print("done")
    }
    
}

struct TileDisplacement {
    var fromCol:Int = 0
    var fromRow:Int = 0
    var toCol:Int = 0
    var toRow:Int = 0
    var tileType:TileType
    
    var disappear:Bool = false
    var newTile:Bool = false
}





