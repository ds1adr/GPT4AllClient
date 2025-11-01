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
}
