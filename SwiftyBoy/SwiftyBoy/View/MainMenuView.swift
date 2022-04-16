//
//  MainMenuView.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/2/4.
//

import UIKit
import Darwin

class MainMenuView: UIView {
    
    var loadCartridgeButton: UIButton!
    var loadBootRomButton: UIButton!
    var devModeButton: UIButton!
    
    var titleLabel: UILabel!
    var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    
    private func setupViews() {
        self.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),
            titleLabel.widthAnchor.constraint(equalToConstant: 350),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        titleLabel.textColor = .black
        titleLabel.text = ""
        titleLabel.font = UIFont.pixelatedFont(ofSize: 80)
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints =  false
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 200),
            stackView.widthAnchor.constraint(equalToConstant: 350),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        stackView.alignment = UIStackView.Alignment.center
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .equalSpacing
        
        loadCartridgeButton = UIButton()
        loadCartridgeButton.translatesAutoresizingMaskIntoConstraints = false
        loadCartridgeButton.setTitle("LOAD CARTRIDGE", for: .normal)
        loadCartridgeButton.titleLabel?.font = UIFont.pixelatedFont(ofSize: 40)
        loadCartridgeButton.setTitleColor(.black, for: .normal)
        
        stackView.addArrangedSubview(loadCartridgeButton)
        
        loadBootRomButton = UIButton()
        loadBootRomButton.translatesAutoresizingMaskIntoConstraints = false
        loadBootRomButton.setTitle("SET BOOTROM", for: .normal)
        loadBootRomButton.titleLabel?.font = UIFont.pixelatedFont(ofSize: 40)
        loadBootRomButton.setTitleColor(.black, for: .normal)
        stackView.addArrangedSubview(loadBootRomButton)
        
        devModeButton = UIButton()
        devModeButton.translatesAutoresizingMaskIntoConstraints = false
        devModeButton.setTitle("DEV MODE", for: .normal)
        devModeButton.titleLabel?.font = UIFont.pixelatedFont(ofSize: 40)
        devModeButton.setTitleColor(.black, for: .normal)
        stackView.addArrangedSubview(devModeButton)
    }
    
}

extension UIFont {
    
    static func pixelatedFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Pixelated", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }
    
}
