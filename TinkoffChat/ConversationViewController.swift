//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 06.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dialogInputTextView: UIView!
    @IBOutlet weak var dialogTextField: UITextField!
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
        }
    }
    
    var communicationManager: CommunicationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let friend = friend {
            sendMessageButton.isEnabled = friend.online
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func sendMessageToFriend(_ sender: Any) {
            if dialogTextField.text != "" || dialogTextField.text != nil {
            let message = Message(text: dialogTextField.text, messageID: nil, date: Date(), source: .outgoing)
            friend?.messages?.append(message)
            
            dialogTextField.text = ""
            self.conversationTableView.reloadData()
        }
    }
    
    @objc private func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let isShowing = notification.name == .UIKeyboardWillShow
            
            self.view.frame.origin.y = isShowing ? -keyboardFrame.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isShowing {
                    let indexPath = IndexPath(row: (self.friend?.messages?.count)! - 1, section: 0)
                    self.conversationTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MessageCell()
        if let messages = friend?.messages {
            let message = messages[indexPath.row]
            let id = message.source == .incoming ? "incoming" : "outgoing"
            cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MessageCell
            cell.message = message.text
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend?.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

protocol MessageCellConfiguration: class {
    var message: String? {get set}
}

class MessageCell: UITableViewCell, MessageCellConfiguration {
    @IBOutlet weak var messageLabel: UILabel!
    
    var message: String? {
        get { return messageLabel.text}
        set {
            messageLabel.text = newValue
            messageLabel.numberOfLines = 0
        }
    }
}
