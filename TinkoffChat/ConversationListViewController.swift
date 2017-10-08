//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 06.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class ConversationListViewController: UITableViewController {
    
    var imaginaryFriends: [Friend] = []
    
    override func viewDidLoad() {
        createImaginaryFriends()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Online" : "History"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imaginaryFriends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! FriendCell
        let friend = imaginaryFriends[indexPath.row]
        
        if indexPath.section == 0 {
            cell.online = true
        }

        cell.name = friend.name
        if let messages = friend.messages {
            let lastMessage = messages[messages.count - 1]
            cell.message = lastMessage.text
            cell.date = lastMessage.date
            cell.hasUnreadMessages = friend.hasUnreadMessages
        } else {
            cell.message = nil
            cell.date = nil
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let viewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController {
            viewController.friend = imaginaryFriends[indexPath.row]
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

protocol ConversationCellConfiguration: class {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}

class FriendCell: UITableViewCell, ConversationCellConfiguration {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var _online: Bool = false
    private var _hasUnreadMessages: Bool = false
    
    var name: String? {
        get { return nameLabel.text}
        set {
            nameLabel.text = newValue
            nameLabel.font = UIFont.systemFont(ofSize: 18)
        }
    }
    
    var message: String? {
        get { return lastMessage.text }
        set {
            if let newMessage = newValue {
                lastMessage.text = newMessage
            } else {
                lastMessage.text = "No messages yet"
            }
        }
    }
    
    var date: Date? {
        get { return Date() }
        set {
            let timeFormatter = DateFormatter()
            timeFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
            
            if let newDate = newValue {
                dateLabel.text = timeFormatter.string(from: newDate)
            } else {
                dateLabel.text = "No date"
            }
        }
    }
    
    var online: Bool {
        get { return _online }
        set {
            _online = newValue
            if _online { self.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 224/255, alpha: 1) }
        }
    }
    
    var hasUnreadMessages: Bool {
        get { return _hasUnreadMessages }
        set {
            _hasUnreadMessages = newValue
            if hasUnreadMessages { lastMessage.font = UIFont.boldSystemFont(ofSize: 16.0) }
        }
    }
}