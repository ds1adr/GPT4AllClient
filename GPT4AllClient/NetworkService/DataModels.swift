//
//  DataModels.swift
//  GPT4AllClient
//
//  Created by Wontai Ki on 10/31/25.
//

import Foundation

/// Model Object (Response of Models API)
/*
 {
     "data": [
         {
             "created": 0,
             "id": "Llama 3 8B Instruct",
             "object": "model",
             "owned_by": "humanity",
             "parent": null,
             "permissions": [
                 {
                     "allow_create_engine": false,
                     "allow_fine_tuning": false,
                     "allow_logprobs": false,
                     "allow_sampling": false,
                     "allow_search_indices": false,
                     "allow_view": true,
                     "created": 0,
                     "group": null,
                     "id": "placeholder",
                     "is_blocking": false,
                     "object": "model_permission",
                     "organization": "*"
                 }
             ],
             "root": "Llama 3 8B Instruct"
         }
     ],
     "object": "list"
 }
*/
struct ModelResponse: Codable {
    let models: [Model]
    let object: String
    
    enum CodingKeys: String, CodingKey {
        case models = "data"
        case object
    }
}

struct Model: Codable {
    let id: String
    let object: String?
    let ownedBy: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case ownedBy = "owned_by"
    }
}

/// Chat Response
/*
 {
     "choices": [
         {
             "finish_reason": "length",
             "index": 0,
             "logprobs": null,
             "message": {
                 "content": "Lionel Messi is a professional soccer player who plays as a forward for the Spanish club Barcelona and the Argentina national team. He is widely regarded as one of the greatest soccer players of all time, known for his exceptional dribbling skills, speed,",
                 "role": "assistant"
             },
             "references": null
         }
     ],
     "created": 1761796976,
     "id": "placeholder",
     "model": "Llama 3 8B Instruct",
     "object": "chat.completion",
     "usage": {
         "completion_tokens": 50,
         "prompt_tokens": 16,
         "total_tokens": 66
     }
 }
 */
struct Message: Codable {
    let role: String
    let content: String
}

struct Choice: Codable, Identifiable {
    // TODO: Need to check index can be identifiable
    var id: String = UUID().uuidString
    
    let index: Int
    let message: Message
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
    }
}

struct ChatResponse: Codable {
    let choices: [Choice]
    let created: Int
    let id: String
    let model: String
    let object: String
}

/*
 {
 "model": "Llama 3 8B Instruct",
 "messages": [{"role":"user","content":"Who is Lionel Messi?"}],
 "max_tokens": 50,
 "temperature": 0.28
 }
 */
struct ChatRequest: Encodable {
    let model: String
    let messages: [Message]
    let maxTokens: Int = 50
    let temperature: Float = 0.28
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case maxTokens = "max_tokens"
        case temperature
        
    }
    
    init(model: String, chatMessage: String) {
        self.model = model
        let message = Message(role: "user", content: chatMessage)
        self.messages = [message]
    }
}
