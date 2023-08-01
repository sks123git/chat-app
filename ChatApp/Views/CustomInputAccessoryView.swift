//
//  CustomInputAccessoryView.swift
//  ChatApp
//
//  Created by Macbook on 27/07/23.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: AnyObject{
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String)
}

class CustomInputAccessoryView: UIView{
    
    //MARK: - Proprties
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private lazy var messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.systemMint, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor,right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 6, paddingBottom: 4, paddingRight: 8)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 4)
        placeHolderLabel.centerY(inView: messageInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    //MARK: - Selectors
    
    @objc func handleSendMessage(){
        guard let message = messageInputTextView.text else { return }
        delegate?.inputView(self, wantsToSend: message)
    }
    
    @objc func handleTextInputChange(){
        placeHolderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    //MARK: - Helpers
    
    func clearMessageText(){
        messageInputTextView.text = nil
        placeHolderLabel.isHidden = false
    }
}
