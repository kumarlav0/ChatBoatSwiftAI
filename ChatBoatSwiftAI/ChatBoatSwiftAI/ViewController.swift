//
//  ViewController.swift
//  ChatBoatSwiftAI
//
//  Created by Kumar Lav on 04/02/23.

import UIKit
import ReverseExtension

class ViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tv: UITextView!

    var chatBoatViewModel = ChatBoatViewModel()
    var flag = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        chatBoatViewModel.introduceChatboat()
    }

    @IBAction func SendAction(_ sender: UIButton) {
        chatBoatViewModel.sendMessage(tv.text!)
    }
}

extension ViewController {
    func setupUI() {
        tblView.re.dataSource = self
        tblView.re.delegate = self
        chatBoatViewModel.delegate = self
        tblView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tblView.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        tblView.register(UINib(nibName: "DotAnimationCell", bundle: nil), forCellReuseIdentifier: "DotAnimationCell")

        tblView.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
        }
        tblView.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
        tblView.rowHeight = UITableView.automaticDimension
        placeHolderForTextView()
    }
    
    func placeHolderForTextView () {
        tv.text = " Ask me anything"
        tv.textColor = UIColor.lightGray
        tv.delegate = self
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = " Ask me anything"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.textColor = UIColor.black
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatBoatViewModel.chatMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let animationCell = tableView.dequeueReusableCell(withIdentifier: "DotAnimationCell", for: indexPath) as? DotAnimationCell else
        { return UITableViewCell() }
        return animationCell
        
        guard indexPath.row < chatBoatViewModel.chatMessages.count else {
            print("The index is out of range.")
            return UITableViewCell()
        }

        let chatObj = chatBoatViewModel.chatMessages[indexPath.row]
    
        if chatObj.sender == .chatAI {
            guard let boatCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as? ReceiverCell else
            { return UITableViewCell() }
            boatCell.delegate = self
            boatCell.configure(with: chatObj)
           
//            if flag == 0 {
//                return animationCell
//            } else {
                return boatCell
           // }
            
        } else {
            guard let questionCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as? SenderCell else { return UITableViewCell() }
            questionCell.configure(with: chatObj)
            return questionCell
        }
    }
}

extension ViewController: ReceiverCellDelegate {
    func receiveMessageFromBoat() {
//        self.flag += 1
//        tblView.reloadData()
    }
    
    func copyAnswer(text: String) {
        UIPasteboard.general.string = text
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
}

extension ViewController: ChatBoatViewModelDelegate {
    func reloadChat() {
        DispatchQueue.main.async { [weak self] in
            self?.tblView.reloadData()
        }
    }
}

/**
Question for Chat GPT

 1. Write a program to check number is prime or not with an example in swift

 2. Write a program to print a pyramid with example in python

 3. What is Agile methodilogy

 4. I love you sweetheart Translate in to Chinese language

 5.


 */
