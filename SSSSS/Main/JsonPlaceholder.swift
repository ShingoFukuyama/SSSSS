//
//  JsonPlaceholder.swift
//  SSSSS
//
//  Created by Shingo Fukuyama on 2025/12/09.
//

import Foundation

struct JsonPlaceholder {
    enum APIError: Swift.Error, LocalizedError {
        case invalidURL
        case decodingError
        case unknown(Error)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .decodingError:
                return "Failed to decode data."
            case let .unknown(error):
                return "Unknown \(error)"
            }
        }
    }

    struct Post: Decodable, Equatable, Identifiable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }

    static func fetchPosts() async -> Result<[Post], APIError> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return .failure(APIError.invalidURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let posts = try JSONDecoder().decode([JsonPlaceholder.Post].self, from: data)
            return .success(posts)
        } catch {
            if error is DecodingError {
                return .failure(APIError.decodingError)
            } else {
                return .failure(APIError.unknown(error))
            }
        }
    }
}
