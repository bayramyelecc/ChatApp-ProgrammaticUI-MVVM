//
//  MainTableViewCell.swift
//  ChatApp-ProgrammaticUI-MVVM
//
//  Created by Bayram Yeleç on 15.11.2024.
//

import UIKit
import SnapKit
import FirebaseAuth

class MainTableViewCell: UITableViewCell {
    
    static let identifier: String = "MainTableViewCell"
    
    private let ballonView = UIView()
    private let messageText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(ballonView)
        ballonView.addSubview(messageText)
        
        ballonView.layer.cornerRadius = 10
        ballonView.clipsToBounds = true
        messageText.textColor = .white
        messageText.font = .systemFont(ofSize: 15, weight: .bold)
        messageText.numberOfLines = 0
        
        setupInitialConstraints()
    }
    
    private func setupInitialConstraints() {
        ballonView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.width.lessThanOrEqualTo(250)
            make.right.equalToSuperview().offset(16)
        }
        
        messageText.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(with message: Messages, userId: String) {
        let isCurrentUser = message.uid == userId
        messageText.text = message.message
        
        ballonView.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.width.lessThanOrEqualTo(250)
            
            if isCurrentUser {
                ballonView.backgroundColor = .systemBlue
                make.width.lessThanOrEqualTo(250)
                make.right.equalToSuperview().offset(-16)
            } else {
                ballonView.backgroundColor = .systemGray
                make.left.equalToSuperview().offset(16)
                make.width.lessThanOrEqualTo(250)
            }
        }
        contentView.layoutIfNeeded()
    }
}
