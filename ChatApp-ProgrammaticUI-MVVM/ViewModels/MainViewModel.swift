//
//  MainViewModel.swift
//  ChatApp-ProgrammaticUI-MVVM
//
//  Created by Bayram Yeleç on 14.11.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class MainViewModel {
    
    let db = Firestore.firestore()
    
    var messages: [Messages] = []
    
    var didUpdateMessages: (() -> Void)?
    
    
    func sendMessage(_ message: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let time = Date().timeIntervalSince1970
        let newMessage = Messages(uid: uid, message: message, timestamp: time)
        db.collection("messages").addDocument(data: [
            "uid": uid,
            "message": newMessage.message,
            "timestamp": time
        ]) { error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                print("mesaj gönderimi başarılı")
            }
        }
    }
    
    
    func loadMessages(){
        guard (Auth.auth().currentUser?.uid) != nil else {return}
        
        db.collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            self.messages = snapshot?.documents.compactMap { document in
                let data = document.data()
                let uid = data["uid"] as? String ?? ""
                let message = data["message"] as? String ?? ""
                let timestamp = data["timestamp"] as? TimeInterval ?? 0
                return Messages(uid: uid, message: message, timestamp: timestamp)
            } ?? []
            self.didUpdateMessages?()
        }
    }

}
