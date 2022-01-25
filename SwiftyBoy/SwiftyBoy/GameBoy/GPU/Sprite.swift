//
//  Sprite.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/1/25.
//

import Foundation

struct Sprite {
    
    var posY: Int
    var posX: Int
    var patternNumber: Int
    var priority: Bool
    var yFlip: Bool
    var xFlip: Bool
    var palette: Int
    
    static func from(byte0: Int, byte1: Int, byte2: Int, byte3: Int) -> Sprite{
        return Sprite(posY: byte0,
                      posX: byte1,
                      patternNumber: byte2,
                      priority: (byte3 >> 7) & 0b1 == 1,
                      yFlip: (byte3 >> 6) & 0b1 == 1,
                      xFlip: (byte3 >> 5) & 0b1 == 1,
                      palette: (byte3 >> 4) & 0b1)
        
    }
    
    func visibleOnScreen() -> Bool {
        return posY >= 16 && posX >= 8
    }
    
}
