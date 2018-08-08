//
//  Constants.swift
//  Nimble Ninja
//
//  Created by Joydeep on 07/08/18.
//  Copyright © 2018 Joydeep. All rights reserved.
//

import Foundation
import UIKit

// Configuration
let kJBGroundHeight: CGFloat = 20.0
let kDefaultxToMovePerSecond : CGFloat = 320.0

// Colission Detection

let heroCategory : UInt32 = 0x1 << 0
let wallCategory : UInt32 = 0x1 << 1

let kNumberOfPointsPerLevel = 5

let kLevelGenerationTimes : [TimeInterval] = [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2]
