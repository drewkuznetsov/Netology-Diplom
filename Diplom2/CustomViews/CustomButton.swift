//
//  CustomButton.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 07.04.2022.
//

import UIKit

class CustomButton: UIButton {
    
    var buttonTapDelegate: ButtonTap?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.isEnabled = false
        self.backgroundColor = ColorSet.colorMid

        self.setTitleColor(.white, for: .normal)
        self.clipsToBounds = true
        self.layer.cornerRadius = ViewConstants.buttonRadius

        self.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enable() {
        self.isEnabled = true
        self.backgroundColor = ColorSet.colorPurp
    }
    
    func disable() {
        
        self.isEnabled = false
        self.backgroundColor = ColorSet.colorMid
    }
    
    @objc private func buttonTap() {
        self.buttonTapDelegate?.buttonTap()
    }
}

class SingInButton: CustomButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitle("Sing In", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LogInButton: CustomButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitle("LogIn", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Simple Button

class SimpleButton: UIButton {
    
    var simpleButtonTapDelegate: SimpleButtonTap?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(.purple, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTap() {
        self.simpleButtonTapDelegate?.simpleButtonTap()
    }
    
}

class SimpleSingInButton: SimpleButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("SingIn", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TitelButton: SimpleButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

