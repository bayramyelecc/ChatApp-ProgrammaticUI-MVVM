//
//  FireBaseManager.swift
//  ChatApp-ProgrammaticUI-MVVM
//
//  Created by Bayram Yeleç on 12.11.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol FirebaseManagerDelegate: AnyObject {
    func showAlert(message: String)
}

class FireBaseManager {
    
    static let shared = FireBaseManager()
    let db = Firestore.firestore()
    
    weak var delegate: (FirebaseManagerDelegate)?
    
    func registerUser(username: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                // Error durumunu logla
                print("Hata oluştu: \(error.localizedDescription)")
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        self.delegate?.showAlert(message: "Bu e-posta adresi zaten kullanılıyor.")
                    default:
                        self.delegate?.showAlert(message: error.localizedDescription)
                    }
                }
            } else {
                print("Kullanıcı başarıyla kaydedildi.")
                guard let userId = Auth.auth().currentUser?.uid else { return }
                self.db.collection("users").addDocument(data: [
                    "username": username,
                    "userId": userId
                ])
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let mainVC = MainVC()
                    let navController = UINavigationController(rootViewController: mainVC)
                    sceneDelegate.window?.rootViewController = navController
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            }
        }
    }

    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if result != nil {
                print("giriş başarılı")
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let mainVC = MainVC()
                    let navController = UINavigationController(rootViewController: mainVC)
                    sceneDelegate.window?.rootViewController = navController
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            } else {
                print("hata: \(error as Any)")
            }
        }
        
    }
    
}
