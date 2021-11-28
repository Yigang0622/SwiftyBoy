//
//  CPU+Instruction.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import Foundation

struct CPUInstruction {
    var name: String
    var opcode: UInt8
    var inscruction: () -> Int
}

extension CPU {
    
    func execute(opcode: Int) -> Int {
        if baseInstructions[Int(opcode)] != nil{
            print("exec op \(String(format:"%02X", opcode))")
            let cycle = baseInstructions[Int(opcode)]!.inscruction()
            return cycle
        } else {
            print("invailed opcode")
            return 0
        }
    }
    
    func LD_06() -> Int {
        let v = mb.getMem(address: self.pc + 1)
        b = v
        self.pc += 2
        return 8
    }
    
    func LD_0E() -> Int {
        let v = mb.getMem(address: self.pc + 1)
        c = v
        self.pc += 2
        return 8
    }
    
    func LD_16() -> Int {
        let v = mb.getMem(address: self.pc + 1)
        d = v
        self.pc += 2
        return 8
    }
    
    func LD_1E() -> Int {
        let v = mb.getMem(address: self.pc + 1)
        e = v
        self.pc += 2
        return 8
    }
    
    func LD_26() -> Int {
        let v = mb.getMem(address: self.pc + 1)
        h = v
        self.pc += 2
        return 8
    }
    
    func LD_2E() -> Int {
        let v = mb.getMem(address: self.pc + 1)
        l = v
        self.pc += 2
        return 8
    }
    
    // 2. LD r1 r2
    func LD_7F() -> Int {
        a = a
        self.pc += 1
        return 4
    }
    
    func LD_78() -> Int {
        a = b
        self.pc += 1
        return 4
    }
    
    func LD_79() -> Int {
        a = c
        self.pc += 1
        return 4
    }
    
    func LD_7A() -> Int {
        a = d
        self.pc += 1
        return 4
    }
    
    func LD_7B() -> Int {
        a = e
        self.pc += 1
        return 4
    }
    
    func LD_7C() -> Int {
        a = h
        self.pc += 1
        return 4
    }
    
    func LD_7D() -> Int {
        a = l
        self.pc += 1
        return 4
    }
    
    func LD_7E() -> Int {
        a = mb.getMem(address: hl)
        self.pc += 1
        return 8
    }
    
    func LD_40() -> Int {
        b = b
        pc += 1
        return 4
    }
    
    func LD_41() -> Int {
        b = c
        pc += 1
        return 4
    }
    
    func LD_42() -> Int {
        b = d
        pc += 1
        return 4
    }
    
    func LD_43() -> Int {
        b = e
        pc += 1
        return 4
    }
    
    func LD_44() -> Int {
        b = h
        pc += 1
        return 4
    }
    
    func LD_45() -> Int {
        b = l
        pc += 1
        return 4
    }
    
    func LD_46() -> Int {
        b = mb.getMem(address: hl)
        pc += 1
        return 8
    }
    
    func LD_48() -> Int {
        c = b
        pc += 1
        return 4
    }
    
    func LD_49() -> Int {
        c = c
        pc += 1
        return 4
    }
    
    func LD_4A() -> Int {
        c = d
        pc += 1
        return 4
    }
    
    func LD_4B() -> Int {
        c = e
        pc += 1
        return 8
    }
    
    func LD_4C() -> Int {
        c = h
        pc += 1
        return 8
    }
    
    func LD_4D() -> Int {
        c = l
        pc += 1
        return 4
    }
    
    func LD_4E() -> Int {
        c = mb.getMem(address: hl)
        pc += 1
        return 8
    }
    
    func LD_50() -> Int {
        d = b
        pc += 1
        return 4
    }
    
    func LD_51() -> Int {
        d = c
        pc += 1
        return 4
    }
    
    func LD_52() -> Int {
        d = d
        pc += 1
        return 4
    }
    
    func LD_53() -> Int {
        d = e
        pc += 1
        return 4
    }
    
    func LD_54() -> Int {
        d = h
        pc += 1
        return 4
    }
    
    func LD_55() -> Int {
        d = l
        pc += 1
        return 4
    }
    
    func LD_56() -> Int {
        d = mb.getMem(address: hl)
        pc += 1
        return 8
    }
    
    func LD_58() -> Int {
        e = b
        pc += 1
        return 4
    }
    
    func LD_59() -> Int {
        e = c
        pc += 1
        return 4
    }
    
    func LD_5A() -> Int {
        e = d
        pc += 1
        return 4
    }
    
    func LD_5B() -> Int {
        e = e
        pc += 1
        return 4
    }
    
    func LD_5C() -> Int {
        e = h
        pc += 1
        return 4
    }
    
    func LD_5D() -> Int {
        e = l
        pc += 1
        return 4
    }
    
    func LD_5E() -> Int {
        e = mb.getMem(address: hl)
        pc += 1
        return 8
    }
    
    func LD_60() -> Int {
        h = b
        pc += 1
        return 4
    }
    
    func LD_61() -> Int {
        h = c
        pc += 1
        return 4
    }
    
    func LD_62() -> Int {
        h = d
        pc += 1
        return 4
    }
    
    func LD_63() -> Int {
        h = e
        pc += 1
        return 4
    }
    
    func LD_64() -> Int {
        h = h
        pc += 1
        return 4
    }
    
    func LD_65() -> Int {
        h = l
        pc += 1
        return 4
    }
    
    func LD_66() -> Int {
        h = mb.getMem(address: hl)
        pc += 1
        return 8
    }
    
    func LD_68() -> Int {
        l = b
        pc += 1
        return 4
    }
    
    func LD_69() -> Int {
        l = c
        pc += 1
        return 4
    }
    
    func LD_6A() -> Int {
        l = d
        pc += 1
        return 4
    }
    
    func LD_6B() -> Int {
        l = e
        pc += 1
        return 4
    }
    
    func LD_6C() -> Int {
        l = h
        pc += 1
        return 4
    }
    
    func LD_6D() -> Int {
        l = l
        pc += 1
        return 4
    }
    
    func LD_6E() -> Int {
        l = mb.getMem(address: hl)
        pc += 1
        return 8
    }
    
    func LD_70() -> Int {
        mb.setMem(address: hl, val: b)
        pc += 1
        return 8
    }
    
    func LD_71() -> Int {
        mb.setMem(address: hl, val: c)
        pc += 1
        return 8
    }
    
    func LD_72() -> Int {
        mb.setMem(address: hl, val: d)
        pc += 1
        return 8
    }
    
    func LD_73() -> Int {
        mb.setMem(address: hl, val: e)
        pc += 1
        return 8
    }
    
    func LD_74() -> Int {
        mb.setMem(address: hl, val: h)
        pc += 1
        return 8
    }
    
    func LD_75() -> Int {
        mb.setMem(address: hl, val: l)
        pc += 1
        return 8
    }
    
    func LD_36() -> Int {
        let n = mb.getMem(address: pc + 1)
        mb.setMem(address: hl, val: n)
        pc += 2
        return 12
    }
    
    // 3. LD A.n
    func LD_0A() -> Int {
        a = mb.getMem(address: bc)
        self.pc += 1
        return 8
    }
    
    func LD_1A() -> Int {
        a = mb.getMem(address: de)
        self.pc += 1
        return 8
    }

    func LD_FA() -> Int {
        let addr = get16BitMem(address: pc + 1)
        a = mb.getMem(address: addr)
        self.pc += 3
        return 16
    }
    
    func LD_3E() -> Int {
        a = mb.getMem(address: pc + 1)
        self.pc += 1
        return 8
    }
    
    // 4 LD n, A
    func LD_47() -> Int {
        b = a
        pc += 1
        return 4
    }
    
    func LD_4F() -> Int {
        c = a
        pc += 1
        return 4
    }
    
    func LD_57() -> Int {
        d = a
        pc += 1
        return 4
    }
    
    func LD_5F() -> Int {
        e = a
        pc += 1
        return 4
    }
    
    func LD_67() -> Int {
        h = a
        pc += 1
        return 4
    }
    
    func LD_6F() -> Int {
        l = a
        pc += 1
        return 4
    }
    
    func LD_02() -> Int {
        mb.setMem(address: bc, val: a)
        pc += 1
        return 8
    }
    
    func LD_12() -> Int {
        mb.setMem(address: de, val: a)
        pc += 1
        return 8
    }
    
    func LD_77() -> Int {
        mb.setMem(address: hl, val: a)
        pc += 1
        return 8
    }
    
    func LD_EA() -> Int {
        let addr = get16BitMem(address: pc + 1)
        mb.setMem(address: addr, val: a)
        pc += 3
        return 16
    }
    
    func LD_F2() -> Int {
        a = mb.getMem(address: 0xFF00 + c)
        pc += 1
        return 8
    }
    
    func LD_E2() -> Int {
        mb.setMem(address: 0xFF00 + c, val: a)
        pc += 1
        return 8
    }
    
    func LD_3A() -> Int {
        a = mb.getMem(address: hl)
        hl -= 1
        pc += 1
        return 8
    }
    
    func LD_32() -> Int {
        mb.setMem(address: hl, val: a)
        hl -= 1
        pc += 1
        return 8
    }
    
    func LD_2A() -> Int {
        a = mb.getMem(address: hl)
        hl += 1
        pc += 1
        return 8
    }
    
    func LD_22() -> Int {
        mb.setMem(address: hl, val: a)
        hl += 1
        pc += 1
        return 8
    }
    
    func LDH_E0() -> Int {
        let v = mb.getMem(address: pc + 1)
        mb.setMem(address: 0xFF00 + v, val: a)
        pc += 2
        return 12
    }
    
    func LDH_F0() -> Int {
        let v = get8BitImmediate()
        a = mb.getMem(address:  0xFF00 + v)
        pc += 2
        return 12
    }
    
    func LD_01() -> Int {
        bc = get16BitImmediate()
        pc += 3
        return 12
    }
    
    func LD_11() -> Int {
        de = get16BitImmediate()
        pc += 3
        return 12
    }
    
    func LD_21() -> Int {
        hl = get16BitImmediate()
        pc += 3
        return 12
    }
    
    func LD_31() -> Int {
        sp = get16BitImmediate()
        pc += 3
        return 12
    }
    
    func LD_F9() -> Int {
        sp = hl
        pc += 1
        return 8
    }
    
    func LDHL_F8() -> Int{
        let n = get8BitSignedImmediateValue()
        hl = sp + n
        fZ = false
        fN = false
        fC = getFullCarryForAdd(oprand1: sp, oprand2: n)
        fH = getHalfCarryForAdd(oprand1: sp, oprand2: n)
        //        fC = sp + n > 0xFF
        //        fH = (sp & 0xF) + (n & 0xF) > 0xF
        pc += 2
        return 12
    }
    
    func LD_08() -> Int {
        let nn = get16BitImmediate()
        mb.setMem(address: nn, val: sp & 0xFF)
        mb.setMem(address: nn + 1, val: sp >> 8)
        pc += 3
        return 20
    }
    
    // TODO double check
    func PUSH_F5() -> Int {
        mb.setMem(address: sp - 1, val: a)
        mb.setMem(address: sp - 2, val: f)
        sp -= 2
        pc += 1
        return 16
    }
    
    func PUSH_C5() -> Int {
        mb.setMem(address: sp - 1, val: b)
        mb.setMem(address: sp - 2, val: c)
        sp -= 2
        pc += 1
        return 16
    }
    
    func PUSH_D5() -> Int {
        mb.setMem(address: sp - 1, val: d)
        mb.setMem(address: sp - 2, val: e)
        sp -= 2
        pc += 1
        return 16
    }
    
    func PUSH_E5() -> Int {
        mb.setMem(address: sp - 1, val: h)
        mb.setMem(address: sp - 2, val: l)
        sp -= 2
        pc += 1
        return 16
    }
    
    func POP_F1() -> Int {
        a = mb.getMem(address: sp + 1)
        f = mb.getMem(address: sp)
        sp += 2
        pc += 1
        return 16
    }
    
    func POP_C1() -> Int {
        b = mb.getMem(address: sp + 1)
        c = mb.getMem(address: sp)
        sp += 2
        pc += 1
        return 14
    }
    
    func POP_D1() -> Int {
        d = mb.getMem(address: sp + 1)
        e = mb.getMem(address: sp)
        sp += 2
        pc += 1
        return 14
    }
    
    func POP_E1() -> Int {
        h = mb.getMem(address: sp + 1)
        l = mb.getMem(address: sp)
        sp += 2
        pc += 1
        return 14
    }
    
    // ALU
    func ADD_87() -> Int {
        let r = a + a
        a = r
        fZ = r == 0x0
        fN = false
        fH = getHalfCarryForAdd(oprand1: a, oprand2: a)
        fC = getFullCarryForAdd(oprand1: a, oprand2: a)
        pc += 1
        return 4
    }
    
    func ADD_80() -> Int {
        let r = a + b
        a = r
        fZ = r == 0x0
        fN = false
        fH = getHalfCarryForAdd(oprand1: a, oprand2: b)
        fC = getFullCarryForAdd(oprand1: a, oprand2: b)
        pc += 1
        return 4
    }
    
    func ADD_81() -> Int {
        let r = a + c
        a = r
        fZ = r == 0x0
        fN = false
        fH = getHalfCarryForAdd(oprand1: a, oprand2: c)
        fC = getFullCarryForAdd(oprand1: a, oprand2: c)
        pc += 1
        return 4
    }
    
    func ADD_82() -> Int {
        let r = a + d
        a = r
        fZ = r == 0x0
        fN = false
        fH = getHalfCarryForAdd(oprand1: a, oprand2: d)
        fC = getFullCarryForAdd(oprand1: a, oprand2: d)
        pc += 1
        return 4
    }
    
    func ADD_83() -> Int {
        let r = a + e
        a = r
        fZ = r == 0x0
        fN = false
        fH = getHalfCarryForAdd(oprand1: a, oprand2: e)
        fC = getFullCarryForAdd(oprand1: a, oprand2: e)
        pc += 1
        return 4
    }
    
    func ADD_84() -> Int {
        let r = a + h
        a = r
        fZ = r == 0x0
        fN = false
        fH = getHalfCarryForAdd(oprand1: a, oprand2: h)
        fC = getFullCarryForAdd(oprand1: a, oprand2: h)
        pc += 1
        return 4
    }
    
    func ADD_85() -> Int {
        let r = a + l
        a = r
        fZ = r == 0x0
        fN = false
        fH = getHalfCarryForAdd(oprand1: a, oprand2: l)
        fC = getFullCarryForAdd(oprand1: a, oprand2: l)
        pc += 1
        return 4
    }
    
    func ADD_86() -> Int {
        let v = mb.getMem(address: hl)
        let r = a + v
        a = r
        fZ = r == 0x0
        fN = false
        fH = getHalfCarryForAdd(oprand1: a, oprand2: v)
        fC = getFullCarryForAdd(oprand1: a, oprand2: v)
        pc += 1
        return 8
    }
    
    func ADD_C6() -> Int {
        let v = get8BitImmediate()
        let r = a + v
        a = r
        fZ = r == 0x0
        fN = false
        fH = getHalfCarryForAdd(oprand1: a, oprand2: v)
        fC = getFullCarryForAdd(oprand1: a, oprand2: v)
        pc += 2
        return 8
    }
    
}
