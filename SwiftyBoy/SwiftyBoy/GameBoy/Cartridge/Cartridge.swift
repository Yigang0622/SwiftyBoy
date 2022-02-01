//
//  Cartridge.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/7.
//

import Foundation

class Cartridge {
    
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
    
}
