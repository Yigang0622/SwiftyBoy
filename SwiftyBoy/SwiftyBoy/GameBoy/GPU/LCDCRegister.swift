//
//  LCDCRegister.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/8.
//

import Foundation
import AppKit

enum LCDCTileMapSelect {
    case tile0
    case tile1
}

enum LCDCTileDataSelect {
    case data0
    case data1
}

enum LCDCSpriteSize {
    case size0
    case size1
}

class LCDCRegister: BaseRegister {
    
    var lcdEnable = false
    var windowTileMapSelect: LCDCTileMapSelect = .tile0
    var windowEnable = false
    var tileDataSelect: LCDCTileDataSelect = .data0
    var backgroundTileMapSelect: LCDCTileMapSelect = .tile0
    var spriteSize: LCDCSpriteSize = .size0
    var spriteEnable = false
    var backgroundEnable = false
    
    
    override init(val: Int) {
        super.init(val: val)
        setVal(val: val)
    }
    
    override func setVal(val: Int) {
        super.setVal(val: val)
        lcdEnable = getBit(n: 7)
        windowTileMapSelect = getBit(n: 6) ? .tile1 : .tile0
        windowEnable = getBit(n: 5)
        tileDataSelect = getBit(n: 4) ? .data1 : .data0
        backgroundTileMapSelect = getBit(n: 3) ? .tile1 : .tile0
        spriteSize = getBit(n: 2) ? .size1 : .size0
        spriteEnable = getBit(n: 1)
        backgroundEnable = getBit(n: 0)
    }
    
    
}
