//
//  ChatNetworkManager.swift
//  OllamaClient
//
//  Created by Wontai Ki on 10/27/25.
//

import Foundation


enum GPT4AllNetworkRouter: NetworkRouter {
    case models
    case chat(ChatRequest)
    
    var apiPath: String {
        switch self {
        case .models:
            return "/v1/models"
        case .chat:
            return "/v1/chat/completions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .models:
            return .GET
        case .chat:
            return .POST
        }
    }
    
    var params: [String : Any]? {
        nil
    }
    
    var body: String? {
        switch self {
        case .chat(let chatRequest):
            if let jsonData = try? JSONEncoder().encode(chatRequest),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
            return nil
        default:
            return nil
        }
    }
}

class GPT4AllNetworkManager {
    func getModels() async throws -> [Model] {
        let result: Result<ModelResponse, NetworkError> = await NetworkService.fetchData(router: GPT4AllNetworkRouter.models)
        switch result {
        case .success(let modelResponse):
            return modelResponse.models
        case .failure(let networkError):
            throw networkError
        }
    }
    
    func chat(request: ChatRequest) async throws -> [Choice] {
        let result: Result<ChatResponse, NetworkError> = await NetworkService.fetchData(router: GPT4AllNetworkRouter.chat(request))
        switch result {
        case .success(let chatResponse):
            return chatResponse.choices
        case .failure(let networkError):
            throw networkError
        }
    }
}
