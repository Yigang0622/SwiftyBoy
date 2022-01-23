//
//  Tiles.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/5.
//

import Foundation

class Tile {
    

    var pixels = Array(repeating: Array(repeating: 0, count: 8), count: 8)
    
    init(bytes: [Int], mode: Int) {
        if bytes.count != 16 {
            fatalError("Tiles init failed")
        }
        
        for i in 0 ..< 8 {
            let byte1 = bytes[2 * i]
            let byte2 = bytes[2 * i + 1]
            
            if mode == 0 {
                pixels[i][0] = (byte1 >> 7 & 0b1) | (byte1 >> 7 & 0b1) << 1
                pixels[i][1] = (byte1 >> 6 & 0b1) | (byte1 >> 6 & 0b1) << 1
                pixels[i][2] = (byte1 >> 5 & 0b1) | (byte1 >> 5 & 0b1) << 1
                pixels[i][3] = (byte1 >> 4 & 0b1) | (byte1 >> 4 & 0b1) << 1
                pixels[i][4] = (byte1 >> 3 & 0b1) | (byte1 >> 3 & 0b1) << 1
                pixels[i][5] = (byte1 >> 2 & 0b1) | (byte1 >> 2 & 0b1) << 1
                pixels[i][6] = (byte1 >> 1 & 0b1) | (byte1 >> 1 & 0b1) << 1
                pixels[i][7] = (byte1 >> 0 & 0b1) | (byte1 >> 0 & 0b1) << 1
            } else {
                pixels[i][0] = (byte1 >> 7 & 0b1) | (byte2 >> 7 & 0b1) << 1
                pixels[i][1] = (byte1 >> 6 & 0b1) | (byte2 >> 6 & 0b1) << 1
                pixels[i][2] = (byte1 >> 5 & 0b1) | (byte2 >> 5 & 0b1) << 1
                pixels[i][3] = (byte1 >> 4 & 0b1) | (byte2 >> 4 & 0b1) << 1
                pixels[i][4] = (byte1 >> 3 & 0b1) | (byte2 >> 3 & 0b1) << 1
                pixels[i][5] = (byte1 >> 2 & 0b1) | (byte2 >> 2 & 0b1) << 1
                pixels[i][6] = (byte1 >> 1 & 0b1) | (byte2 >> 1 & 0b1) << 1
                pixels[i][7] = (byte1 >> 0 & 0b1) | (byte2 >> 0 & 0b1) << 1
            }
            
        }
        
    }
    
    
}
                               
