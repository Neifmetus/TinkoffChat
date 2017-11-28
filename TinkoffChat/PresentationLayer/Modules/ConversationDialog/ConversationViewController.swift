//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 06.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ConverationDelegate {
    func receive(text: String, messageID: String?)
}

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConverationDelegate {
    
    @IBOutlet weak var dialogInputTextView: UIView!
    @IBOutlet weak var dialogTextField: UITextField!
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var friend: Friend? {
        didSet {
            let label = UILabel()
            label.text = friend?.name
            self.navigationItem.titleView = label
        }
    }
    
    var service: ConversationListService?
    var model: ConversationModel?
    var conversationId: String = ""
    var dataProvider: ConversationDataProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let service = self.service {
            model = ConversationModel(service: service)
            model?.delegate = self
        }
        
        self.dataProvider = ConversationDataProvider(delegate: self, conversationId: conversationId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
    }
    
    @IBAction func sendMessageToFriend(_ sender: Any) {
        self.moveUserTo(online: false)
        dialogTextField.endEditing(true)
        if let text = dialogTextField.text {
            if text != "" {
                if let userID = friend?.userID {
                    service?.sendMessage(text: text, userID: userID)
                }
                
                Message.saveMessage(with: conversationId, text: text, isIncoming: false)
                dialogTextField.text = ""
            }
        }
    }
    
    func receive(text: String, messageID: String?) {
        Message.saveMessage(with: conversationId, text: text, isIncoming: true)
    }
    
    func moveUserTo(online status: Bool) {
        let onlineColor = UIColor.blue
        let offlineColor = UIColor.lightGray
        
        let originalButtonTransform = sendMessageButton.transform
        let scaledButtonTransform = originalButtonTransform.scaledBy(x: 1.15, y: 1.15)
        UIView.animate(withDuration: 0.5, animations: {
            self.sendMessageButton.transform = scaledButtonTransform
            self.sendMessageButton.setTitleColor(status ? onlineColor : offlineColor, for: .normal)

        }, completion: { (completed) in
            self.sendMessageButton.transform = originalButtonTransform.inverted()
            self.sendMessageButton.isEnabled = status
        })
        
        let originalTransform = (self.navigationItem.titleView as? UILabel)?.transform
        let scaledTransform = originalTransform?.scaledBy(x: 1.15, y: 1.15)
        UIView.animate(withDuration: 1.0, animations: {
            self.navigationItem.titleView?.transform = scaledTransform!
        }, completion: { (completed) in
            //self.navigationItem.titleView?.transform = (originalTitleTransform?.inverted())!
        })
    }
    
    @objc private func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let isShowing = notification.name == .UIKeyboardWillShow
            
            self.view.frame.origin.y = isShowing ? -keyboardFrame.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MessageCell()
        if let message = dataProvider?.fetchedResultsController.object(at: indexPath) {
            let id = message.isIncoming ? "incoming" : "outgoing"
            cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MessageCell
            cell.message = message.text
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = dataProvider?.fetchedResultsController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
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
    @IBOutlet weak var bubbleView: UIView!
    
    var message: String? {
        get { return messageLabel.text}
        set {
            messageLabel.text = newValue
            messageLabel.numberOfLines = 0
        }
    }
}

extension ConversationViewController: IConversationDataProviderDelegate {
    func deleteMessages(at paths: [IndexPath]) {
        conversationTableView.deleteRows(at: paths, with: .automatic)
    }
    
    func insertMessages(at paths: [IndexPath]) {
        conversationTableView.insertRows(at: paths, with: .automatic)
    }
    
    func updateMessages(at paths: [IndexPath]) {
        conversationTableView.reloadRows(at: paths, with: .automatic)
    }
    
    func beginUpdates() {
        conversationTableView.beginUpdates()
    }
    
    func endUpdates() {
        conversationTableView.endUpdates()
    }
}
