//
//  ChatBoatViewModel.swift
//  ChatBoatSwiftAI
//
//  Created by Kumar Lav on 09/02/23.
//

import Foundation
import AVFoundation

enum SoundType: String {
    case send = "receiver"
    case receive = "sender"
}

protocol ChatBoatViewModelDelegate: AnyObject {
    func reloadChat()
}

class ChatBoatViewModel {

    weak var delegate: ChatBoatViewModelDelegate?
    private var player: AVAudioPlayer?
    var chatMessages = [MessageModel]()
    private var isQuestionAsked = false

    func sendMessage(_ messageText: String) {
        isQuestionAsked = true
        createQuestion(messageText)
        askQuestionToChatBoat(messageText)
    }
}

extension ChatBoatViewModel {
    private func createQuestion(_ messageText: String) {
        let userMessage = MessageModel(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .user)
        chatMessages.append(userMessage)
        delegate?.reloadChat()
        playSound(type: .send)
    }

    private func askQuestionToChatBoat(_ messageText: String) {
        APIServiceManager().sendMessage(message: messageText) { [weak self] response, error in
            guard let response = response else {
                print("error:", error as Any)
                return
            }
            self?.createAnswer(response)
        }
    }

    private func createAnswer(_ response: ModelResponse) {
        guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
        let chatAIMessage = MessageModel(id: response.id, content: textResponse, dateCreated: Date(), sender: .chatAI)
        chatMessages.append(chatAIMessage)
        delegate?.reloadChat()
        playSound(type: .receive)
    }
}

extension ChatBoatViewModel {
    func introduceChatboat() {

        let intro = """
Hey, My name is Pari
You can ask me anything.
It will be my pleasure to answer your questions

Thank you. 🙏🙏
"""

        let boatMsg1 = MessageModel(id: UUID().uuidString, content: intro, dateCreated: Date(), sender: .chatAI, hideCopyButton: true)

        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { [weak self] in
            guard let self = self else { return }
            if !self.isQuestionAsked {
                self.chatMessages.append(boatMsg1)
                self.delegate?.reloadChat()
                self.playSound(type: .receive)
            }
        }
    }
}


extension ChatBoatViewModel {

    private func playSound(type: SoundType) {
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
