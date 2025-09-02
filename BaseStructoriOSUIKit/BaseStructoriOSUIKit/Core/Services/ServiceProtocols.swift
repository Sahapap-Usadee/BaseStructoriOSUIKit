//
//  ServiceProtocols.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import Foundation

// MARK: - Session Error
enum SessionError: Error {
    case tokenExpired
    case unauthorized
    case networkError
}

// MARK: - Network Service
protocol NetworkServiceProtocol {
    func request<T: Codable>(endpoint: String, type: T.Type) async throws -> T
    func upload(data: Data, to endpoint: String) async throws -> Bool
    func downloadImage(from url: String) async throws -> Data
}

class NetworkService: NetworkServiceProtocol {
    private let session = URLSession.shared
    private let baseURL = "https://api.example.com"
    
    func request<T: Codable>(endpoint: String, type: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw NetworkError.serverError
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func upload(data: Data, to endpoint: String) async throws -> Bool {
        // TODO: Implement upload
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        return true
    }
    
    func downloadImage(from url: String) async throws -> Data {
        guard let imageURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await session.data(from: imageURL)
        return data
    }
}

// MARK: - Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case serverError
    case decodingError
    case noInternetConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL ไม่ถูกต้อง"
        case .serverError:
            return "เกิดข้อผิดพลาดจากเซิร์ฟเวอร์"
        case .decodingError:
            return "ไม่สามารถแปลงข้อมูลได้"
        case .noInternetConnection:
            return "ไม่มีการเชื่อมต่ออินเทอร์เน็ต"
        }
    }
}
