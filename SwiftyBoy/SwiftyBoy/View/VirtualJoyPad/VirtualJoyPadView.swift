//
//  VirtualJoyPadView.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/2/12.
//

import UIKit

class VirtualJoyPadView: UIView, VirtualJoyPadInteractiveZoneDelegate {
    
    var dPad: VirtualJoyPadInteractiveZone!

    var aButton: VirtualJoyPadInteractiveZone!
    var bButton: VirtualJoyPadInteractiveZone!
    
    var selectButton: VirtualJoyPadInteractiveZone!
    var startButton: VirtualJoyPadInteractiveZone!
    
    var onJoyPadKeyPress: ((JoypadButtonType) -> Void)?
    var onJoyPadKeyRelease: ((JoypadButtonType) -> Void)?
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .cyan
     
        
        dPad = VirtualJoyPadDPad(frame: .zero)
        self.addSubview(dPad)
        dPad.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dPad.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            dPad.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            dPad.widthAnchor.constraint(equalToConstant: 120),
            dPad.heightAnchor.constraint(equalToConstant: 120)
        ])
        dPad.delegate = self
        
        
        aButton = VirtualJoyPadInteractiveZone(frame: .zero)
        self.addSubview(aButton)
        aButton.buttonType = .a
        aButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aButton.bottomAnchor.constraint(equalTo: dPad.centerYAnchor, constant: -5),
            aButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            aButton.widthAnchor.constraint(equalToConstant: 50),
            aButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        aButton.delegate = self
        
        bButton = VirtualJoyPadInteractiveZone(frame: .zero)
        self.addSubview(bButton)
        bButton.buttonType = .b
        bButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bButton.topAnchor.constraint(equalTo: dPad.centerYAnchor, constant: 5),
            bButton.trailingAnchor.constraint(equalTo: aButton.leadingAnchor, constant: -20),
            bButton.widthAnchor.constraint(equalToConstant: 50),
            bButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        bButton.delegate = self
        
        selectButton = VirtualJoyPadInteractiveZone(frame: .zero)
        self.addSubview(selectButton)
        selectButton.buttonType = .select
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            selectButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -50),
            selectButton.widthAnchor.constraint(equalToConstant: 50),
            selectButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        selectButton.delegate = self
        
        startButton = VirtualJoyPadInteractiveZone(frame: .zero)
        self.addSubview(startButton)
        startButton.buttonType = .start
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 50),
            startButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        startButton.delegate = self
    }
    
    func onKeyPress(button: JoypadButtonType) {
     
        onJoyPadKeyPress?(button)
        
    }
    
    func onKeyRelease(button: JoypadButtonType) {
        
        onJoyPadKeyRelease?(button)
    }
    
}
