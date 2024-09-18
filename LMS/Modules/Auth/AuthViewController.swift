//
//  AuthenticationControllerViewController.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import UIKit
import TinyConstraints

protocol AuthViewControllerDelegate: AnyObject {
    func dismissController()
    func showAlert()
}

class AuthViewController: UIViewController, AuthViewControllerDelegate {
    private let label = UILabel()
    private let loginTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let dismissHandler: () -> Void
    private lazy var presenter = AuthPresenter(authController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissHandler()
    }
    
    init (dismissHandler: @escaping () -> Void) {
        self.dismissHandler = dismissHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AuthViewControllerDelegate
    
    func dismissController() {
        dismiss(animated: true)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: AppStrings.errorTitle,
                                                message: AppStrings.wronAuthMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.okTitle, style: .default))
        present(alertController, animated: true)
    }
    
    //MARK: - private helpers
    
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
    
    private func setupView() {
        view.backgroundColor = AppColors.appBlack
        
        loginButton.backgroundColor = AppColors.appColor
        loginButton.setTitle(AppStrings.signInTitle, for: .normal)
        
        label.text = AppStrings.kinopoiskTitle
        label.textColor = AppColors.appColor
        label.font = UIFont(name: label.font.fontName, size: 50)
        
        setupTextField(field: loginTextField, placeholder: AppStrings.loginTitle)
        setupTextField(field: passwordTextField, placeholder: AppStrings.passwordTitle)
        
        loginButton.addTarget(self, action: #selector(loginButtonHandler), for: .touchUpInside)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHandler))
        view.addGestureRecognizer(gestureRecognizer)
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
    
    //MARK: - handlers
    
    @objc
    private func loginButtonHandler() {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else {
            showAlert()
            return
        }
        presenter.signIn(login: login, password: password)
    }
    
    @objc
    private func touchHandler() {
        view.endEditing(true)
    }
    
}

