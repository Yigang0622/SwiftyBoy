//
//  ViewController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import UIKit
import Foundation
import MobileCoreServices
import UniformTypeIdentifiers
import SnapKit

class ViewController: UIViewController {
        
    var gameboy = GameBoy()
    var gameboyLcd: GameBoyLCDView!
    var mainMenu: MainMenuView!
    var devPannel: DevPanelView = DevPanelView()
    var devMode = false
    let container = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameboy.delegate = self
        self.view.backgroundColor = .white
        
        
        
        self.view.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(container.snp.height).multipliedBy(160.0 / 144.0)
        }
        
        
        gameboyLcd = GameBoyLCDView()
        container.addSubview(gameboyLcd)
        gameboyLcd.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        

        mainMenu = MainMenuView()
        container.addSubview(mainMenu)
        mainMenu.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainMenu.loadCartridgeButton.addTarget(self, action: #selector(self.showLoadCartridgeDialog), for: .touchUpInside)
        mainMenu.loadBootRomButton.addTarget(self, action: #selector(self.showSetBootromDialog), for: .touchUpInside)
        mainMenu.devModeButton.addTarget(self, action: #selector(self.toggleDevMode), for: .touchUpInside)
        mainMenu.helpButton.addTarget(self, action: #selector(self.showHelpDialog), for: .touchUpInside)
        
        devPannel.updateSoundChannelStatus = { [self] channel, enable in
            gameboy.mb.sound.setChannelStatus(channel: channel, enable: enable)
        }
        
    }
    
    
    
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
                
        presses.forEach { press in
            if let key = press.key {
                if(key.keyCode == .keyboardW) {
                    gameboy.pressButton(button: .up)
                } else if (key.keyCode == .keyboardA) {
                    gameboy.pressButton(button: .left)
                } else if (key.keyCode == .keyboardS) {
                    gameboy.pressButton(button: .down)
                } else if (key.keyCode == .keyboardD) {
                    gameboy.pressButton(button: .right)
                } else if (key.keyCode == .keyboardK) {
                    gameboy.pressButton(button: .a)
                } else if (key.keyCode == .keyboardJ) {
                    gameboy.pressButton(button: .b)
                } else if (key.keyCode == .keyboardN) {
                    gameboy.pressButton(button: .select)
                } else if (key.keyCode == .keyboardM) {
                    gameboy.pressButton(button: .start)
                } else if (key.keyCode == .keyboardSpacebar) {
                    gameboy.setBoostMode(enable: true)
                }
            }
        }
        
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        presses.forEach { press in
            if let key = press.key {
                if(key.keyCode == .keyboardW) {
                    gameboy.releaseButton(button: .up)
                } else if (key.keyCode == .keyboardA) {
                    gameboy.releaseButton(button: .left)
                } else if (key.keyCode == .keyboardS) {
                    gameboy.releaseButton(button: .down)
                } else if (key.keyCode == .keyboardD) {
                    gameboy.releaseButton(button: .right)
                } else if (key.keyCode == .keyboardK) {
                    gameboy.releaseButton(button: .a)
                } else if (key.keyCode == .keyboardJ) {
                    gameboy.releaseButton(button: .b)
                } else if (key.keyCode == .keyboardN) {
                    gameboy.releaseButton(button: .select)
                } else if (key.keyCode == .keyboardM) {
                    gameboy.releaseButton(button: .start)
                }else if (key.keyCode == .keyboardSpacebar) {
                    gameboy.setBoostMode(enable: false)
                }
            }
        }
    }
    
 

}

let picker = MyDocumentPicker()

extension ViewController {

    @objc func showHelpDialog() {
        let alert = UIAlertController(title: "Help", message: "UP - W\nDown - S\nLeft - A\nRight - D\nB - J\nA - K\nSelect - N\nStart - M\nTurbo - Space", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
             
    }
    
    @objc func showLoadCartridgeDialog() {
        picker.showPicker(fromController: self, fileType: ".gb") { [self] url in
            if let url = url {
                gameboy.loadCartridge(url: url)
            }
        }
    }
    
    @objc func showSetBootromDialog() {
        picker.showPicker(fromController: self, fileType: "") { [self] url in
            if let url = url {
                gameboy.loadBootRom(url: url)
            }
        }
    }
    
    @objc func toggleDevMode() {
        self.devMode = !self.devMode
        if devMode {
            WindowUtil.setDevWidnowSize()
            
            self.view.addSubview(devPannel)
            devPannel.snp.makeConstraints { make in
                make.left.equalTo(gameboyLcd.snp.right)
                make.right.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        } else {
            WindowUtil.setNormalWindowSize()
            devPannel.snp.removeConstraints()
            devPannel.removeFromSuperview()
        }
    }
    
}


extension ViewController: GameBoyDelegate {
    
    func gameBoyCartridgeDidLoad(cart: Cartridge) {
        self.container.bringSubviewToFront(self.gameboyLcd)
        print("gameBoyCartridgeDidLoad")
        FPSMetric.shared.startMoinitoring()
        FPSMetric.shared.delegate = self
    }
    
    func gameBoyDidDrawNewFrame(frame: UIImage) {
        FPSMetric.shared.increaseCounter()
        gameboyLcd.setFrame(frame: frame)
        
        if devMode {
            devPannel.backgroundLayer.image = gameboy.mb.gpu.renderer.getBackgroundLayer().toImage()
            devPannel.windowLayer.image = gameboy.mb.gpu.renderer.getWindowLayer().toImage()
            devPannel.spriteLayer.image = gameboy.mb.gpu.renderer.getSpriteLayer().toImage()
        }
       
    }
    
}

extension ViewController: FPSMetricDelegate {
    
    func fpsMetricDidUpdateFps(fps: Int) {
        gameboyLcd.setFpsText(fps: fps)
    }
    
}

