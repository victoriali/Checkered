//
//  GameScene.swift
//  Checkered
//
//  Created by Wing Man Li on 12/6/2016.
//  Copyright (c) 2016 Victoria Li. All rights reserved.
//

import SpriteKit
import UIKit
import DeviceKit

class GameScene: SKScene {
    
    var level: Level!
    var set = Set<Tile>()
    
    var TileWidthOuter: CGFloat = 70.0
    var TileHeightOuter: CGFloat = 70.0
    var TileWidthInner: CGFloat = 68.0
    var TileHeightInner: CGFloat = 68.0
    
    func tileSize(phoneSize: Device) {
        switch phoneSize {
        case .Simulator(.iPhone6sPlus):
            print("phone is iPhone6sPlus")
            TileWidthOuter = 80.0
            TileHeightOuter = 80.0
            TileWidthInner = 78.0
            TileHeightInner = 78.0
        case .Simulator(.iPhone6Plus):
            print("phone is iPhone6Plus")
            TileWidthOuter = 80.0
            TileHeightOuter = 80.0
            TileWidthInner = 78.0
            TileHeightInner = 78.0
        case .Simulator(.iPhone6s):
            print("phone is iPhone6s")
            TileWidthOuter = 70.0
            TileHeightOuter = 70.0
            TileWidthInner = 68.0
            TileHeightInner = 68.0
        case .Simulator(.iPhone6):
            print("phone is iPhone6")
            TileWidthOuter = 30.0
            TileHeightOuter = 30.0
            TileWidthInner = 28.0
            TileHeightInner = 28.0
        case .Simulator(.iPhone5s):
            print("phone is iPhone5s")
            TileWidthOuter = 60.0
            TileHeightOuter = 60.0
            TileWidthInner = 58.0
            TileHeightInner = 58.0
        case .Simulator(.iPhone5):
            print("phone is iPhone5")
            TileWidthOuter = 60.0
            TileHeightOuter = 60.0
            TileWidthInner = 58.0
            TileHeightInner = 58.0
        case .Simulator(.iPhone4s):
            print("phone is iPhone4s")
            TileWidthOuter = 60.0
            TileHeightOuter = 60.0
            TileWidthInner = 58.0
            TileHeightInner = 58.0
        default:
            break
        }
    }
    
    let gameLayer = SKNode()
    let boardLayer = SKNode()
    let boardTilesLayer = SKNode()
    
    var tileSprites = Array2D<SKShapeNode>(columns: NumColumns, rows: NumRows)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let device = Device()
        tileSize(device)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = size
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidthOuter * CGFloat(NumColumns) / 2,
            y: -TileHeightOuter * CGFloat(NumRows) / 2 - TileHeightOuter)
        
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
    
    typealias CompletionHandler = (success:Bool) -> Void
    
    func tilesMoved(displacements:[TileDisplacement],completionHandler: CompletionHandler) {
        for displacement in displacements {
            var flag = false
            let sprite = tileSprites[displacement.fromCol, displacement.fromRow]
            
            let moveAction = SKAction.moveByX(coordToCGPoint(displacement.toCol, displacement.toRow).x - coordToCGPoint(displacement.fromCol, displacement.fromRow).x, y: coordToCGPoint(displacement.toCol, displacement.toRow).y - coordToCGPoint(displacement.fromCol, displacement.fromRow).y, duration: 0.15)

            sprite!.runAction(SKAction.sequence([
                
                SKAction.runBlock({
                    sprite!.runAction(moveAction, completion:{
                        flag = true
                        completionHandler(success: flag)
                    })
                })
            ]))
        }
    }
    
    func removeAll(){
        boardTilesLayer.removeAllChildren()
    }
    
}
