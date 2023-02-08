//
//  NetworkManager.swift
//  ChatBoatSwiftAI
//
//  Created by Kumar Lav on 04/02/23.
//

import Foundation
import Alamofire
import Combine

class APIServiceManager {
    let baseUrl = "https://api.openai.com/v1/"

    func sendMessage(message: String, completion: @escaping (ModelResponse?, Error?)-> Void) {
        let model = Model(model: "text-davinci-003", prompt: message, temperature: 0.9, max_tokens: 2048)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]

        AF.request(self.baseUrl + "completions", method: .post, parameters: model, encoder: .json, headers: headers).responseDecodable(of: ModelResponse.self) { response in
            switch response.result {
            case.success(let result):
                completion(result, nil)
                print(result)
            case.failure(let error):
                completion(nil, error)
                print(error)
            }
        }
    }
}

