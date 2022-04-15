//
//  LSFR.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/15.
//

import Foundation

/**
 Linear-feedback shift register
 https://en.wikipedia.org/wiki/Linear-feedback_shift_register
 */
class LSFR: NSObject {
    
    internal var state = 0
    private var bitLen = 0
            
    init(length: Int) {
        super.init()
        self.bitLen = length
        // initialize state as all 1's
        for i in 0 ..< length {
            state += 1 << i
        }
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
