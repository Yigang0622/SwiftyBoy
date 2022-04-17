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
    var helpButton: UIButton!
    
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
        stackView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.width.equalTo(350)
            make.center.equalToSuperview()
        }
       
        stackView.alignment = UIStackView.Alignment.center
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .equalSpacing
        
        loadCartridgeButton = buttonWithTitle(title: "LOAD CARTRIDGE")
        stackView.addArrangedSubview(loadCartridgeButton)
        
        loadBootRomButton = buttonWithTitle(title: "SET BOOTROM")
        stackView.addArrangedSubview(loadBootRomButton)
        
        devModeButton = buttonWithTitle(title: "DEV MODE")
        stackView.addArrangedSubview(devModeButton)
        
        helpButton = buttonWithTitle(title: "HELP")
        stackView.addArrangedSubview(helpButton)
    }
    
    
    func buttonWithTitle(title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.pixelatedFont(ofSize: 40)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
}

extension UIFont {
    
    static func pixelatedFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Pixelated", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }
    
}
