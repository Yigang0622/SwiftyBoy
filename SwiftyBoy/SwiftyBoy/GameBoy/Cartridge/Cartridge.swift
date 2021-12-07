//
//  Cartridge.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/7.
//

import Foundation

class Cartridge {
    
    var romBanks = [[UInt8]]()
    
    init(bytes: [UInt8]) {
        print("Loading cartidge")
        // 16kb
        let bankSize = 16 * 1024
        romBanks = bytes.chunked(into: bankSize)
        print("[rom banks] \(romBanks.count) ")
        
        let type = CartridgeUtil.getCaridgeMeta(flag: romBanks[0][0x0147])
        print("[Type] \(type)")
        
        let name = Array(romBanks[0][0x0134...0x0142]).reduce("") { partialResult, next in
            partialResult + String(Character(UnicodeScalar(next)))
        }
        print("[Cartridge Name] \(name)")
        
    }
    
    func getMem(address: Int) -> Int {
        if address >= 0x0000 && address < 0x4000 {
            return Int(romBanks[0][address])
        } else if address >= 0x4000 && address < 0x8000 {
            return Int(romBanks[1][address])
        }
        print("cart get mem fail")
        return 0
    }
    
}
