//
//  DMA+MemoryAccess.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/17.
//

import Foundation

extension DMAController: MemoryAccessable {
        
    func canAccess(address: Int) -> Bool {
        return (address == 0xFF46)
    }
    
    func getMem(address: Int) -> Int {
        return 0
    }
    
    func setMem(address: Int, val: Int) {
        dma(src: (val & 0xFF))
    }
    
}
