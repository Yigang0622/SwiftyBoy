//
//  RamBase.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/18.
//

import Foundation

class RamBase: NSObject, MemoryAccessable {
    
    internal var ram: ContiguousArray<Int>!
    internal var offset: Int = 0
    internal var count: Int = 0
    
    init(count: Int, offset: Int) {
        self.ram = ContiguousArray<Int>(repeating: 0x00, count: count)
        self.offset = offset
        self.count = count
    }
    
    func canAccess(address: Int) -> Bool {
        return (address >= offset && address < offset + count)
    }
    
    func getMem(address: Int) -> Int {
        return ram[address - offset]
    }
    
    func setMem(address: Int, val: Int) {
        self.ram[address - offset] = val
    }
    
}

