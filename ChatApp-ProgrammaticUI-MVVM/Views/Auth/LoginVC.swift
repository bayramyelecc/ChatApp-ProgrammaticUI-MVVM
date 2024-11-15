//
//  LoginVC.swift
//  ChatApp-ProgrammaticUI-MVVM
//
//  Created by Bayram Yeleç on 13.11.2024.
//

import UIKit
import SnapKit
import FirebaseAuth


class LoginVC: UIViewController {
    
    private let usernameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let gotoRegisterButton = UIButton()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        FireBaseManager.shared.delegate = self
    }
    
    func setupUI(){
        setup()
        configure()
        layout()
    }
    
}

extension LoginVC: RegisterVCProtocol, FirebaseManagerDelegate {
    func setup() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Register"
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.keyboardType = .emailAddress
        usernameTextField.textColor = .black
        usernameTextField.font = .systemFont(ofSize: 15, weight: .bold)
        usernameTextField.autocapitalizationType = .none
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
        loginButton.setTitle("Register", for: .normal)
        loginButton.tintColor = .white
        loginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = .systemRed
        gotoRegisterButton.setTitle("Hesabın var mı? Giriş Yap", for: .normal)
        gotoRegisterButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        gotoRegisterButton.setTitleColor(.systemBlue, for: .normal)
        gotoRegisterButton.addTarget(self, action: #selector(goToRegisterVC), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    func configure() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(gotoRegisterButton)
    }
    
    func layout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc func goToRegisterVC(){
        let vc = RegisterVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginButtonTapped(){
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Lütfen tüm alanları doldurun.")
            return
        }
        guard email.contains("@"), email.contains(".") else {
            showAlert(message: "Lütfen geçerli bir email girin.")
            return
        }
        guard password.count >= 6 else {
            showAlert(message: "Şifreniz en az 6 karakter içermelidir.")
            return
        }
        FireBaseManager.shared.registerUser(username: username, email: email, password: password)
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
