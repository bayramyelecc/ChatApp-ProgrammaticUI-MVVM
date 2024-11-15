//
//  RegisterVC.swift
//  ChatApp-ProgrammaticUI-MVVM
//
//  Created by Bayram Yeleç on 13.11.2024.
//

import UIKit
import SnapKit

protocol RegisterVCProtocol {
    func setup()
    func configure()
    func layout()
}

class RegisterVC: UIViewController {
    
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let registerButton = UIButton()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI(){
        setup()
        configure()
        layout()
    }
}

extension RegisterVC: RegisterVCProtocol {
    func setup() {
        view.backgroundColor = .systemBackground
        titleLabel.text = "Login"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.textColor = .black
        emailTextField.font = .systemFont(ofSize: 15, weight: .bold)
        emailTextField.autocapitalizationType = .none
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.keyboardType = .emailAddress
        passwordTextField.textColor = .black
        passwordTextField.font = .systemFont(ofSize: 15, weight: .bold)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        registerButton.setTitle("Login", for: .normal)
        registerButton.tintColor = .white
        registerButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        registerButton.layer.cornerRadius = 10
        registerButton.backgroundColor = .systemRed
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    func configure() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        view.addSubview(titleLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(registerButton)
    }
    
    func layout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.center.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc func registerButtonTapped(){
        if let email = emailTextField.text, !email.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {
            FireBaseManager.shared.loginUser(email: email, password: password)
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let mainVC = MainVC()
                let navController = UINavigationController(rootViewController: mainVC)
                sceneDelegate.window?.rootViewController = navController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        } else {
            showAlert(message: "Lütfen tüm alanları doldurun.")
        }
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
}
