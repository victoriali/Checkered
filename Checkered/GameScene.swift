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
        for tile in tiles {
            let tileSprite = SKShapeNode()
            
            
            tileSprite.path = CGPathCreateWithRoundedRect(CGRect(origin: coordToCGPoint(tile.column, tile.row), size: CGSize(width: TileWidthInner, height: TileHeightInner)),4,4,nil)
            let tileColor = tile.tileType == .Red ? SKColor.redColor() : SKColor.blackColor()
            
            tileSprite.fillColor = tileColor
            boardTilesLayer.addChild(tileSprite)
            tileSprites[tile.column, tile.row] = tileSprite
            
        }
    }
    
    func coordToCGPoint(column:Int, _ row:Int) -> CGPoint {
        return CGPoint(x:CGFloat(column)*TileWidthOuter, y:CGFloat(row)*TileHeightOuter)
    }

    
    func tilesMoved(displacements:[TileDisplacement]) {
        for displacement in displacements {
            let sprite = tileSprites[displacement.fromCol, displacement.fromRow]

            print("original position CG Point")
            print(coordToCGPoint(displacement.fromCol, displacement.fromRow))
            print("displacement CG Point")
            print(coordToCGPoint(displacement.toCol, displacement.toRow))
            print("Move By CG Point")
            print(coordToCGPoint(displacement.toCol-displacement.fromCol, displacement.toRow-displacement.fromRow))
            
            let moveAction = SKAction.moveByX(coordToCGPoint(displacement.toCol, displacement.toRow).x - coordToCGPoint(displacement.fromCol, displacement.fromRow).x, y: coordToCGPoint(displacement.toCol, displacement.toRow).y - coordToCGPoint(displacement.fromCol, displacement.fromRow).y, duration: 0.1)
//            let moveAction = SKAction.moveTo(coordToCGPoint(displacement.toCol, displacement.toRow), duration: 0.5)
            sprite!.runAction(moveAction)
            
            if displacement.newTile == true{
                let oneNewTile = level.insertOneTile()
                addTiles(oneNewTile)
                print("insert one tile is called")
            }
            if displacement.disappear == true{
                let removeTile = level.removeTiles(displacement.toCol, row: displacement.toRow, tileType: displacement.tileType)
                removeTiles(removeTile)
//                let changeColor = level.changeColor((displacement.toCol)-1, row: displacement.toRow, tileType: displacement.tileType)
//                changeTiles(changeColor)
            }
        }
    }
    
    func removeTiles(tiles: Set<Tile>){
        for tile in tiles {
            let tileSprite = SKShapeNode()
            tileSprites[tile.column, tile.row] = tileSprite
            tileSprite.removeFromParent()
        }
    }
    
//    func changeTiles(tiles: Set<Tile>){
//        for tile in tiles {
//            let tileSprite = SKShapeNode()
//            let tileColor = tile.tileType == .Red ? SKColor.blackColor() : SKColor.redColor()
//            tileSprite.fillColor = tileColor
//            boardTilesLayer.addChild(tileSprite)
//            tileSprites[tile.column, tile.row] = tileSprite
//        }
//    }
    
}
