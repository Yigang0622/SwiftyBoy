//
//  MainViewController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/2/12.
//

import UIKit

class MainViewController: UIViewController {
    
    var gameboy = GameBoy()
    var gameboyLcd: GameBoyLCDView!
    var mainMenu: MainMenuView!
    let picker = MyDocumentPicker()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameboy.delegate = self
        self.view.backgroundColor = .white
        
        gameboyLcd = GameBoyLCDView()
        self.view.addSubview(gameboyLcd)
        gameboyLcd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            gameboyLcd.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameboyLcd.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameboyLcd.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            gameboyLcd.heightAnchor.constraint(equalToConstant: 500)
        ])
        
    
        mainMenu = MainMenuView()
        self.view.addSubview(mainMenu)
        mainMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainMenu.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainMenu.heightAnchor.constraint(equalToConstant: 500)
        ])
        mainMenu.loadCartridgeButton.addTarget(self, action: #selector(self.showLoadCartridgeDialog), for: .touchUpInside)
        mainMenu.loadBootRomButton.addTarget(self, action: #selector(self.showSetBootromDialog), for: .touchUpInside)

        let virtualKeyboard = VirtualJoyPadView(frame: .zero)
        self.view.addSubview(virtualKeyboard)
        virtualKeyboard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            virtualKeyboard.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            virtualKeyboard.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            virtualKeyboard.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            virtualKeyboard.heightAnchor.constraint(equalToConstant: 300)
            
        ])
        
        virtualKeyboard.onJoyPadKeyPress = { [self] key in
            gameboy.pressButton(button: key)
            
        }
        
        virtualKeyboard.onJoyPadKeyRelease = { [self] key in
            gameboy.releaseButton(button: key)
        }
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
    
}

extension MainViewController: GameBoyDelegate {
    
    func gameBoyCartridgeDidLoad(cart: Cartridge) {
        self.view.bringSubviewToFront(self.gameboyLcd)
        print("gameBoyCartridgeDidLoad")
        FPSMetric.shared.startMoinitoring()
        FPSMetric.shared.delegate = self
    }
    
    func gameBoyDidDrawNewFrame(frame: UIImage) {
        FPSMetric.shared.increaseCounter()
        gameboyLcd.setFrame(frame: frame)
    }
    
}

extension MainViewController: FPSMetricDelegate {
    
    func fpsMetricDidUpdateFps(fps: Int) {
        gameboyLcd.setFpsText(fps: fps)
    }
    
}
