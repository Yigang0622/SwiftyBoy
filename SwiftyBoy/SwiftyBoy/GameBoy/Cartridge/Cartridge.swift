//
//  Cartridge.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/7.
//

import Foundation

class Cartridge: NSObject, MemoryAccessable {
    
    var name: String!
    var meta: CartridgeMeta!
    var fileName: String = ""
    
    init(bytes: [UInt8], name: String, meta: CartridgeMeta, fileName: String) {
        self.name = name
        self.meta = meta
        self.fileName = fileName
    }
    

    func setMem(address: Int, val: Int) {
        fatalError("setMem require override")
    }
    
    func getMem(address: Int) -> Int {
        fatalError("getMem require override")
    }
    
    func canAccess(address: Int) -> Bool {
        return (address >= 0x0000 && address < 0x8000) || (address >= 0xA000 && address < 0xC000)
    }
    
}
