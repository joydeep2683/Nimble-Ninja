//
//  GameScene.swift
//  Nimble Ninja
//
//  Created by Joydeep on 26/07/18.
//  Copyright © 2018 Joydeep. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var movingGround : JBMovingGround!
    var hero : JBHero!
    var cloudGenerator : JBCloudGenerator!
    var wallGenerator : JBWallGenerator!
    
    var isStarted = false
    var isGameOver = false
    
    var currentLevel = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.init(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        addMovingGround()
        addHero()
        addCloudGenerator()
        addWallGenerator()
        addTapToStartLabel()
        addPhysicsWorld()
        addPointsLabel()
        loadHighScore()
    }
    
    func addMovingGround(){
        //Add groud
        movingGround = JBMovingGround(size: CGSize(width: (view?.frame.size.width)!, height: kJBGroundHeight))
        movingGround.position = CGPoint(x: 0, y: (view?.frame.height)! / CGFloat(2))
        addChild(movingGround)
    }
    
    func addHero(){
        //Add hero
        hero = JBHero()
        hero.position = CGPoint(x: 70.0, y: movingGround.position.y + movingGround.frame.size.height/2 + hero.frame.size.height/2)
        addChild(hero)
        hero.breathe()
    }
    
    func addCloudGenerator(){
        //Add cloud generator
        cloudGenerator = JBCloudGenerator(color: UIColor.clear, size: (view?.frame.size)!)
        cloudGenerator.position = (view?.center)!
        addChild(cloudGenerator)
        cloudGenerator.populate(num: 7)
        cloudGenerator.startGeneratingWithSpawnTime(seconds: 7)
    }
    
    func addWallGenerator(){
        // Add wall generator
        wallGenerator = JBWallGenerator(color: UIColor.clear, size: (view?.frame.size)!)
        wallGenerator.position = (view?.center)!
        addChild(wallGenerator)
    }
    
    func addTapToStartLabel(){
        // Add Tap to start label
        let tapToStartLabel = SKLabelNode(text: "Tap to Start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = (view?.center.x)!
        tapToStartLabel.position.y = (view?.center.y)! + 40
        tapToStartLabel.fontColor = UIColor.black
        tapToStartLabel.fontName = "Helvetica"
        tapToStartLabel.fontSize = 22.0
        addChild(tapToStartLabel)
        tapToStartLabel.run(blinkAnimation())
    }
    
    func addPointsLabel(){
        let pointsLabel = JBPointsLabel(num: 0)
        pointsLabel.position = CGPoint(x: 20.0, y: (view?.frame.height)! - 30)
        pointsLabel.name = "pointsLabel"
        addChild(pointsLabel)
        
        let highScoreLabel = JBPointsLabel(num: 0)
        highScoreLabel.position = CGPoint(x: (view?.frame.width)! - 35, y: (view?.frame.height)! - 30)
        highScoreLabel.name = "highScoreLabel"
        addChild(highScoreLabel)
        
        let highScoreTextLabel = SKLabelNode(text: "High Score")
        highScoreTextLabel.fontColor = UIColor.black
        highScoreTextLabel.fontSize = 12.0
        highScoreTextLabel.fontName = "Helvetica"
        highScoreTextLabel.position = CGPoint(x: 0.0, y: -30.0)
        highScoreLabel.addChild(highScoreTextLabel)
    }
    
    func addPhysicsWorld(){
        // Add physics world
        physicsWorld.contactDelegate = self
    }
    
    func loadHighScore(){
        let defaults = UserDefaults.standard
        let highScoreLabel = childNode(withName: "highScoreLabel") as! JBPointsLabel
        highScoreLabel.setTo(num: defaults.integer(forKey: "highscore"))
    }
    
    // MARK: Game lifecycle
    
    func start(){
        isStarted = true
        let tapToStartLabel = childNode(withName: "tapToStartLabel")
        tapToStartLabel?.removeFromParent()
        hero.stop()
        hero.startRunning()
        movingGround.start()
        wallGenerator.startGeneratingWallsEvery(seconds:  1.0)
    }
    func gameOver(){
        isGameOver = true
        
        // stops everything
        hero.fall()
        wallGenerator.stopWalls()
        movingGround.stop()
        hero.stop()
        
        // Create gameover label
        let gameOverLabel = SKLabelNode(text: "Game Over.")
        gameOverLabel.fontColor = UIColor.black
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.position.x = (view?.center.x)!
        gameOverLabel.position.y = (view?.center.y)! + 40.0
        gameOverLabel.fontSize = 22.0
        addChild(gameOverLabel)
        gameOverLabel.run(blinkAnimation())
        
        // Save current points label value
        let pointsLabel = childNode(withName: "pointsLabel") as! JBPointsLabel
        let highScoreLabel = childNode(withName: "highScoreLabel") as! JBPointsLabel
        
        if highScoreLabel.number < pointsLabel.number {
            highScoreLabel.setTo(num: pointsLabel.number)
            
            let defaults = UserDefaults.standard
            defaults.set(highScoreLabel.number, forKey: "highscore")
        }
    }
    
    func restart(){
        let newScene = GameScene(size: (view?.bounds.size)!)
        newScene.scaleMode = .aspectFill
        view?.presentScene(newScene)
        cloudGenerator.stopGenerating()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            restart()
        } else if !isStarted{
            start()
        } else {
            hero.flip()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if wallGenerator.wallTracker.count > 0 {
            // Called before each frame is rendered
            let wall = wallGenerator.wallTracker[0] as JBWall
            
            // converting wall location from wall generator to view
            let wallLocation = wallGenerator.convert(wall.position, to: self)
            if wallLocation.x < hero.position.x {
                wallGenerator.wallTracker.remove(at: 0)
                let pointsLabel = childNode(withName: "pointsLabel") as! JBPointsLabel
                pointsLabel.increment()
                
                if pointsLabel.number % kNumberOfPointsPerLevel == 0 {
                    currentLevel += 1
                    wallGenerator.stopGenerating()
                    wallGenerator.startGeneratingWallsEvery(seconds: kLevelGenerationTimes[currentLevel])
                }
            }
        }
    }
    
    // MARK: SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        if !isGameOver{
            gameOver()
        }
    }
    
    // MARK: animation
    func blinkAnimation() -> SKAction {
        let duration = 0.4
        let faadeOut = SKAction.fadeAlpha(to: 0.0, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([faadeOut, fadeIn])
        
        return SKAction.repeatForever(blink)
    }
}
