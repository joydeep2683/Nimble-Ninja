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
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.init(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        addMovingGround()
        addHero()
        addCloudGenerator()
        addWallGenerator()
        addTapToStartLabel()
        addPhysicsWorld()
        addPointsLabel()
    }
    
    func addMovingGround(){
        //Add groud
        movingGround = JBMovingGround(size: CGSize(width: (view?.frame.size.width)!, height: KJBGroundHeight))
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
        addChild(pointsLabel)
        
        let highScoreLabel = JBPointsLabel(num: 0)
        highScoreLabel.position = CGPoint(x: (view?.frame.width)! - 35, y: (view?.frame.height)! - 30)
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
        // Called before each frame is rendered
        // Testing Git
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
