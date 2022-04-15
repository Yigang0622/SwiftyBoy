//
//  RegNR44.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/14.
//

import UIKit

class RegNR44: BaseRegister {
    
    var initialize: Bool {
        get {
            return super.getBit(n: 7)
        }
        set {
            newValue ? setBit(n: 7) : clearBit(n: 7)
        }
    }
    
    var lengthEnable: Bool {
        get {
            return getBit(n: 6)
        }
        set {
            newValue ? setBit(n: 6) : clearBit(n: 6)
        }
    }

}
