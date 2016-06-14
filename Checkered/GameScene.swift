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
    let provider = TileAppearance()
    
    let TileWidthOuter: CGFloat = 75.0
    let TileHeightOuter: CGFloat = 75.0
    let TileWidthInner: CGFloat = 73.0
    let TileHeightInner: CGFloat = 73.0
    
    var tiles: Dictionary<NSIndexPath, TileView>
    
    let gameLayer = SKNode()
    let boardTilesLayer = SKNode()
    
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
                boardTile.path = CGPathCreateWithRoundedRect(CGRectMake(CGFloat(column)*TileWidthOuter,CGFloat(row)*TileHeightOuter-TileHeightOuter/2,TileWidthInner,TileHeightInner),4,4,nil)
                boardTile.fillColor = SKColor.lightGrayColor()
                boardTilesLayer.addChild(boardTile)
            }
        }
    }
    
    func insertTile(position: (Int, Int), value: Int){
        let (column, row) = position
        let x = CGFloat(column)*(TileWidthInner)
        let y = CGFloat(row)*(TileHeightInner)
        let tile = TileView(position: CGPointMake(x ,y), tileWidthInner: TileWidthInner, value: value, delegate: provider)
        
//                let tile = SKShapeNode()
//        tile.path = CGPathCreateWithRoundedRect(CGRectMake(CGFloat(column)*TileWidthOuter,CGFloat(row)*TileHeightOuter-TileHeightOuter/2,TileWidthInner,TileHeightInner),4,4,nil)
//        tile.fillColor = 
        boardTilesLayer.addChild(tile)
    }
    

}























//        for row in 0..<NumRows {
//            for column in 0..<NumColumns {
//                let boardTileNode = SKSpriteNode(imageNamed: "BoardTile")
//                boardTileNode.size = CGSize(width: TileWidth, height: TileHeight)
//                boardTileNode.position = pointForColumn(column, row: row)
//                boardTilesLayer.addChild(boardTileNode)
//            }
//        }


//    func pointForColumn(column: Int, row: Int) -> CGPoint {
//        return CGPoint(
//            x: CGFloat(column)*TileWidthOuter + TileWidthOuter/2,
//            y: CGFloat(row)*TileHeightOuter + TileHeightOuter/2)
//    }