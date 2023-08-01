//
//  ViewController.swift
//  ChatApp
//
//  Created by Macbook on 23/07/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore

private let reuseIdentifier = "ConversationCell"

class ConversationViewController: UIViewController {
    
    private var conversations = [Conversation]()
    private let tableView = UITableView()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemMint
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
        configureUI()
        authenticateUser()
        fetchConversations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
    }
    
    
   @objc func showProfile(){
       let controller = ProfileViewController()
       let nav = UINavigationController(rootViewController: controller)
       nav.modalPresentationStyle = .fullScreen
       present(nav, animated: true)

   }
    
    @objc func showNewMessage(){
        let controller = NewConversationViewController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    
    func fetchConversations(){
        Service.fetchConversation { conversations in
            print(conversations)
            self.conversations = conversations
            self.tableView.reloadData()
        }
    }
    
    
    func authenticateUser(){
        if Auth.auth().currentUser?.uid == nil{
            presentLoginScreen()
        } else {
            self.dismiss(animated: true)
        }
    }
    
    
    func logout(){
        do
        {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: error signing out...")
        }
    }
    
    
    func presentLoginScreen(){
        DispatchQueue.main.async {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    func configureUI(){
        view.backgroundColor = .white
        
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
        configureTableView()
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56/2
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
    
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    
    func showChatController(forUser user: User){
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ConversationViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        
        cell.conversation = conversations[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
    }
    
}

//MARK: - New message controller delegate

extension ConversationViewController: NewMessageDelegate{
    func controller(_ controller: NewConversationViewController, wantsToStartChatWith user: User) {
        controller.dismiss(animated: true)
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
}
