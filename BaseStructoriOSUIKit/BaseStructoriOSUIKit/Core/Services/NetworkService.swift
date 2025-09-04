//
//  NetworkService.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation
import Combine

// MARK: - Enhanced Network Service Protocol
protocol NetworkServiceProtocol {
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        type: T.Type
    ) async throws -> T
    
    func downloadImage(from url: String) async throws -> Data
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Enhanced Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(String)
    case serverError(Int, String?)
    case unauthorized
    case tokenExpired
    case noInternetConnection
    case timeout
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL ไม่ถูกต้อง"
        case .noData:
            return "ไม่มีข้อมูลตอบกลับ"
        case .decodingError(let message):
            return "ไม่สามารถแปลงข้อมูลได้: \(message)"
        case .serverError(let code, let message):
            return "เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (\(code)): \(message ?? "Unknown error")"
        case .unauthorized:
            return "ไม่มีสิทธิ์เข้าถึง"
        case .tokenExpired:
            return "เซสชันหมดอายุ"
        case .noInternetConnection:
            return "ไม่มีการเชื่อมต่ออินเทอร์เน็ต"
        case .timeout:
            return "หมดเวลาเชื่อมต่อ"
        case .unknown(let error):
            return "เกิดข้อผิดพลาด: \(error.localizedDescription)"
        }
    }
}

// MARK: - Enhanced Network Service Implementation
class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let sessionManager: SessionManagerProtocol
    private let baseURL: String
    
    init(
        baseURL: String = "https://pokeapi.co/api/v2",
        sessionManager: SessionManagerProtocol,
        timeout: TimeInterval = 30.0
    ) {
        self.sessionManager = sessionManager
        self.baseURL = baseURL
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        
        self.session = URLSession(configuration: config)
    }
    
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        headers: [String: String]? = nil,
        body: Data? = nil,
        type: T.Type
    ) async throws -> T {
        
        // Build URL
        let urlString = endpoint.hasPrefix("http") ? endpoint : baseURL + endpoint
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add authorization header if token exists
        if let token = sessionManager.authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(URLError(.badServerResponse))
            }
            
            // Handle response status codes
            switch httpResponse.statusCode {
            case 200...299:
                // Success - continue to decode
                break
            case 401:
                // Unauthorized - handle session expiry
                sessionManager.handleUnauthorized()
                throw NetworkError.unauthorized
            case 403:
                throw NetworkError.unauthorized
            default:
                let errorMessage = String(data: data, encoding: .utf8)
                throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
            }
            
            // Decode response
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(type, from: data)
            } catch let decodingError {
                throw NetworkError.decodingError(decodingError.localizedDescription)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noInternetConnection
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown(urlError)
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    func downloadImage(from url: String) async throws -> Data {
        guard let imageURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: imageURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(0, "Failed to download image")
            }
            
            return data
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noInternetConnection
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown(error)
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
