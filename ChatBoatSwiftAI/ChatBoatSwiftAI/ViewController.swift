//
//  ViewController.swift
//  ChatBoatSwiftAI
//
//  Created by Kumar Lav on 04/02/23.

import UIKit
import ReverseExtension
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tv: UITextView!

    var player: AVAudioPlayer?
    var chatMessages = [MessageModel]()
    var messageText = ""
    var isQuestionAsked = false
    enum SoundType: String {
        case send = "receiver"
        case receive = "sender"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.re.dataSource = self

        tblView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tblView.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")

        tblView.re.delegate = self
        tblView.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
        }
        tblView.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
        tblView.rowHeight = UITableView.automaticDimension

    }

    override func viewWillAppear(_ animated: Bool) {
        introduceChatboat()
    }


    func sendMessage() {
        isQuestionAsked = true
        messageText = tv.text!
        let userMessage = MessageModel(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .user)
        chatMessages.append(userMessage)
        self.reload()
        self.playSound(type: .send)

        APIServiceManager().sendMessage(message: messageText) { response, error in
            guard let response = response else {
                return
            }

            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            let chatAIMessage = MessageModel(id: response.id, content: textResponse, dateCreated: Date(), sender: .chatAI)
            self.chatMessages.append(chatAIMessage)
            self.reload()
            self.playSound(type: .receive)
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if chatMessages[indexPath.row].sender == .chatAI {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as? ReceiverCell else
            {return UITableViewCell()}
            cell.delegate = self
            cell.configure(with: chatMessages[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath)
            (cell as? SenderCell)?.configure(with: chatMessages[indexPath.row])
            return cell
        }
    }

}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
}

extension ViewController: ReceiverCellDelegate {
    func copyAnswer(text: String) {
        print(text)
        UIPasteboard.general.string = text
    }

}

extension ViewController {
    func introduceChatboat() {

        let intro = "Hey, My name is Pari"
        let intro2 = "You can ask me anything. It will be my pleasure to answer your questions"
        let intro3 = "Thank you."
        let boatMsg1 = MessageModel(id: UUID().uuidString, content: intro, dateCreated: Date(), sender: .chatAI, hideCopyButton: true)
        let boatMsg2 = MessageModel(id: UUID().uuidString, content: intro2, dateCreated: Date(), sender: .chatAI, hideCopyButton: true)
        let boatMsg3 = MessageModel(id: UUID().uuidString, content: intro3, dateCreated: Date(), sender: .chatAI, hideCopyButton: true)

        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            if !self.isQuestionAsked {
            self.chatMessages.append(boatMsg1)
            self.reload()
            self.playSound(type: .receive)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            if !self.isQuestionAsked {
            self.chatMessages.append(boatMsg2)
            self.reload()
            self.playSound(type: .receive)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+4.8) {
            if !self.isQuestionAsked {
            self.chatMessages.append(boatMsg3)
            self.reload()
            self.playSound(type: .receive)
            }
        }
    }
}


extension ViewController {

    func playSound(type: SoundType) {
        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                guard let player = player else { return }
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
    }

}
