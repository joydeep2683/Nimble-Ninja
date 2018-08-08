//
//  JBPointsLabel.swift
//  Nimble Ninja
//
//  Created by Joydeep on 08/08/18.
//  Copyright © 2018 Joydeep. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class JBPointsLabel: SKLabelNode {
    var number = 0
    
    init(num : Int) {
        super.init()
        
        fontColor = UIColor.black
        fontName = "Helvetica"
        fontSize = 20.0
        number = num
        text = "\(num)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func increment(){
        number += 1
        text = "\(number)"
    }
    func setTo(num: Int){
        self.number = num
        text = "\(self.number)"
    }
}
