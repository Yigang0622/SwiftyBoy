//
//  RAM.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/9.
//

import Foundation

class RAM {
    
    var internalRam0 = ContiguousArray<Int>(repeating: 0x00, count: 8 * 1024)
    var nonIoInternalRam0 = ContiguousArray<Int>(repeating: 0x00, count: 0x60)
    var ioPortsRAM = ContiguousArray<Int>(repeating: 0x00, count: 0x4C)
    var internalRam1 = ContiguousArray<Int>(repeating: 0x00, count: 0x7F)
    var nonIoInternalRam1 = ContiguousArray<Int>(repeating: 0x00, count: 0x34)
    
}
