//
//  GameViewController.swift
//  Checkered
//
//  Created by Wing Man Li on 12/6/2016.
//  Copyright (c) 2016 Victoria Li. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController{
    var scene: GameScene!
    var level: Level!
    var step = 0
    var minStep = 999999
    var successMoveCounter = 0
    
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var youWon: YouWon!
    @IBOutlet weak var minStepLabel: UILabel!
    
    @IBAction func restart(sender: AnyObject) {
        scene.removeAll()
        level.removeAllTiles()
        self.viewDidLoad()
    }
    func updateLabel(){
        stepLabel.text = String(format: "%ld", step)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youWon.hidden = true
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        scene.setupBoard()
        level = Level()
        scene.level = level
        
        // Present the scene.
        skView.presentScene(scene)
        beginGame()
        
        addRecognizers()
        
        let minStepDefault = NSUserDefaults.standardUserDefaults()
        
        if minStepDefault.valueForKey("minStep") != nil {
            minStep = minStepDefault.valueForKey("minStep") as! Int
            minStepLabel.text = String(format: "%ld", minStep)
        }
        
    }
    
    func addRecognizers() {
        
        let skView = view as! SKView
        
        var recognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.handleSwipe(_:)))
        
        recognizer.direction = .Right
        
        skView.addGestureRecognizer(recognizer)
        
        recognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.handleSwipe(_:)))
        
        recognizer.direction = .Left
        
        skView.addGestureRecognizer(recognizer)
        
        recognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.handleSwipe(_:)))
        
        recognizer.direction = .Down
        
        skView.addGestureRecognizer(recognizer)
        
        recognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.handleSwipe(_:)))
        
        recognizer.direction = .Up
        
        skView.addGestureRecognizer(recognizer)
    }
    
    func handleSwipe(recognizer:UISwipeGestureRecognizer) {
        print("swipe!")
        print(recognizer.direction)
        
        switch recognizer.direction {
        case UISwipeGestureRecognizerDirection.Left:
            level.userMoved(.Left)
            scene.tilesMoved(level.displacements,completionHandler: {(success) -> Void in
                if success {
                    print("success")
                    self.successMoveCounter += 1
                } else {
                    print ("fail")
                }
                
                if self.successMoveCounter == self.level.displacements.count {
                    print("successMoveCounter : \(self.successMoveCounter)")
                    print("displacementCount : \(self.level.displacements.count)")
                    if self.level.displacements.count != 0{
                        self.step += 1
                        let lastDisplacement = self.level.displacements.last
                        if lastDisplacement?.newTile == true{
                            let tilesFromModel = self.level.insertOneTile()
                            self.scene.addTiles(tilesFromModel)
                            if self.level.calculateWin() == true {
                                self.youWon.hidden = false
                                if self.step < self.minStep {
                                    print("Hello")
                                    self.minStep = self.step
                                    self.minStepLabel.text = String(format: "%ld", self.minStep)
                                    
                                    let minStepDefault = NSUserDefaults.standardUserDefaults()
                                    minStepDefault.setValue(self.minStep, forKey: "minStep")
                                    minStepDefault.synchronize()
                                }
                            }
                            print("Here")
                        }
                        
                    }
                    self.updateLabel()
                    self.successMoveCounter = 0
                }
            })
            
        case UISwipeGestureRecognizerDirection.Right:
            level.userMoved(.Right)
            scene.tilesMoved(level.displacements,completionHandler: {(success) -> Void in
                if success {
                    print("success")
                    self.successMoveCounter += 1
                } else {
                    print ("fail")
                }
                
                if self.successMoveCounter == self.level.displacements.count {
                    print("successMoveCounter : \(self.successMoveCounter)")
                    print("displacementCount : \(self.level.displacements.count)")
                    if self.level.displacements.count != 0{
                        self.step += 1
                        let lastDisplacement = self.level.displacements.last
                        if lastDisplacement?.newTile == true{
                            let tilesFromModel = self.level.insertOneTile()
                            self.scene.addTiles(tilesFromModel)
                            if self.level.calculateWin() == true {
                                self.youWon.hidden = false
                                if self.step < self.minStep {
                                    print("Hello")
                                    self.minStep = self.step
                                    self.minStepLabel.text = String(format: "%ld", self.minStep)
                                    
                                    let minStepDefault = NSUserDefaults.standardUserDefaults()
                                    minStepDefault.setValue(self.minStep, forKey: "minStep")
                                    minStepDefault.synchronize()
                                }
                            }
                            print("Here")
                        }
                        
                    }
                    self.updateLabel()
                    self.successMoveCounter = 0
                }
            })

            
        case UISwipeGestureRecognizerDirection.Up:
            level.userMoved(.Up)
            scene.tilesMoved(level.displacements,completionHandler: {(success) -> Void in
                if success {
                    print("success")
                    self.successMoveCounter += 1
                } else {
                    print ("fail")
                }
                
                if self.successMoveCounter == self.level.displacements.count {
                    print("successMoveCounter : \(self.successMoveCounter)")
                    print("displacementCount : \(self.level.displacements.count)")
                    if self.level.displacements.count != 0{
                        self.step += 1
                        let lastDisplacement = self.level.displacements.last
                        if lastDisplacement?.newTile == true{
                            let tilesFromModel = self.level.insertOneTile()
                            self.scene.addTiles(tilesFromModel)
                            if self.level.calculateWin() == true {
                                self.youWon.hidden = false
                                if self.step < self.minStep {
                                    print("Hello")
                                    self.minStep = self.step
                                    self.minStepLabel.text = String(format: "%ld", self.minStep)
                                    
                                    let minStepDefault = NSUserDefaults.standardUserDefaults()
                                    minStepDefault.setValue(self.minStep, forKey: "minStep")
                                    minStepDefault.synchronize()
                                }
                            }
                            print("Here")
                        }
                        
                    }
                    self.updateLabel()
                    self.successMoveCounter = 0
                }
            })
            
        case UISwipeGestureRecognizerDirection.Down:
            level.userMoved(.Down)
            scene.tilesMoved(level.displacements,completionHandler: {(success) -> Void in
                if success {
                    print("success")
                    self.successMoveCounter += 1
                } else {
                    print ("fail")
                }
                
                if self.successMoveCounter == self.level.displacements.count {
                    print("successMoveCounter : \(self.successMoveCounter)")
                    print("displacementCount : \(self.level.displacements.count)")
                    if self.level.displacements.count != 0{
                        self.step += 1
                        let lastDisplacement = self.level.displacements.last
                        if lastDisplacement?.newTile == true{
                            let tilesFromModel = self.level.insertOneTile()
                            self.scene.addTiles(tilesFromModel)
                            if self.level.calculateWin() == true {
                                self.youWon.hidden = false
                                if self.step < self.minStep {
                                    print("Hello")
                                    self.minStep = self.step
                                    self.minStepLabel.text = String(format: "%ld", self.minStep)
                                    
                                    let minStepDefault = NSUserDefaults.standardUserDefaults()
                                    minStepDefault.setValue(self.minStep, forKey: "minStep")
                                    minStepDefault.synchronize()
                                }
                            }
                            print("Here")
                        }
                        
                    }
                    self.updateLabel()
                    self.successMoveCounter = 0
                }
            })

            
        default:
            break
        }

    }
    
    func beginGame(){
        step = 0
        updateLabel()
        initialTiles()
    }
    func initialTiles(){
        let newTiles = level.initialTiles()
        scene.addTiles(newTiles)
    }
    
}