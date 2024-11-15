//
//  ViewController.swift
//  ChatApp-ProgrammaticUI-MVVM
//
//  Created by Bayram Yeleç on 12.11.2024.
//

import UIKit
import SnapKit
import FirebaseAuth

protocol MainVCProtocol {
    func drawUI()
    func configure()
    func setuptableView()
}

class MainVC: UIViewController {
    
    let viewModel = MainViewModel()
    
    private let tableView = UITableView()
    private let textView = UITextField()
    private let sendButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        drawUI()
        configure()
        setuptableView()
        didUpdate()
        setupKeyboardObservers()
        closeKeyboard()
    }
    
}

extension MainVC : MainVCProtocol {

    func didUpdate(){
        viewModel.didUpdateMessages = { [weak self] in
            self?.tableView.reloadData()
            if let self = self , !self.viewModel.messages.isEmpty {
                scrollToBottom()
            }
        }
        viewModel.loadMessages()
    }
    
    func scrollToBottom() {
        let lastIndex = IndexPath(row: viewModel.messages.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    private func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKey))
        view.addGestureRecognizer(tap)
    }
    @objc func closeKey(){
        view.endEditing(true)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    func setuptableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    
    func drawUI() {
        view.backgroundColor = .systemBackground
    }
    
    func configure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutTapped))
        navigationItem.title = "Chat App"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        view.addSubview(sendButton)
        view.addSubview(textView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(textView.snp.top).offset(-10)
        }
        textView.placeholder = "Type your message here..."
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 15, weight: .bold)
        textView.autocapitalizationType = .none
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .black
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(textView)
        }
        textView.rightView = sendButton
        textView.rightViewMode = .always
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(50)
        }
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc func sendButtonTapped(){
        if let text = textView.text, !text.isEmpty {
            viewModel.sendMessage(text)
            textView.text = ""
        }
    }
    
    @objc func logoutTapped(){
        showAlert(title: "Uyarı", message: "Çıkış yapmak istediğinizden emin misiniz?")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { _ in
            do {
                try Auth.auth().signOut()
                if let  sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let loginVC = LoginVC()
                    let navController = UINavigationController(rootViewController: loginVC)
                    sceneDelegate.window?.rootViewController = navController
                    sceneDelegate.window?.makeKeyAndVisible()
                }
                
            } catch {
                print("çıkış yapma hatası")
            }
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        let message = viewModel.messages[indexPath.row]
        let userId = Auth.auth().currentUser?.uid ?? ""
        cell.configure(with: message, userId: userId)
        cell.selectionStyle = .none
        return cell
    }

}
