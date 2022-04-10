//
//  RegNR52.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/10.
//

import UIKit

class RegNR52: BaseRegister {
    
    public var shouldUpdateAllSoundChannelStatus: ((_ enable: Bool) -> Void )?
    public var shouldUpdateSoundChannel1Status: ((_ enable: Bool) -> Void )?
    public var shouldUpdateSoundChannel2Status: ((_ enable: Bool) -> Void )?
    public var shouldUpdateSoundChannel3Status: ((_ enable: Bool) -> Void )?
    public var shouldUpdateSoundChannel4Status: ((_ enable: Bool) -> Void )?
    
    var allSoundEnabled = false
    var sound1Enabled = false
    var sound2Enabled = false
    var sound3Enabled = false
    var sound4Enabled = false
    
    override func setVal(val: Int) {
        super.setVal(val: val)
        allSoundEnabled = getBit(n: 7)
        sound4Enabled = getBit(n: 3)
        sound3Enabled = getBit(n: 2)
        sound2Enabled = getBit(n: 1)
        sound1Enabled = getBit(n: 0)
        
        shouldUpdateAllSoundChannelStatus?(allSoundEnabled)
        shouldUpdateSoundChannel1Status?(sound1Enabled)
        shouldUpdateSoundChannel2Status?(sound2Enabled)
        shouldUpdateSoundChannel3Status?(sound3Enabled)
        shouldUpdateSoundChannel4Status?(sound4Enabled)
    }
    
    override func getVal() -> Int {
        return (super.getVal() & 0b1000111)
    }

}
