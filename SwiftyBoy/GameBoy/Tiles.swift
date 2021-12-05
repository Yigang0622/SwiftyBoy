//
//  Tiles.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/5.
//

import Foundation

class Tiles {
    

    let pixels = Array(repeating: Array(repeating: 0, count: 8), count: 8)
    
    init(bytes: [UInt8]) {
        if bytes.count != 16 {
            print("Tiles init failed")
        }
        
        for (i, each) in bytes.enumerated() {
            
        }
        
    }
    
    func byteToPixel(byte: UInt8) -> [Int] {
        var pixels = Array(repeating: 0, count: 4)
        for i in 0...4 {
            pixels[4 - i] = (Int(byte) >> 2 * (i - 1)) & 0b11
        }
        return pixels;
    }
    
}
