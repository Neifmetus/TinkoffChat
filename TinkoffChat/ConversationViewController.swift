//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 06.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = friend?.messages![indexPath.row]
        let id = message?.source == .incoming ? "incoming" : "outgoing"
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MessageCell
        cell.message = message?.text

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

protocol MessageCellConfiguration: class {
    var message: String? {get set}
}

class MessageCell: UITableViewCell, MessageCellConfiguration {
    @IBOutlet weak var messageView: UITextView!
    
    var message: String? {
        get { return messageView.text}
        set {
            messageView.text = newValue
        }
    }
}
