//
//  CustomTextFields.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 07.04.2022.
//

import UIKit

//MARK: - Custom TextField

class CustomTextField: UITextField {
    
    var textEditDelegate: TextEdit?
    var isValid: Bool { return self.text != nil }
    var validText: String { return self.isValid ? self.text! : "" }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.textColor = .black
        
        let leftView = UIView(frame: CGRect( x: 0, y: 0, width: ViewConstants.textFieldCornerRadius, height: 2))
        self.leftView = leftView
        self.leftViewMode = .always
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.cornerRadius = ViewConstants.textFieldCornerRadius
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.white.cgColor
        
        self.returnKeyType = .done
        
        self.addTarget(self, action: #selector(editTextBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editText), for: .editingChanged)
        self.addTarget(self, action: #selector(editTextEnd), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setErrorState() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    func setNormalState() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
//    func validateText() -> Bool {
//        let text = self.text ?? ""
//        self.isValid = !text.isEmpty
//        self.validText = self.isValid ? text : ""
//        return self.isValid
//    }
    
    @objc func editTextBegin() {
        self.setNormalState()
    }
    
    @objc func editText() {
        if self.isValid {
            self.textEditDelegate?.editText()
        }
    }
    
    @objc func editTextEnd() {
        if self.isValid {
            self.setNormalState()
        } else {
            setErrorState()
        }
    }
}


//MARK: - Name TextField
class NameTextField: CustomTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = "Name"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Status TextField

class StatusTextField: CustomTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = "Status"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - LogIn TextField
class LoginTextField: CustomTextField {
    
    override var isValid: Bool {
        let text = self.text ?? ""
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = text.range(
            of: emailPattern,
            options: .regularExpression
        )
        return (result != nil)
    }
    
    override var validText: String {return self.isValid ? self.text!.lowercased() : ""}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = "LogIn"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - PasswordTextField

class PasswordTextField: CustomTextField {
    
    override var isValid: Bool {let text = self.text ?? ""
        return text.count >= 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = "Password"
        self.isSecureTextEntry = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - TitelTextField

class TitelTextField: CustomTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = "Post Titel"
        self.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


