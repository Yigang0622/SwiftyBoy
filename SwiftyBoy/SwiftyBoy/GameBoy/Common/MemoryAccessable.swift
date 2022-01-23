//
//  MemoryAccessable.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/1/23.
//

import Foundation

protocol MemoryAccessable {
    
    func canAccess(address: Int) -> Bool
    func setMem(address: Int, val: Int)
    func getMem(address: Int) -> Int
    
}
