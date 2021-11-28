//
//  ViewController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let mb = Motherboard()
        mb.setMem(address: 0, val: 0x06)
        mb.setMem(address: 1, val: 0x0F)
        mb.setMem(address: 2, val: 0x78)
        
        mb.cpu.fN = true
        let a = mb.cpu.fN
        let b = mb.cpu.fH
//        for i in 0...1 {
//            let opcode = mb.getMem(address: mb.cpu.pc)
//            mb.cpu.execute(opcode: opcode)
//        }

    }


}

