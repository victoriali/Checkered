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
    
    var winLabel: SKLabelNode!
    
    var win: Bool = false {
        didSet {
            winLabel.text = "\(win)"
        }
    }
    
    let TileWidthOuter: CGFloat = 70.0
    let TileHeightOuter: CGFloat = 70.0
    let TileWidthInner: CGFloat = 68.0
    let TileHeightInner: CGFloat = 68.0
    
    let gameLayer = SKNode()
    let boardLayer = SKNode()
    let boardTilesLayer = SKNode()
    
    var hasWon = false
    
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
        
        boardLayer.position = layerPosition
        boardTilesLayer.position = layerPosition
        gameLayer.addChild(boardLayer)
        gameLayer.addChild(boardTilesLayer)
    }
    
    func setupBoard(){
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                let boardTile = SKShapeNode()
                boardTile.path = CGPathCreateWithRoundedRect(CGRect(origin: coordToCGPoint(column, row), size: CGSize(width: TileWidthInner, height: TileHeightInner)),4,4,nil)
                boardTile.fillColor = SKColor.lightGrayColor()
                boardLayer.addChild(boardTile)
            }
        }
    }
    
    func addTiles(tiles: Set<Tile>){
        boardTilesLayer.removeAllChildren()
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
            
            let moveAction = SKAction.moveByX(coordToCGPoint(displacement.toCol, displacement.toRow).x - coordToCGPoint(displacement.fromCol, displacement.fromRow).x, y: coordToCGPoint(displacement.toCol, displacement.toRow).y - coordToCGPoint(displacement.fromCol, displacement.fromRow).y, duration: 0.15)
//            let moveAction = SKAction.moveTo(coordToCGPoint(displacement.toCol, displacement.toRow), duration: 0.5)
            
            sprite!.runAction(SKAction.sequence([
                
                SKAction.runBlock({
                    sprite!.runAction(moveAction, completion:{
                        if displacement.newTile == true{
                            let tilesFromModel = self.level.insertOneTile()
                            print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
                            print(tilesFromModel)
                            print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
                            self.addTiles(tilesFromModel)
                            if self.level.calculateWin() == false {
                                self.winLabel = SKLabelNode(fontNamed: "Gill Sans")
                                self.winLabel.text = "Congratulations! You Won!"
                                self.winLabel.fontColor = SKColor.blackColor()
                                self.winLabel.fontSize = 22
                                self.winLabel.position = CGPoint(x: 150, y: 320)
                                self.winLabel.zPosition = 3
                                self.winLabel.color = SKColor.yellowColor()
                                self.boardTilesLayer.addChild(self.winLabel)
                            }
                        }
                    })
                })
                
            ]))
        }
    }
    
    func removeAll(){
        boardTilesLayer.removeAllChildren()
    }
    
}
