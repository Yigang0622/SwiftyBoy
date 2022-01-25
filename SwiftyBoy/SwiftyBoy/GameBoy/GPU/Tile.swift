//
//  Tiles.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/5.
//

import Foundation

struct Tile {
    
    var pixels = Array(repeating: 0, count: 64)
    var raw = [Int]()
    
    static func from(with bytes: [Int], mode: Int) -> Tile {
        var pixels = Array(repeating: 0, count: 64)
        if bytes.count != 16 {
            fatalError("Tiles init failed")
        }
        
        for i in 0 ..< 8 {
            let byte1 = bytes[2 * i]
            let byte2 = bytes[2 * i + 1]
            
            if mode == 0 {
                pixels[i * 8 + 0] = (byte1 >> 7 & 0b1) | (byte1 >> 7 & 0b1) << 1
                pixels[i * 8 + 1] = (byte1 >> 6 & 0b1) | (byte1 >> 6 & 0b1) << 1
                pixels[i * 8 + 2] = (byte1 >> 5 & 0b1) | (byte1 >> 5 & 0b1) << 1
                pixels[i * 8 + 3] = (byte1 >> 4 & 0b1) | (byte1 >> 4 & 0b1) << 1
                pixels[i * 8 + 4] = (byte1 >> 3 & 0b1) | (byte1 >> 3 & 0b1) << 1
                pixels[i * 8 + 5] = (byte1 >> 2 & 0b1) | (byte1 >> 2 & 0b1) << 1
                pixels[i * 8 + 6] = (byte1 >> 1 & 0b1) | (byte1 >> 1 & 0b1) << 1
                pixels[i * 8 + 7] = (byte1 >> 0 & 0b1) | (byte1 >> 0 & 0b1) << 1
            } else {
                pixels[i * 8 + 0] = (byte1 >> 7 & 0b1) | (byte2 >> 7 & 0b1) << 1
                pixels[i * 8 + 1] = (byte1 >> 6 & 0b1) | (byte2 >> 6 & 0b1) << 1
                pixels[i * 8 + 2] = (byte1 >> 5 & 0b1) | (byte2 >> 5 & 0b1) << 1
                pixels[i * 8 + 3] = (byte1 >> 4 & 0b1) | (byte2 >> 4 & 0b1) << 1
                pixels[i * 8 + 4] = (byte1 >> 3 & 0b1) | (byte2 >> 3 & 0b1) << 1
                pixels[i * 8 + 5] = (byte1 >> 2 & 0b1) | (byte2 >> 2 & 0b1) << 1
                pixels[i * 8 + 6] = (byte1 >> 1 & 0b1) | (byte2 >> 1 & 0b1) << 1
                pixels[i * 8 + 7] = (byte1 >> 0 & 0b1) | (byte2 >> 0 & 0b1) << 1
            }
        }
        return Tile(pixels: pixels, raw: bytes)
    }
    
    func getPixel(i: Int, j: Int) -> Int {
        return pixels[i * 8 + j]
    }
    
}
