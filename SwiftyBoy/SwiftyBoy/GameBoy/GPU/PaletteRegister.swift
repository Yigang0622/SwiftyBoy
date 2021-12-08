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
        for i in 0...3 {
            palette[i] = (val >> (i * 2)) & 0b11
        }
    }
    
    func getColor(i: Int) -> Int {
        return self.palette[i]
    }
    
    
}
