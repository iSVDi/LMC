//
//  AuthenticationControllerViewController.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import UIKit
import TinyConstraints

class AuthViewController: AppNavigationController {
    
    private let label = UILabel()
    private let loginTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private lazy var presenter = AuthPresenter(authController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupView()
    }
        
    private func setupLayout() {
        let stack = UIStackView()
        
        [label, stack, loginButton].forEach { subview in view.addSubview(subview)}
        
        stack.axis = .vertical
        stack.spacing = 30
        stack.centerInSuperview(offset: CGPoint(x: 0, y: -50), usingSafeArea: true)
        stack.horizontalToSuperview(insets: .horizontal(16))
        
        [loginTextField, passwordTextField].forEach { view in
            stack.addArrangedSubview(view)
            view.height(50)
            view.horizontalToSuperview()
        }
        
        label.horizontalToSuperview(insets: .horizontal(16))
        label.textAlignment = .center
        label.bottomToTop(of: stack, offset: -80)
        
        loginButton.topToBottom(of: stack, offset: 100)
        loginButton.horizontalToSuperview(insets: .horizontal(16))
        loginButton.height(50)
    }
    
    //TODO: localize?
    private func setupView() {
        view.backgroundColor = .black
        
        loginButton.backgroundColor = AppColors.appColor
        loginButton.setTitle("Войти", for: .normal)
        
        label.text = "KinoPoisk"
        label.textColor = AppColors.appColor
        label.font = UIFont(name: label.font.fontName, size: 50)
    
        setupTextField(field: loginTextField, placeholder: "Логин")
        setupTextField(field: passwordTextField, placeholder: "Пароль")
        
        loginButton.addTarget(self, action: #selector(loginButtonHandler), for: .touchUpInside)
    }
    
    private func setupTextField(field: UITextField, placeholder: String) {
        field.backgroundColor = .clear
        field.layer.borderColor = AppColors.appGray.cgColor
        field.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.appGray]
        )
        field.layer.borderWidth = 2
        let paddingView = UIView()
        paddingView.width(16)
        field.leftView = paddingView
        field.leftViewMode = .always
        field.textColor = AppColors.appWhite
    }
    
    //MARK: handlers
    @objc
    private func loginButtonHandler() {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else {
            //TODO: handle?
            return
        }
        presenter.saveUser(login: login, password: password)
    }
    
}
