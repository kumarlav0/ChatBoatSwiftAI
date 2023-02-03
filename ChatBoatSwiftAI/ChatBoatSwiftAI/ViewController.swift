//
//  ViewController.swift
//  ChatBoatSwiftAI
//
//  Created by mac on 04/02/23.
//

import UIKit
import ReverseExtension


class ViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tf: UITextField!

    var chatMessages = [MessageModel]()
    var messageText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view, typically from a nib.
        tblView.re.dataSource = self

        tblView.register(UINib(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "ResultCell")

        tblView.re.delegate = self
        tblView.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
        }
        tblView.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
        tblView.estimatedRowHeight = 56
        tblView.rowHeight = UITableView.automaticDimension

    }


    func sendMessage() {
        messageText = tf.text!
        let userMessage = MessageModel(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .user)
        chatMessages.append(userMessage)
        self.reload()

        APIServiceManager().sendMessage(message: messageText) { response, error in
            guard let response = response else {
                return
            }

            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            let chatAIMessage = MessageModel(id: response.id, content: textResponse, dateCreated: Date(), sender: .chatAI)
            self.chatMessages.append(chatAIMessage)
            self.reload()
        }
    }

    func reload() {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }

    @IBAction func SendAction(_ sender: UIButton) {
        sendMessage()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        (cell as? ResultCell)?.configure(with: chatMessages[indexPath.row])

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
}
