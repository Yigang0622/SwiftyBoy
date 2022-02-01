//
//  PaletteRegister.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/8.
//

import Foundation

class PaletteRegister: BaseRegister {
    
    private var palette = [0, 0, 0, 0]
    
    override init(val: Int) {
        super.init(val: val)
        setVal(val: val)
    }

    override func setVal(val: Int) {
        super.setVal(val: val)
        palette[0] = (val >> (0 * 2)) & 0b11
        palette[1] = (val >> (1 * 2)) & 0b11
        palette[2] = (val >> (2 * 2)) & 0b11
        palette[3] = (val >> (3 * 2)) & 0b11
    }
    
    func getColor(i: Int) -> Int {
        return self.palette[i]
    }
    
    
}
