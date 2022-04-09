//
//  ViewController.swift
//  AudioKitDemo
//
//  Created by Yigang Zhou on 2022/4/9.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    let engin = AudioEngine()
    let osc = DynamicOscillator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        engin.output = osc
        osc.frequency = 440
        osc.amplitude = 0.5
        osc.setWaveTable(waveform: audioKitTable(dutyCycle: 0.5))
        osc.start()
        
        do {
            try engin.start()
        } catch let err {
            print(err.localizedDescription)
        }
        print("play")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [self] in
            osc.frequency = 1000
        }
    }

    
    func audioKitTable(dutyCycle: Double) -> Table {
        let size = 4_096
        var content = [Table.Element](zeros: size)
        for i in 0..<Int(Double(size) * dutyCycle) {
            content[i] = 1.0
        }
        return Table(content)
    }


}

