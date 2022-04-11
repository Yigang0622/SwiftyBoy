//
//  RegInitializeParam.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit

class RegInitializeParam: BaseRegister {
    
    var initialize: Bool = false
    var frequencyHiData: Int = 0
    var lengthEnable: Bool = false
    
    override func getVal() -> Int {
        return super.getVal() & 0b01000000
    }
    
    override func setVal(val: Int) {
        super.setVal(val: val)
        frequencyHiData = (val & 0b111)
        lengthEnable = getBit(n: 6)
        initialize = getBit(n: 7)
    }
    
}
