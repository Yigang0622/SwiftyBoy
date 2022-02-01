//
//  DummyCart.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/2/1.
//

import Foundation

class DummyCart: Cartridge {
    
    init() {
        super.init(bytes: [], name: "", meta: CartridgeMeta.init(type: .MBC1, sram: false, battery: false, rtc: false), fileName: "")
    }
    
    override func getMem(address: Int) -> Int {
        return 0xFF
    }
    
    override func setMem(address: Int, val: Int) {
        
    }
    
}
