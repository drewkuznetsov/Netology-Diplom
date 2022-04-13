//
//  SingInViewController.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 07.04.2022.
//

import UIKit

class SingInViewController: ScrollViewController {
    
//MARK: - Views
    
    private lazy var photoImageView: RoundImageView = {
        let imageView = RoundImageView(frame: .zero)
        imageView.imageViewTapDelegate = self
        return imageView
    }()
    
    private lazy var addPhotoLabel: AddPhotoLable = {
        let label = AddPhotoLable()
        return label
    }()
    
    private lazy var stackView: VerticalStackView = {
        let stack = VerticalStackView()
        return stack
    }()
    
    private lazy var loginTextField: LoginTextField = {
        let textField = LoginTextField()
        textField.textEditDelegate = self
        return textField
    }()
    
    private lazy var passwordTextField: PasswordTextField = {
        let textField = PasswordTextField()
        textField.textEditDelegate = self
        return textField
    }()
    
    private lazy var nameTextField: NameTextField = {
        let textField = NameTextField()
        textField.textEditDelegate = self
        return textField
    }()
    
    private lazy var statusTextField: StatusTextField = {
        let textField = StatusTextField()
        textField.textEditDelegate = self
        return textField
    }()
    
    private lazy var singinButton: SingInButton = {
        let button = SingInButton()
        button.buttonTapDelegate = self
        return button
    }()

//MARK: - Setup View
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "SingIn View"
        setupView()
        activateConstraints()
    }
    
    private func setupView() {
        
        self.addCustomSubview(subView: addPhotoLabel)
        self.addCustomSubview(subView: photoImageView)
        
        self.addCustomSubview(subView: stackView)
        self.stackView.addArrangedSubview(loginTextField)
        self.stackView.addArrangedSubview(passwordTextField)
        self.stackView.addArrangedSubview(nameTextField)
        self.stackView.addArrangedSubview(statusTextField)
        
        self.addCustomSubview(subView: singinButton)
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            scrollView.backView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            scrollView.backView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scrollView.backView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollView.backView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            photoImageView.topAnchor.constraint(equalTo: scrollView.backView.topAnchor, constant: ViewConstants.inset),
            photoImageView.centerXAnchor.constraint(equalTo: self.scrollView.backView.centerXAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: ViewConstants.imageSize),
            photoImageView.heightAnchor.constraint(equalToConstant: ViewConstants.imageSize),
            
            addPhotoLabel.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            addPhotoLabel.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.backView.leadingAnchor, constant: ViewConstants.inset),
            stackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: ViewConstants.inset),
            stackView.trailingAnchor.constraint(equalTo: scrollView.backView.trailingAnchor, constant: -ViewConstants.inset),
            stackView.heightAnchor.constraint(equalToConstant: ViewConstants.textFieldHeight * 4),
            
            singinButton.leadingAnchor.constraint(equalTo: scrollView.backView.leadingAnchor, constant: ViewConstants.inset),
            singinButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: ViewConstants.inset),
            singinButton.trailingAnchor.constraint(equalTo: scrollView.backView.trailingAnchor, constant: -ViewConstants.inset),
            singinButton.heightAnchor.constraint(equalToConstant: ViewConstants.buttonHeight),
            singinButton.bottomAnchor.constraint(equalTo: scrollView.backView.bottomAnchor, constant: -ViewConstants.inset)
            
        ])
    }
    
//MARK: - Functions
    
    override func hideKayboard() {
        
        self.loginTextField.endEditing(true)
        self.passwordTextField.endEditing(true)
        self.nameTextField.endEditing(true)
        self.statusTextField.endEditing(true)
    }
    
    func checkButtonState() {
        
        if photoImageView.isValid && loginTextField.isValid && passwordTextField.isValid && nameTextField.isValid && statusTextField.isValid {
            singinButton.enable()
        } else {
            singinButton.disable()
        }
    }
    
    override func imageDidLoad() {
        self.photoImageView.image = self.photoImage
        self.checkButtonState()
    }
    
    override func showKeyboard(height: CGFloat) {
        
        let heightOffset = singinButton.frame.maxY - height + 3 * ViewConstants.inset
        
        if heightOffset > 0 {
            self.scrollView.contentOffset = CGPoint(x: 0, y: heightOffset)
        }
    }
}

//MARK: - Extensions

extension SingInViewController: TextEdit {
    
    func editText() {
        checkButtonState()
    }
}

extension SingInViewController: ImageViewTap {
    func imageViewTap() {
        showSourceList()
    }
    
    
}

extension SingInViewController: ButtonTap {
    
    func buttonTap() {

        if let _ = profileDataHandler.loadProfile(by: loginTextField.validText) {
            showErrorAlert(titel: "LogIn already exists", subTitel: "SingIn Error")
            return
        }
        
        profileDataHandler.addProfile(login: loginTextField.validText,
                                         password: passwordTextField.validText,
                                         name: nameTextField.validText,
                                         status: statusTextField.validText,
                                         image: photoImage)
        
        self.dismiss(animated: true, completion: nil)
 
    }
    
}
