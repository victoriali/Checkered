//
//  GameScene.swift
//  Checkered
//
//  Created by Wing Man Li on 12/6/2016.
//  Copyright (c) 2016 Victoria Li. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    

    
    var level: Level!
    var set = Set<Tile>()
    
    let TileWidthOuter: CGFloat = 75.0
    let TileHeightOuter: CGFloat = 75.0
    let TileWidthInner: CGFloat = 73.0
    let TileHeightInner: CGFloat = 73.0
    
    let gameLayer = SKNode()
    let boardTilesLayer = SKNode()
    
    var tileSprites = Array2D<SKShapeNode>(columns: NumColumns, rows: NumRows)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = size
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidthOuter * CGFloat(NumColumns) / 2,
            y: -TileHeightOuter * CGFloat(NumRows) / 2)
        
        boardTilesLayer.position = layerPosition
        gameLayer.addChild(boardTilesLayer)
    }
    
    func setupBoard(){
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                let boardTile = SKShapeNode()
                boardTile.path = CGPathCreateWithRoundedRect(CGRect(origin: coordToCGPoint(column, row), size: CGSize(width: TileWidthInner, height: TileHeightInner)),4,4,nil)
                boardTile.fillColor = SKColor.lightGrayColor()
                boardTilesLayer.addChild(boardTile)
            }
        }
    }
    
    func addTiles(tiles: Set<Tile>){
        boardTilesLayer.removeAllChildren()
        setupBoard()
        for tile in tiles {
//            print("************************************************")
//            print(tile)
            let tileSprite = SKShapeNode()
            
            tileSprite.path = CGPathCreateWithRoundedRect(CGRect(origin: coordToCGPoint(tile.column, tile.row), size: CGSize(width: TileWidthInner, height: TileHeightInner)),4,4,nil)
            let tileColor = tile.tileType == .Red ? SKColor.redColor() : SKColor.blackColor()
            
            tileSprite.fillColor = tileColor
            boardTilesLayer.addChild(tileSprite)
            tileSprites[tile.column, tile.row] = tileSprite
        }
//        print("tile set addTiles")
//        print(tiles)
//        
    }
    
    func coordToCGPoint(column:Int, _ row:Int) -> CGPoint {
        return CGPoint(x:CGFloat(column)*TileWidthOuter, y:CGFloat(row)*TileHeightOuter)
    }

    
    func tilesMoved(displacements:[TileDisplacement]) {
        for displacement in displacements {
            let sprite = tileSprites[displacement.fromCol, displacement.fromRow]
//            var removeSprite = tileSprites[displacement.toCol, displacement.toRow]
//            print (removeSprite)
//
//            print("original position CG Point")
//            print(coordToCGPoint(displacement.fromCol, displacement.fromRow))
//            print("displacement CG Point")
//            print(coordToCGPoint(displacement.toCol, displacement.toRow))
//            print("Move By CG Point")
//            print(coordToCGPoint(displacement.toCol-displacement.fromCol, displacement.toRow-displacement.fromRow))
//            
//            if displacement.disappear == true && removeSprite != nil{
//                let actionRemove = SKAction.removeFromParent()
//                    print("tile set removeTiles")
//                    print(set)
//                    print("BEFORE - what will be removed")
//                    print("to col: \(displacement.toCol), to row: \(displacement.toRow), tileType: \(displacement.tileType)")
//                    if displacement.tileType == .Red {
//                        level.removeTiles(displacement.toCol, row: displacement.toRow, tileType: .Black)
//                        print("black")
//                    }else if displacement.tileType == .Black{
//                        level.removeTiles(displacement.toCol, row: displacement.toRow, tileType: .Red)
//                        print("red")
//                    }
//                    print("AFTER - what will be removed")
//                    print("to col: \(displacement.toCol), to row: \(displacement.toRow), tileType: \(displacement.tileType)")
//                    removeSprite!.runAction(actionRemove)
//                    print ("******************** BEFORE ********************")
//                    print (removeSprite)
//                    removeSprite = nil
//                    print ("********************  AFTER ********************")
//                    print (removeSprite)
//                //                let removeTile = level.removeTiles(displacement.toCol, row: displacement.toRow, tileType: displacement.tileType)
//                //                removeTiles(removeTile)
//            }
//
            let moveActionX = SKAction.moveByX(coordToCGPoint(displacement.toCol, displacement.toRow).x - coordToCGPoint(displacement.fromCol, displacement.fromRow).x, y: coordToCGPoint(displacement.toCol, displacement.toRow).y - coordToCGPoint(displacement.fromCol, displacement.fromRow).y, duration: 5)
            let moveActionY = SKAction.moveByY(coordToCGPoint(displacement.toCol, displacement.toRow).x - coordToCGPoint(displacement.fromCol, displacement.fromRow).x, y: coordToCGPoint(displacement.toCol, displacement.toRow).y - coordToCGPoint(displacement.fromCol, displacement.fromRow).y, duration: 5)
//            let moveAction = SKAction.moveTo(coordToCGPoint(displacement.toCol, displacement.toRow), duration: 0.5)
            
            if displacement.fromRow == displacement.toRow {
                sprite!.runAction(moveActionX)
            } else if displacement.fromCol == displacement.toCol {
                sprite!.runAction(moveActionY)
            }
            

            if displacement.newTile == true{
//                let allTilesBeforeRemove = level.insertOneTile()
//                addTiles(allTilesBeforeRemove)
//                print("insert one tile is called")
                let tilesFromModel = level.insertOneTile()
                print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
                print(tilesFromModel)
                print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
                addTiles(tilesFromModel)
            }
        }
    }
    
//    func removeTiles(tiles: Set<Tile>){
//        for tile in tiles {
//            let tileSprite = SKShapeNode()
//            tileSprites[tile.column, tile.row] = tileSprite
//            tileSprite.removeFromParent()
//        }
//        print("tile set removeTiles")
//        print(tiles)
//    }
    
}
