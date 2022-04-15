//
//  LSFR.swift
//  AudioKitDemo
//
//  Created by Yigang Zhou on 2022/4/15.
//

import UIKit

class LSFR: NSObject {

    internal var state = 0
    private var bitLen = 0
            
    init(length: Int) {
        super.init()
        self.bitLen = length
        for i in 0 ..< length {
            state += 1 << i
        }
        print(state)
    }
    
    func next(step: Int) -> [Int] {
        var codes = Array(repeating: 0, count: step)
        
        for i in 0 ..< step {
            codes[i] = state & 1
            let newBit = (state ^ (state >> 1)) & 1
            state = (state >> 1) | (newBit << (bitLen - 1))
        }
                
        return codes
    }
    
    
}
