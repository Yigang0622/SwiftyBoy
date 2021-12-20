//
//  SwiftyBoyTests.swift
//  SwiftyBoyTests
//
//  Created by Yigang Zhou on 2021/11/25.
//

import XCTest
@testable import SwiftyBoy

class SwiftyBoyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let mb = Motherboard()
        mb.cpu.fZ = true
        mb.cpu.fN = true
        mb.cpu.fH = true
        mb.cpu.fC = true
        
        XCTAssert(mb.cpu.fZ == true)
        XCTAssert(mb.cpu.fN == true)
        XCTAssert(mb.cpu.fH == true)
        XCTAssert(mb.cpu.fC == true)
        
//        let r = LCDCRegister(val: 0b11111111)
//        let p = PaletteRegister(val: 0b11111111)
            
       
//        XCTAssert(mb.cpu.setBit(val: 0b00001111, n: 7) == 0b10001111 )
//        XCTAssert(mb.cpu.resetBit(val: 0b10001111, n: 7) == 0b00001111 )
        
    }
    
    func testPopAndPushStack() {
        let mb = Motherboard()
        mb.cpu.pc = 0xABCD
        let spAddress = 65530
        mb.cpu.sp = spAddress
        mb.cpu.pushPCToStack()
        XCTAssert(mb.cpu.sp == spAddress - 2)
        mb.cpu.pc = 0
        XCTAssert(mb.cpu.pc == 0)
        mb.cpu.popPCFromStack()
        XCTAssert(mb.cpu.pc == 0xABCD)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
