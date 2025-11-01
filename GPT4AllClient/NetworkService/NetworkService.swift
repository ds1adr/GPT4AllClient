//
//  NetworkService.swift
//  OllamaClient
//
//  Created by Wontai Ki on 10/26/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case badResponse
    case serviceError(Int)
}

class NetworkService {
    static func fetchData<T: Codable>(router: NetworkRouter) async -> Result<T, NetworkError> {
        guard let request = router.request() else {
            return .failure(.invalidURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let urlResponse = response as? HTTPURLResponse else {
                return .failure(.badResponse)
            }
            
            guard (200...299).contains(urlResponse.statusCode) else {
                return .failure(.serviceError(urlResponse.statusCode))
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            
            return .success(result)
        } catch {
            return .failure(.badResponse)
        }
    }
}
