//
//  LCDCRegister.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/8.
//

import Foundation

enum LCDCTileMapSelect {
    case map0
    case map1
}

enum LCDCTileDataSelect {
    case tile0
    case tile1
}

enum LCDCSpriteSize {
    case size8x8
    case size8x16
}

class LCDCRegister: BaseRegister {
    
    var lcdEnable = false
    var windowTileMapSelect: LCDCTileMapSelect = .map0
    var windowEnable = false
    var tileDataSelect: LCDCTileDataSelect = .tile0
    var backgroundTileMapSelect: LCDCTileMapSelect = .map0
    var spriteSize: LCDCSpriteSize = .size8x8
    var spriteEnable = false
    var backgroundEnable = false
    
    
    override init(val: Int) {
        super.init(val: val)
        setVal(val: val)
    }
    
    override func setVal(val: Int) {
        super.setVal(val: val)
        lcdEnable = getBit(n: 7)
        windowTileMapSelect = getBit(n: 6) ? .map1 : .map0
        windowEnable = getBit(n: 5)
        tileDataSelect = getBit(n: 4) ? .tile1 : .tile0
        backgroundTileMapSelect = getBit(n: 3) ? .map1 : .map0
        spriteSize = getBit(n: 2) ? .size8x16 : .size8x8
        spriteEnable = getBit(n: 1)
        backgroundEnable = getBit(n: 0)
    }
    
    
}
