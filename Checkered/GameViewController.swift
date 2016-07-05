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
    
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var minStepLabel: UILabel!
    
    @IBAction func restart(sender: AnyObject) {
        scene.removeAll()
        level.removeAllTiles()
        self.viewDidLoad()
    }
    func updateLabel(){
        stepLabel.text = String(format: "%ld", step)
    }
    
    func updateMinStepLabel(){
        minStepLabel.text = String(format: "%ld",step)
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
            scene.tilesMoved(level.displacements)
            if level.displacements.count != 0{
                self.step += 1
            }
            self.updateLabel()

            
        case UISwipeGestureRecognizerDirection.Right:
            level.userMoved(.Right)
            scene.tilesMoved(level.displacements)
            if level.displacements.count != 0{
                self.step += 1
            }
            self.updateLabel()
  
            
        case UISwipeGestureRecognizerDirection.Up:
            level.userMoved(.Up)
            scene.tilesMoved(level.displacements)
            if level.displacements.count != 0{
                self.step += 1
            }
            self.updateLabel()
            
        case UISwipeGestureRecognizerDirection.Down:
            level.userMoved(.Down)
            scene.tilesMoved(level.displacements)
            if level.displacements.count != 0{
                self.step += 1
            }
            self.updateLabel()
            
            
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