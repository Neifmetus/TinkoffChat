//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 06.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class ConversationListViewController: UITableViewController, IConversationListModelDelegate {
    
    var model: ConversationListModel?
    var communicationManager: CommunicationManager?
    var imaginaryFriends: [Friend] = []
    private var onlineFriends: [Friend] = []
    private var historyFriends: [Friend] = []
    var delegate: CommunicationDelegate?
    var emitter: EmitterAnimator?
    
    var dataProvider: ConversationListDataProvider?

    override func viewDidLoad() {
        self.model = ConversationListModel()
        model?.delegate = self
        
        dataProvider = ConversationListDataProvider(delegate: self, tableView: self.tableView)
        
        model?.findOnlineFriends()
        
        self.emitter = EmitterAnimator(view: self.view)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func openProfile(_ sender: Any) {
        if let viewController = UIStoryboard(name: "ProfileInfo", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            let navController = UINavigationController(rootViewController: viewController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    open func reloadFriends(_ friends: [Friend]) {
        //dataProvider?.performFetch()
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = self.dataProvider?.fetchedResultsController.sections?.count else {
            return 0
        }

        return count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let objects = self.dataProvider?.fetchedResultsController.sections?[section].objects {
            if objects.count > 0 {
                if let object = objects[0] as? User {
                    if let isOnline = object.conversations?.isOnline {
                        return isOnline ? "Online" : "History"
                    }
                }
            }
        }
        
        return ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = dataProvider?.fetchedResultsController.sections else {
            return 0
        }

        return sections[section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! FriendCell
        
        if let friend = dataProvider?.fetchedResultsController.object(at: indexPath), let conversation = friend.conversations {
            cell.online = friend.conversations?.isOnline ?? false
            cell.conversationId = conversation.conversationId ?? ""
            cell.name = friend.name
            if conversation.lastMessage != nil {
                let lastMessage = conversation.lastMessage
                cell.message = lastMessage?.text
                cell.date = lastMessage?.date
                
                let unreadMessageCount = conversation.unreadMessages?.count ?? 0
                cell.hasUnreadMessages = unreadMessageCount > 0
            } else {
                cell.message = nil
                cell.date = nil
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let user = dataProvider?.fetchedResultsController.object(at: indexPath), let conversation = user.conversations {
            let unreadMessageCount = conversation.unreadMessages?.count ?? 0
            let friend = Friend(name: user.name,
                                userID: user.userId ?? "",
                                online: conversation.isOnline,
                                hasUnreadMessages: unreadMessageCount > 0)
        
            if let viewController = UIStoryboard(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController {
                viewController.service = model?.service
                viewController.friend = friend
                viewController.conversationId = conversation.conversationId ?? ""
                
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    private func getFriendsWith(online status: Bool) -> [Friend] {
        var friends: [Friend] = []
        for friend in imaginaryFriends {
            if friend.online == status {
                friends.append(friend)
            }
        }
        
        return friends
    }
}

protocol ConversationCellConfiguration: class {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
    var conversationId: String {get set}
}

class FriendCell: UITableViewCell, ConversationCellConfiguration {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var _online: Bool = false
    private var _hasUnreadMessages: Bool = false
    private var _conversationId: String = ""
    
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
                if (Calendar.current.dateComponents([.day], from: Date(), to: newDate).day ?? 0) > 7 {
                    timeFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yy")
                } else if (Calendar.current.dateComponents([.hour], from: Date(), to: newDate).hour ?? 0) > 24 {
                    timeFormatter.setLocalizedDateFormatFromTemplate("EEE")
                }
                
                print(newDate)
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
            if _online {
                self.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 224/255, alpha: 1)
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    var hasUnreadMessages: Bool {
        get { return _hasUnreadMessages }
        set {
            _hasUnreadMessages = newValue
            if hasUnreadMessages { lastMessage.font = UIFont.boldSystemFont(ofSize: 14.0) } else {
                lastMessage.font = UIFont.systemFont(ofSize: 14.0)
            }
        }
    }
    
    var conversationId: String {
        get { return _conversationId }
        set {
            _conversationId = newValue
        }
    }
}

extension ConversationListViewController: IConversationListDataProviderDelegate {
    func deleteFriends(at paths: [IndexPath]) {
        self.tableView.deleteRows(at: paths, with: .automatic)
    }
    
    func insertFriends(at paths: [IndexPath]) {
        self.tableView.insertRows(at: paths, with: .automatic)
    }
    
    func updateFriends(at paths: [IndexPath]) {
        self.tableView.reloadRows(at: paths, with: .automatic)
    }
    
    func beginUpdates() {
        self.tableView.beginUpdates()
    }
    
    func endUpdates() {
        self.tableView.endUpdates()
    }
}
