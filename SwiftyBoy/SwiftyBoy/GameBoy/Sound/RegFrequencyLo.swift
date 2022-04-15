//
//  RegFrequencyLo.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit

class RegFrequencyLo: BaseRegister {
    
    var frequencyLoData: Int {
        get {
            return getVal()
        }
        set {
            setVal(val: newValue)
        }        
    }

}
