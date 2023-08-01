//
//  NewConversationViewController.swift
//  ChatApp
//
//  Created by Macbook on 23/07/23.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageDelegate: class {
    func controller(_ controller: NewConversationViewController, wantsToStartChatWith user: User)
}

class NewConversationViewController: UITableViewController {

    
    private var users  = [User]()
    weak var delegate: NewMessageDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        // Do any additional setup after loading the view.
    }
    
    
    @objc func handleDismissal(){
        self.dismiss(animated: true)
    }
    
    
    func fetchUsers(){
        Service.fetchUsers { users in
            self.users = users
            
            self.tableView.reloadData()
        }
    }
    
    
    func configureUI(){
        configureNavigationBar(withTitle: "New Messages", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
}

extension NewConversationViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        print("User in array \(users[indexPath.row].username)")
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wantsToStartChatWith: users[indexPath.row])
    }
}
