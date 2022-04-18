//
//  BootRom+MemoryAccess.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/18.
//

import Foundation

extension BootRom: MemoryAccessable {
    
    func getMem(address: Int) -> Int {
        if address < bytes.count {
            return Int(bytes[address])
        } else {
            return 0xFF
        }
    }
    
    func setMem(address: Int, val: Int) {
        
    }
    
    func canAccess(address: Int) -> Bool {
        return address < 100
    }
    
}
