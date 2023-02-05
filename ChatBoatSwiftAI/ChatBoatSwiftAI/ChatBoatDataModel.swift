//
//  ChatBoatDataModel.swift
//  ChatBoatSwiftAI
//
//  Created by Kumar Lav on 04/02/23.
//

import Foundation

struct Model: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}

struct ModelResponse: Decodable {
    let id: String?
    let choices: [ModelChoice]
}

struct ModelChoice: Decodable {
    let text: String
}

struct MessageModel {
    let id: String?
    let content: String
    let dateCreated: Date
    let sender: MessageSender
    var hideCopyButton = false
}

enum MessageSender {
    case user
    case chatAI
}
