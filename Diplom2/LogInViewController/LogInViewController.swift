//
//  LogInViewController.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 08.04.2022.
//

import UIKit

class LogInViewController: ScrollViewController {
    
//MARK: - Views
    
    private lazy var logoImageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.image = UIImage(named: "logo")
        return imageView
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
    
    private lazy var loginButton: LogInButton = {
        let button = LogInButton()
        button.buttonTapDelegate = self
        return button
    }()
    
    private lazy var singinButton: SimpleSingInButton = {
        let button = SimpleSingInButton()
        button.simpleButtonTapDelegate = self
        return button
    }()
    

//MARK: - Setup View
    
    override func viewDidLoad() {
        
        profileDataHandler.fillData()
        
        super.viewDidLoad()
        
        self.navigationItem.title = "LogIn View"
        self.navigationItem.backButtonTitle = "Exit"
        self.navigationController?.navigationBar.prefersLargeTitles = false

        setupView()
        activateConstraints()
    }
    
    private func setupView() {
        self.addCustomSubview(subView: logoImageView)
        
        self.addCustomSubview(subView: stackView)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        
        self.addCustomSubview(subView: loginButton)
        self.addCustomSubview(subView: singinButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        self.loginTextField.text = nil
        self.passwordTextField.text = nil
        self.loginButton.disable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        loginTextField.endEditing(true)
        passwordTextField.endEditing(true)
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
            
            logoImageView.centerXAnchor.constraint(equalTo: scrollView.backView.centerXAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -70),
            logoImageView.widthAnchor.constraint(equalToConstant: ViewConstants.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: ViewConstants.logoSize),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.backView.leadingAnchor, constant: ViewConstants.inset),
            stackView.trailingAnchor.constraint(equalTo: scrollView.backView.trailingAnchor, constant: -ViewConstants.inset),
            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: ViewConstants.textFieldHeight * 2),
            
            loginButton.leadingAnchor.constraint(equalTo: scrollView.backView.leadingAnchor, constant: ViewConstants.inset),
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: ViewConstants.inset),
            loginButton.trailingAnchor.constraint(equalTo: scrollView.backView.trailingAnchor, constant: -ViewConstants.inset),
            loginButton.heightAnchor.constraint(equalToConstant: ViewConstants.buttonHeight),
            
            singinButton.centerXAnchor.constraint(equalTo: scrollView.backView.centerXAnchor),
            singinButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: ViewConstants.inset),
            singinButton.heightAnchor.constraint(equalToConstant: ViewConstants.buttonHeight),
            singinButton.bottomAnchor.constraint(equalTo: scrollView.backView.bottomAnchor, constant: -ViewConstants.inset)
            
        ])
    }
    
//MARK: - Functions
    
    override func hideKayboard() {
        self.loginTextField.endEditing(true)
        self.passwordTextField.endEditing(true)
    }
    
    private func checkButtonState() {
        
        if self.loginTextField.isValid && self.passwordTextField.isValid {
            self.loginButton.enable()
        } else {
            self.loginButton.disable()
        }
    }
    
    override func showKeyboard(height: CGFloat) {
        
        let heightOffset = singinButton.frame.maxY - height + 3 * ViewConstants.inset
        
        if heightOffset > 0 {
            self.scrollView.contentOffset = CGPoint(x: 0, y: heightOffset)
        }
    }
}

//MARK: - Extensions

extension LogInViewController: TextEdit {
    func editText() {
        checkButtonState()
    }
    
    
}

extension LogInViewController: ButtonTap {
    
    func buttonTap() {
        
        guard let profile = profileDataHandler.loadProfile(by: loginTextField.validText)
        else {
            showErrorAlert(titel: "Wrong login or password", subTitel: "Error loging")
            return
        }
        
        guard profile.password == passwordTextField.validText
        else {
            showErrorAlert(titel: "Wrong login or password", subTitel: "Error loging")
            return
        }
        
        let profileVC = ProfileViewController()
        profileVC.profile = profile
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    
}

extension LogInViewController: SimpleButtonTap {
    
    func simpleButtonTap() {
        
        self.present(UINavigationController(rootViewController: SingInViewController()), animated: true, completion: nil)
    }
}
