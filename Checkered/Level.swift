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
var NumColumnsMinusOne = NumColumns - 1
var NumRows = 4
var NumRowsMinusOne = NumRows - 1
var currentMinStep = 999999

var set = Set<Tile>()

enum InputDirection {
    case Left
    case Right
    case Up
    case Down
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

class Level {

    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    var displacements:[TileDisplacement] = []
    
    func removeAllTiles(){
        set.removeAll()
        for col in 0..<NumColumns {
            for row in 0..<NumRows {
                tiles[col, row] = nil
            }
        }
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
        
        var setFromModel = Set<Tile>()
        for col in 0..<NumColumns {
            for row in 0..<NumRows {
                if let individualTile = tiles[col, row]{
                    setFromModel.insert(individualTile)
                }
            }
        }
        print("SET FROM MODEL")
        print(setFromModel)
        return setFromModel
    }
    
    func createNewTile() -> Tile {
        var row = Int(arc4random_uniform(UInt32(NumRows)))
        var col = Int(arc4random_uniform(UInt32(NumColumns)))
     
        while (tiles[col, row] != nil) {
            row = Int(arc4random_uniform(UInt32(NumRows)))
            col = Int(arc4random_uniform(UInt32(NumColumns)))
        }
        
        let tileType = TileType.random()
        
        let tile = Tile(column: col, row: row, tileType: tileType, hasMerged: false)
        print("random Tile")
        print(tile)
        
        return tile
    }
    
    func calculateWin() -> Bool{
        var totalCheck = 0
        for row in 0..<NumRows {
            for col in 0..<NumColumns {
                let tileTypeInNum = (row + col)%2
                if tileTypeInNum == 0 && tiles[col,row]?.tileType == tiles[0,0]?.tileType && tiles[col,row] != nil{
                    totalCheck += 1
                    print("totalCheck: \(totalCheck)")
                }else if tileTypeInNum == 1 && tiles[col,row]?.tileType != tiles[0,0]?.tileType && tiles[col,row] != nil{
                    totalCheck += 1
                    print("totalCheck: \(totalCheck)")
                }
            }
        }
        print("Expected: \(NumRows * NumColumns)")
        print("finalTotalCheck: \(totalCheck)")
        
        if totalCheck == NumRows * NumColumns {
            print ("DONEDONE!")
            return true
        } else {
            return false
        }
    }
    
    func userMoved(direction:InputDirection) {
        switch direction {
        case .Left:
            moveLeft()
        case .Right:
            moveRight()
        case .Down:
            moveDown()
        case .Up:
            moveUp()
        default:
            break
        }
    }
    
    func moveLeft() {
        
        var displacements:[TileDisplacement] = []
        
        for row in 0..<NumRows {
            for colMax in 1..<NumColumns {
                for col in colMax.stride(through: 1, by: -1) {

                    if let tile = tiles[col, row] {
                        
                        if tiles[col-1, row] == nil {

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
                                
                            } else {
                                
                                let displacement = TileDisplacement(fromCol: colMax, fromRow: row, toCol: col - 1, toRow: row, tileType: tile.tileType, disappear: false, newTile: true)
                                
                                displacements.append(displacement)

                            }
                            
                        } else if tiles[col-1, row]?.tileType == tiles[col, row]!.tileType && tiles[col-1, row]?.hasMerged == false && tiles[col, row]?.hasMerged == false{
                            
                            tiles[col-1, row] = nil
                            tiles[col, row] = nil
                            tiles[col-1, row] = tile
                            
                            if tiles[col-1, row]!.tileType == .Red {
                                tiles[col-1, row]!.tileType = .Black
                            } else if tiles[col-1, row]!.tileType == .Black{
                                tiles[col-1, row]!.tileType = .Red
                            }
                            
                            tiles[col-1, row]!.hasMerged = true
                            tile.column = col - 1
                            
                            
                            if let index = displacements.indexOf({ $0.fromCol == colMax && $0.fromRow == row }) {
                                displacements[index].disappear = true
                                displacements[index].toCol = col - 1
                                displacements[index].toRow = row
                                displacements[index].tileType = tile.tileType
                               
                            } else {
                                let displacement = TileDisplacement(fromCol: colMax, fromRow: row, toCol: col-1, toRow: row, tileType: tile.tileType, disappear: true, newTile: true)
                                displacements.append(displacement)
                            }
                        }
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
        
        for col in 0..<NumColumns {
            for row in 0..<NumRows {
                if let tile = tiles[col, row]{
                    tile.hasMerged = false
                }
            }
        }
    }
    
    func moveRight() {
        
        var displacements:[TileDisplacement] = []
        
        for row in 0..<NumRows {
            for colMax in 1..<NumColumns {
                for col in (NumColumns - colMax - 1)..<(NumColumns - 1){
                    
                    if let tile = tiles[col, row] {
                        
                        if tiles[col+1, row] == nil {

                            tiles[col+1, row] = tile
                            tiles[col, row] = nil
                            tile.column = col + 1
                            
                        
                        if let index = displacements.indexOf({ $0.fromCol == (NumColumnsMinusOne-colMax) && $0.fromRow == row }) {
                            displacements[index].toCol = col + 1
                            displacements[index].toRow = row
                            displacements[index].tileType = tile.tileType
                            
                        } else {
                            
                            let displacement = TileDisplacement(fromCol: (NumColumnsMinusOne-colMax), fromRow: row, toCol: col + 1, toRow: row, tileType: tile.tileType, disappear: false, newTile: true)
                            
                            displacements.append(displacement)
                        }
                            
                        } else if tiles[col+1, row]?.tileType == tiles[col, row]!.tileType && tiles[col+1, row]?.hasMerged == false && tiles[col, row]?.hasMerged == false{
                            
                            tiles[col+1, row] = nil
                            tiles[col, row] = nil
                            tiles[col+1, row] = tile
                            
                            if tiles[col+1, row]!.tileType == .Red {
                                tiles[col+1, row]!.tileType = .Black
                            } else if tiles[col+1, row]!.tileType == .Black{
                                tiles[col+1, row]!.tileType = .Red
                            }
                            
                            tiles[col+1, row]!.hasMerged = true
                            tile.column = col + 1
                            
                            
                            if let index = displacements.indexOf({ $0.fromCol == (NumColumnsMinusOne-colMax) && $0.fromRow == row }) {
                                displacements[index].disappear = true
                                displacements[index].toCol = col + 1
                                displacements[index].toRow = row
                                displacements[index].tileType = tile.tileType
                                
                            } else {
                                let displacement = TileDisplacement(fromCol: (NumColumnsMinusOne-colMax), fromRow: row, toCol: col+1, toRow: row, tileType: tile.tileType, disappear: true, newTile: true)
                                displacements.append(displacement)
                            }
                        }
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
        
        for col in 0..<NumColumns {
            for row in 0..<NumRows {
                if let tile = tiles[col, row]{
                    tile.hasMerged = false
                }
            }
        }
    }
    
    func moveDown() {
        
        var displacements:[TileDisplacement] = []
        
        for col in 0..<NumColumns {
            for rowMax in 1..<NumRows {
                for row in rowMax.stride(through: 1, by: -1){
                    
                    if let tile = tiles[col, row] {
                        
                        if tiles[col, row-1] == nil {
                            tiles[col, row-1] = tile
                            tiles[col, row] = nil
                            tile.row = row - 1
                            
                            
                            if let index = displacements.indexOf({ $0.fromCol == col && $0.fromRow == rowMax }) {
                                displacements[index].toCol = col
                                displacements[index].toRow = row - 1
                                displacements[index].tileType = tile.tileType
                                
                            } else {
                                
                                let displacement = TileDisplacement(fromCol: col, fromRow: rowMax, toCol: col, toRow: row - 1, tileType: tile.tileType, disappear: false, newTile: true)
                                
                                displacements.append(displacement)
                                
                            }
                            
                        } else if tiles[col, row-1]?.tileType == tiles[col, row]!.tileType && tiles[col, row-1]?.hasMerged == false && tiles[col, row]?.hasMerged == false{

                            tiles[col, row-1] = nil
                            tiles[col, row] = nil
                            tiles[col, row-1] = tile
                            
                            if tiles[col, row-1]!.tileType == .Red {
                                tiles[col, row-1]!.tileType = .Black
                            } else if tiles[col, row-1]!.tileType == .Black{
                                tiles[col, row-1]!.tileType = .Red
                            }
                            
                            tiles[col, row-1]!.hasMerged = true
                            tile.row = row - 1
                            
                            
                            if let index = displacements.indexOf({ $0.fromCol == col && $0.fromRow == rowMax }) {
                                displacements[index].disappear = true
                                displacements[index].toCol = col
                                displacements[index].toRow = row - 1
                                displacements[index].tileType = tile.tileType
                                
                            } else {
                                let displacement = TileDisplacement(fromCol: col, fromRow: rowMax, toCol: col, toRow: row-1, tileType: tile.tileType, disappear: true, newTile: true)
                                displacements.append(displacement)
                            }
                        }
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
        
        for col in 0..<NumColumns {
            for row in 0..<NumRows {
                if let tile = tiles[col, row]{
                    tile.hasMerged = false
                }
            }
        }
    }
    
    func moveUp() {
        
        var displacements:[TileDisplacement] = []
        
        for col in 0..<NumColumns {
            for rowMax in 1..<NumRows {
                for row in (NumRows - rowMax - 1)..<(NumRows - 1){
                    
                    if let tile = tiles[col, row] {
                        
                        if tiles[col, row+1] == nil {
                            tiles[col, row+1] = tile
                            tiles[col, row] = nil
                            tile.row = row + 1
                            
                            
                            if let index = displacements.indexOf({ $0.fromCol == col && $0.fromRow == NumRowsMinusOne - rowMax }) {
                                displacements[index].toCol = col
                                displacements[index].toRow = row + 1
                                displacements[index].tileType = tile.tileType
                                
                            } else {
                                
                                let displacement = TileDisplacement(fromCol: col, fromRow: NumRowsMinusOne - rowMax, toCol: col, toRow: row + 1, tileType: tile.tileType, disappear: false, newTile: true)
                                
                                displacements.append(displacement)

                            }
                            
                        } else if tiles[col, row+1]?.tileType == tiles[col, row]!.tileType && tiles[col, row+1]?.hasMerged == false && tiles[col, row]?.hasMerged == false{

                            tiles[col, row+1] = nil
                            tiles[col, row] = nil
                            tiles[col, row+1] = tile
                            
                            if tiles[col, row+1]!.tileType == .Red {
                                tiles[col, row+1]!.tileType = .Black
                            } else if tiles[col, row+1]!.tileType == .Black{
                                tiles[col, row+1]!.tileType = .Red
                            }
                            
                            tiles[col, row+1]!.hasMerged = true
                            tile.row = row + 1
                            
                            
                            if let index = displacements.indexOf({ $0.fromCol == col && $0.fromRow == NumRowsMinusOne - rowMax }) {
                                displacements[index].disappear = true
                                displacements[index].toCol = col
                                displacements[index].toRow = row + 1
                                displacements[index].tileType = tile.tileType
                                
                            } else {
                                let displacement = TileDisplacement(fromCol: col, fromRow: NumRowsMinusOne - rowMax, toCol: col, toRow: row+1, tileType: tile.tileType, disappear: true, newTile: true)
                                displacements.append(displacement)
                            }
                        }
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
        
        for col in 0..<NumColumns {
            for row in 0..<NumRows {
                if let tile = tiles[col, row]{
                    tile.hasMerged = false
                }
            }
        }
    }
}





