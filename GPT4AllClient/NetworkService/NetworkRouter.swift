//
//  NetworkRouter.swift
//  OllamaClient
//
//  Created by Wontai Ki on 10/26/25.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

protocol NetworkRouter {
    var scheme: String { get }
    var apiHost: String { get }
    var port: Int { get }
    var apiPath: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any]? { get }
    var body: String? { get }
}

extension NetworkRouter {
    var scheme: String { "http" }
    var apiHost: String { "localhost" }
    var port: Int { 4891 }
    
    func request() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = apiHost
        urlComponents.port = port
        urlComponents.path = apiPath
        
        if let params = params {
            var items: [URLQueryItem] = []
            for (key, value) in params {
                let item = URLQueryItem(name: key, value: "\(value)")
                items.append(item)
            }
            urlComponents.queryItems = items
        }
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        

        if let body {
//            let msg = """
//    {
//            "model": "Llama 3 8B Instruct",
//            "messages": [{"role":"user","content":"Who is Lionel Messi?"}],
//            "max_tokens": 50,
//            "temperature": 0.28
//        }
//    """
            request.httpBody = body.data(using: .utf8)
        }
        return request
    }
}
