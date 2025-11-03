//
//  ChatViewModel.swift
//  GPT4AllClient
//
//  Created by Wontai Ki on 10/31/25.
//

import Foundation
import Combine

@Observable
class ChatViewModel {
    var networkManager = GPT4AllNetworkManager()
    
    var models: [Model] = []
    var choices: [Choice] = []
    var selectedModel: Model? = nil
    
    func getModels() {
        Task {
            do {
                models = try await networkManager.getModels()
                selectedModel = models.first
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func chat(input: String) {
        guard let selectedModelId = selectedModel?.id else {
            // TODO: display 'select model' alert
            return
        }
        
        let choice = Choice(index: choices.count, message: Message(role: "user", content: input))
        choices.append(choice)
        
        let chatRequest = ChatRequest(model: selectedModelId, chatMessage: input)
        Task {
            do {
                let recvChoices = try await networkManager.chat(request: chatRequest)
                choices.append(contentsOf: recvChoices)
            } catch {
                
            }
        }
    }
}
