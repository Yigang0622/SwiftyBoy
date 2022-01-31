//
//  Sprite.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/1/25.
//

import Foundation

struct Sprite {
    
    var posY: Int = 0
    var posX: Int = 0
    var patternNumber: Int = 0
    var priority: Bool = false
    var yFlip: Bool = false
    var xFlip: Bool = false
    var palette: Int = 0
    
    static func from(byte0: Int, byte1: Int, byte2: Int, byte3: Int) -> Sprite{
        return Sprite(posY: byte0,
                      posX: byte1,
                      patternNumber: byte2,
                      priority: (byte3 >> 7) & 0b1 == 1,
                      yFlip: (byte3 >> 6) & 0b1 == 1,
                      xFlip: (byte3 >> 5) & 0b1 == 1,
                      palette: (byte3 >> 4) & 0b1)
        
    }
    
}
