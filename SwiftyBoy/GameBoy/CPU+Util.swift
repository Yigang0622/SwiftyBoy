//
//  CPU+Util.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/27.
//

import Foundation

extension CPU {
    
    /// 读取address 和 address + 1的内容拼成16位，ls byte 在前
    /// 大端处理器
    func get16BitMem(address: UInt) -> UInt {
        let fs = mb.getMem(address: address + 1)
        let ls = mb.getMem(address: address)
        return fs << 8 + ls
    }
    
    func get8BitImmediate() -> UInt {
        return mb.getMem(address: pc + 1)
    }
    
    func get16BitImmediate() -> UInt {
        return get16BitMem(address: pc + 1)
    }
}

