//
//  SerialController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/18.
//

import Foundation

class SerialController: MemoryAccessable {
    
    private var mb: Motherboard!
    private var serialOutput: String = ""
    
    init(mb: Motherboard) {
        self.mb = mb
    }
    
    func canAccess(address: Int) -> Bool {
        return address == 0xFF02
    }
    
    func getMem(address: Int) -> Int {
        return -1
    }
    
    func setMem(address: Int, val: Int) {
        if val == 0x81 {
            let chr = getMem(address: 0xff01)
            serialOutput += String(Character(UnicodeScalar(chr)!))
            print("\(self)", serialOutput)
        }
    }
    
}

