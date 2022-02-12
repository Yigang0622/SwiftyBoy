//
//  BootRom.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/2/12.
//

import Foundation

class BootRom: NSObject, MemoryAccessable {
    
    let bytes:[UInt8]
    
    init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
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
