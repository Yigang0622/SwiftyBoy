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
    func get16BitMem(address: Int) -> Int {
        let fs = mb.getMem(address: address + 1)
        let ls = mb.getMem(address: address)
        logs.append("get16BitMem \((fs << 8 + ls).asHexString)")
        return (fs << 8) + ls
    }
    
    func get8BitImmediate() -> Int {
        let log = "get8BitImmediate \(mb.getMem(address: pc + 1).asHexString)"
        logs.append(log)
//        print(log)
        return mb.getMem(address: pc + 1)
    }
    
    func get16BitImmediate() -> Int {
        return get16BitMem(address: pc + 1)
    }
    
    func converToSignedValue(val: Int) -> Int {
        return (val ^ 0x80) - 0x80
    }
    
    func getHalfCarryForAdd(operands: Int...) -> Bool {
        if operands.count == 2 {
            return (operands[0] & 0x0F) + (operands[1] & 0x0F) > 0x0F
        } else if operands.count == 3 {
            return (operands[0] & 0x0F) + (operands[1] & 0x0F) + (operands[2] & 0x0F) > 0x0F
        } else {
            fatalError("getHalfCarryForAdd error")
        }
    }
    
    func getFullCarryForAdd(operands: Int...) -> Bool {
        if operands.count == 2 {
            return (operands[0] & 0xFF) + (operands[1] & 0xFF) > 0xFF
        } else if operands.count == 3 {
            return (operands[0] & 0xFF) + (operands[1] & 0xFF) + (operands[2] & 0xFF) > 0xFF
        } else {
            fatalError("getFullCarryForAdd error")
        }
    }
    
    func getHalfCarryForAdd16Bit(operands: Int...) -> Bool {
        if operands.count == 2 {
            return (operands[0] & 0x0FFF) + (operands[1] & 0x0FFF) > 0x0FFF
        }
        fatalError("getHalfCarryForAdd16Bit error")
    }
    
    func getFullCarryForAdd16Bit(operands: Int...) -> Bool {
        if operands.count == 2 {
            return operands[0] + operands[1] > 0xFFFF
        }
        fatalError("getFullCarryForAdd16Bit error")
    }
    
    func getHalfCarryForSub(operands: Int...) -> Bool {
        if operands.count == 2 {
            return (operands[0] & 0xF) < (operands[1] & 0xF)
        } else if operands.count == 3 {
            return (operands[0] & 0xF) - (operands[1] & 0xF) - (operands[2] & 0xF) < 0
        } else {
            fatalError("getHalfCarryForSub error")
        }
    }
    
    func getFullCarryForSub(operands: Int...) -> Bool {
        if operands.count == 2 {
            return operands[0] < operands[1]
        } else if operands.count == 3 {
            return (operands[0] - operands[1] - operands[2]) < 0
        } else {
            fatalError("getFullCarryForSub error")
        }
    }
    
    func getZeroFlag(val: Int) -> Bool {
        return (val & 0xFF) == 0x0
    }
    
    func pushPCToStack() {
        mb.setMem(address: sp - 1, val: pc >> 8) // High
        mb.setMem(address: sp - 2, val: pc & 0xFF) // Low
        sp -= 2
    }
    
    func popPCFromStack() {
        pc = popFromStack(numOfByte: 2)
//        print("PC set to \(String(format:"%02X", pc))")
    }
    
    func popFromStack(numOfByte: Int) -> Int{
        if numOfByte == 1 {
            let n = mb.getMem(address: sp)
            sp += 1
            return n
        } else if numOfByte == 2 {
            let l = mb.getMem(address: sp)
            let h = mb.getMem(address: sp + 1)
            sp += 2
            return h << 8 | l
        } else {
            fatalError("popFromStack error")
        }
    }
    
    func swap(val: Int) -> Int {
        if val == 0 {
            return 0
        }
        return ((val & 0xF0) >> 4) | ((val & 0x0F) << 4) & 0xFF
    }
    
    func setBit(n: Int, val: Int) -> Int {
        return val | (1 << n)
    }
    
    func resetBit(n :Int, val: Int) -> Int {
        return val & ~(1 << n)
    }
    
    func _getReg(reg: RegisterType) -> Int {
        switch reg {
        case .a:
            return a
        case .f:
            return f
        case .b:
            return b
        case .c:
            return c
        case .d:
            return d
        case .e:
            return e
        case .h:
            return h
        case .l:
            return l
        case .af:
            return af
        case .bc:
            return bc
        case .de:
            return de
        case .hl:
            return hl
        case .sp:
            return sp
        }
        fatalError("_getReg error")
    }
    
    func _setReg(reg: RegisterType, val: Int) {
//        if reg8Bit.contains(reg) && val > 0xFF{
//            fatalError("set 8bit reg error, val overflow \(val.asHexString) reg\(reg)")
//        } else if reg16Bit.contains(reg) && val > 0xFFFF {
//            fatalError("set 16bit reg error, val overflow \(val.asHexString) reg\(reg)")
//        }
        switch reg {
        case .a:
            a = val
            break
        case .f:
            f = val
            break
        case .b:
            b = val
            break
        case .c:
            c = val
            break
        case .d:
            d = val
            break
        case .e:
            e = val
            break
        case .h:
            h = val
            break
        case .l:
            l = val
            break
        case .af:
            af = val
            break
        case .bc:
            bc = val
            break
        case .de:
            de = val
            break
        case .hl:
            hl = val
            break
        case .sp:
            sp = val
            break
        }
    }
    
    func _ld(to: RegisterType, from: RegisterType) {
        let v = _getReg(reg: from)
        _setReg(reg: to, val: v)
    }
    
    func _ld(to: RegisterType, val: Int) {
        _setReg(reg: to, val: val)
    }
    
    func _ld(to: RegisterType, address: Int) {
        let v = mb.getMem(address: address)
        _setReg(reg: to, val: v)
    }
    
    func _ld(toAddress: Int, fromReg: RegisterType) {
        let v = _getReg(reg: fromReg)
        mb.setMem(address: toAddress, val: v)
    }
        
    func _sub(val: Int) {
        let r = a - val
        fZ = getZeroFlag(val: r)
        fN = true
        fH = getHalfCarryForSub(operands: a, val)
        fC = getFullCarryForSub(operands: a, val)
        _setReg(reg: .a, val: r)
    }
    
    func _add(reg: RegisterType, val: Int) {
        if reg == .a {
            let r = a + val
            fZ = getZeroFlag(val: r)
            fN = false
            fH = getHalfCarryForAdd(operands: a, val)
            fC = getFullCarryForAdd(operands: a, val)
            _setReg(reg: .a, val: r)
        } else if reg == .sp {
            let r = sp + converToSignedValue(val: val)
            fZ = false
            fN = false
            fH = getHalfCarryForAdd(operands: sp, val)
            fC = getFullCarryForAdd(operands: sp, val)
            _setReg(reg: .sp, val: r)
        } else if reg == .hl {
            let r = hl + val
            fN = false
            fH = getHalfCarryForAdd16Bit(operands: hl, val)
            fC = getFullCarryForAdd16Bit(operands: hl, val)
            _setReg(reg: .hl, val: r)
        } else {
            fatalError("add failure")
        }
    }
    
    func _push(reg: RegisterType) {
        if reg == .af {
            mb.setMem(address: sp - 1, val: a)
            mb.setMem(address: sp - 2, val: f)
            sp -= 2
        } else if reg == .bc {
            mb.setMem(address: sp - 1, val: b)
            mb.setMem(address: sp - 2, val: c)
            sp -= 2
        } else if reg == .de {
            mb.setMem(address: sp - 1, val: d)
            mb.setMem(address: sp - 2, val: e)
            sp -= 2
        } else if reg == .hl {
            mb.setMem(address: sp - 1, val: h)
            mb.setMem(address: sp - 2, val: l)
            sp -= 2
        } else {
            fatalError("push error")
        }
    }
    
    func _pop(reg: RegisterType) {
        if reg == .af || reg == .bc || reg == .de || reg == .hl {
            let val = popFromStack(numOfByte: 2)
            _setReg(reg: reg, val: val)
        } else {
            fatalError("pop error")
        }
    }
    
    func _inc(reg: RegisterType) {
        if reg8Bit.contains(reg) {
            let regVal = _getReg(reg: reg)
            let r = regVal + 1
            fZ = getZeroFlag(val: r)
            fN = false
            fH = getHalfCarryForAdd(operands: regVal, 1)
            _setReg(reg: reg, val: r)
        } else if reg16Bit.contains(reg) {
            let regVal = _getReg(reg: reg)
            _setReg(reg: reg, val: regVal + 1)
        }
    }
    
    func _inc(address: Int) {
        let v = mb.getMem(address: address)
        let r = v + 1
        fZ = getZeroFlag(val: r)
        fN = false
        fH = getHalfCarryForAdd(operands: v, 1)
        mb.setMem(address: address, val: r)
    }
    
    func _dec(reg: RegisterType) {
        if reg8Bit.contains(reg) {
            let regVal = _getReg(reg: reg)
            let r = regVal - 1
            fZ = getZeroFlag(val: r)
            fN = true
            fH = getHalfCarryForSub(operands: regVal, 1)
            _setReg(reg: reg, val: r)
        } else if reg16Bit.contains(reg) {
            let regVal = _getReg(reg: reg)
            _setReg(reg: reg, val: regVal - 1)
        }
    }
    
    func _dec(address: Int) {
        let v = mb.getMem(address: address)
        let r = v - 1
        fZ = getZeroFlag(val: r)
        fN = true
        fH = getHalfCarryForSub(operands: v, 1)
        mb.setMem(address: address, val: r)
    }
    
    func _adc(val: Int) {
        let r = a + val + fC.integerValue
        fZ = getZeroFlag(val: r)
        fN = false
        fH = getHalfCarryForAdd(operands: a, val, fC.integerValue)
        fC = getFullCarryForAdd(operands: a, val, fC.integerValue)
        _setReg(reg: .a, val: r)
    }
    
    func _sbc(val: Int) {
        let r = a - val - fC.integerValue
        fZ = getZeroFlag(val: r)
        fN = true
        fH = getHalfCarryForSub(operands: a, val, fC.integerValue)
        fC = getFullCarryForSub(operands: a, val, fC.integerValue)
        _setReg(reg: .a, val: r)
    }
    
    func _cp(val: Int) {
        let r = a - val
        fZ = getZeroFlag(val: r)
        fN = true
        fH = getHalfCarryForSub(operands: a, val)
        fC = a < val
    }
    
    func _or(val: Int) {
        let r = a | val
        fZ = getZeroFlag(val: r)
        fN = false
        fH = false
        fC = false
        _setReg(reg: .a, val: r)
    }
    
    func _and(val: Int) {
        let r = a & val
        fZ = getZeroFlag(val: r)
        fN = false
        fH = true
        fC = false
        _setReg(reg: .a, val: r)
    }
    
    func _xor(val: Int) {
        let r = val ^ a
        fZ = getZeroFlag(val: r)
        fN = false
        fH = false
        fC = false
        _setReg(reg: .a, val: r)
    }
    
    func _cpl() {
        let r = ~a
        fN = true
        fH = true
        _setReg(reg: .a, val: r)
    }
    
    func _ccf() {
        fN = false
        fH = false
        fC = !fC
    }
    
    func _scf() {
        fN = false
        fH = false
        fC = true
    }
    
    func _rst(val: Int) {
        pushPCToStack()
        pc = val
    }
    
    func _call(address: Int) {
        pushPCToStack()
        pc = address
    }
    
    func _ret() {
        popPCFromStack()
    }
    
    func _reti() {
        _ret()
        interruptMasterEnable = true
    }
    
    // check
    func _rra() {
        let c = a & 0x01 == 0x01
        let r = fC ? 0x80 | (a >> 1) : a >> 1
        fZ = false
        fN = false
        fH = false
        fC = c
        _setReg(reg: .a, val: r)
    }
    
    // check
    func _rrca() {
        let c = a & 0x01 == 0x01
        let r = c ? 0x80 | (a >> 1) : a >> 1
        fZ = false
        fN = false
        fH = false
        fC = c
        a = r
    }
    
    // check
    func _rla() {
        let c = (a & 0x80) >> 7 == 0x01
        let r = (a << 1) | (fC ? 0x1: 0)
        fZ = false
        fN = false
        fH = false
        fC = c
        _setReg(reg: .a, val: r)
    }
    
    // check
    func _rlca() {
        let c = (a & 0x80) >> 7 == 0x01
        let r = (a << 1) | (c ? 0x1: 0)
        fZ = false
        fN = false
        fH = false
        fC = c
        _setReg(reg: .a, val: r)
    }
    
    func _jr(val: Int) {
        let addr = pc + converToSignedValue(val: val)
        pc = addr
    }
    
    func _jp(val: Int) {
        pc = val
    }
    
    func _daa() {
        var result = a
        if fN {
            if fH {
                result = (result - 6) & 0xFF
            }
            if fC {
                result = (result - 0x60) & 0xFF
            }
        } else {
            if fH || (result & 0xF) > 9 {
                result += 0x06
            }
            if fC || result > 0x9F {
                result += 0x60
            }
        }
        fH = false
        if result > 0xFF {
            fC = true
        }
        result &= 0xFF
        fZ = result == 0
        _setReg(reg: .a, val: result)
    }
    
}


extension Bool {
    var integerValue: Int {
        get {
            return self == true ? 1 : 0
        }
    }
}

extension Int {
    
    var asHexString: String {
        get {
            return String(format:"%02X", self)
        }
    }
    
}
