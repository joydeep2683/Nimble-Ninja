//
//  JBWall.swift
//  Nimble Ninja
//
//  Created by Joydeep on 07/08/18.
//  Copyright © 2018 Joydeep. All rights reserved.
//

import Foundation
import SpriteKit

class JBWall: SKSpriteNode {
    let WALL_WIDTH : CGFloat = 30.0
    let WALL_HEIGHT : CGFloat = 50.0
    let WALL_COLOR = UIColor.brown
    
    init() {
        super.init(texture: nil, color: WALL_COLOR, size: CGSize(width: WALL_WIDTH, height: WALL_HEIGHT))
        
        startMoving()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving(){
        let moveLeft = SKAction.moveBy(x: -300.0, y: 0.0, duration: 1.0)
        run(SKAction.repeatForever(moveLeft))
    }
}
