//
//  Tiles.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/5.
//

import Foundation

class Tile {
    

    var pixels = Array(repeating: Array(repeating: 0, count: 8), count: 8)
    
    init(bytes: [UInt8]) {
        if bytes.count != 16 {
            print("Tiles init failed")
        }
        
        for i in 0 ..< 8 {
            let byte1 = bytes[2 * i]
            let byte2 = bytes[2 * i + 1]
            pixels[i][0] = (Int(byte1) >> 6) & 0b11
            pixels[i][1] = (Int(byte1) >> 4) & 0b11
            pixels[i][2] = (Int(byte1) >> 2) & 0b11
            pixels[i][3] = (Int(byte1) >> 0) & 0b11
            
            pixels[i][4] = (Int(byte2) >> 6) & 0b11
            pixels[i][5] = (Int(byte2) >> 4) & 0b11
            pixels[i][6] = (Int(byte2) >> 2) & 0b11
            pixels[i][7] = (Int(byte2) >> 0) & 0b11
        }
        
    }
    
    
}
                               
