//
//  GameScene.swift
//  Nimble Ninja
//
//  Created by Joydeep on 26/07/18.
//  Copyright © 2018 Joydeep. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var movingGround : JBMovingGround!
    var hero : JBHero!
    var cloudGenerator : JBCloudGenerator!
    
    var isStarted = false
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.init(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        //Add groud
        movingGround = JBMovingGround(size: CGSize(width: view.frame.size.width, height: KJBGroundHeight))
        movingGround.position = CGPoint(x: 0, y: view.frame.height / CGFloat(2))
        addChild(movingGround)
        
        //Add hero
        
        hero = JBHero()
        hero.position = CGPoint(x: 70.0, y: movingGround.position.y + movingGround.frame.size.height/2 + hero.frame.size.height/2)
        addChild(hero)
        hero.breathe()
        
        //Add cloud generator
        cloudGenerator = JBCloudGenerator(color: UIColor.clear, size: view.frame.size)
        cloudGenerator.position = view.center
        addChild(cloudGenerator)
        cloudGenerator.populate(num: 7)
        cloudGenerator.startGeneratingWithSpawnTime(seconds: 7)
        
    }
    
    func start(){
        isStarted = true
        hero.stop()
        hero.startRunning()
        movingGround.start()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isStarted{
            start()
        } else {
            hero.flip()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Testing Git
    }
}
